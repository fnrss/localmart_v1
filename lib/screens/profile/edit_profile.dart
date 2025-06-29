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
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();
  String _jenisKelamin = 'Laki-laki';

  String avatarUrl = '';
  Uint8List? imageBytes;
  String? fileName;
  bool isLoading = false;

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
        .select('nama, alamat, no_telepon, jenis_kelamin, avatar_url')
        .eq('id', user.id)
        .maybeSingle();

    if (data != null) {
      setState(() {
        _namaController.text = data['nama'] ?? '';
        _alamatController.text = data['alamat'] ?? '';
        _noTeleponController.text = data['no_telepon'] ?? '';
        _jenisKelamin = data['jenis_kelamin'] ?? 'Laki-laki';
        avatarUrl = data['avatar_url'] ?? '';
      });
    }
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    String? finalAvatarUrl = avatarUrl;

    // Upload avatar baru ke Supabase Storage
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

    // Update data ke Supabase
    await Supabase.instance.client.from('profile').update({
      'nama': _namaController.text.trim(),
      'alamat': _alamatController.text.trim(),
      'no_telepon': _noTeleponController.text.trim(),
      'jenis_kelamin': _jenisKelamin,
      'avatar_url': finalAvatarUrl,
    }).eq('id', user.id);

    setState(() => isLoading = false);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E3CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B5835),
        title: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Avatar
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
                                              'assets/images/Avatar.png'))
                                      as ImageProvider,
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF5B5835),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  size: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Nama
                      _buildTextField(_namaController, 'Nama', validator: true),
                      const SizedBox(height: 16),

                      // Input Alamat
                      _buildTextField(_alamatController, 'Alamat',
                          validator: true),
                      const SizedBox(height: 16),

                      // Input No Telepon
                      _buildTextField(
                        _noTeleponController,
                        'No Telepon',
                        keyboardType: TextInputType.phone,
                        validator: true,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown Jenis Kelamin
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

                      // Tombol Simpan
                      ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B5835),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
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
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool validator = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label tidak boleh kosong';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
