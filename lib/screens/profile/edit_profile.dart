import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _umurController = TextEditingController();
  String _jenisKelamin = 'Laki-laki';

  String avatarUrl = '';
  Uint8List? imageBytes;
  String? fileName;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await Supabase.instance.client
        .from('profile')
        .select('nama, alamat, umur, jenis_kelamin, avatar_url')
        .eq('id', user.id)
        .single();

    setState(() {
      _namaController.text = data['nama'] ?? '';
      _alamatController.text = data['alamat'] ?? '';
      _umurController.text = (data['umur'] ?? '').toString();
      _jenisKelamin = data['jenis_kelamin'] ?? 'Laki-laki';
      avatarUrl = data['avatar_url'] ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageBytes = await picked.readAsBytes();
      fileName = const Uuid().v4();
      setState(() {
        avatarUrl = '';
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    String? finalAvatarUrl = avatarUrl;

    if (imageBytes != null && fileName != null) {
      final storage = Supabase.instance.client.storage;
      final path = 'avatar/$fileName.jpg';

      await storage.from('avatar').uploadBinary(
            path,
            imageBytes!,
            fileOptions: const FileOptions(upsert: true),
          );

      finalAvatarUrl = storage.from('avatar').getPublicUrl(path);
    }

    await Supabase.instance.client.from('profile').update({
      'nama': _namaController.text,
      'alamat': _alamatController.text,
      'umur': int.tryParse(_umurController.text),
      'jenis_kelamin': _jenisKelamin,
      'avatar_url': finalAvatarUrl,
    }).eq('id', user.id);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E3CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B5835), // Coklat tua
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!)
                          : (avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : const AssetImage(
                                  'assets/images/Avatar.png')) as ImageProvider,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5B5835),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_namaController, 'Nama'),
              const SizedBox(height: 16),
              _buildTextField(_alamatController, 'Alamat'),
              const SizedBox(height: 16),
              _buildTextField(
                _umurController,
                'Umur',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _jenisKelamin,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(
                      value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _jenisKelamin = val);
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B5835), // Coklat tua
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
