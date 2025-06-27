import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterUmkmScreen extends StatefulWidget {
  const RegisterUmkmScreen({super.key});

  @override
  State<RegisterUmkmScreen> createState() => _RegisterUmkmScreenState();
}

class _RegisterUmkmScreenState extends State<RegisterUmkmScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  XFile? _selectedImage;
  String? _uploadedImageUrl;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _selectedImage = pickedFile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Gambar dipilih, akan diupload saat submit')),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih gambar terlebih dahulu')),
        );
        return;
      }

      try {
        final fileBytes = await _selectedImage!.readAsBytes();
        final fileExt = path.extension(_selectedImage!.path);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
        final filePath = 'produk/$fileName';

        final storage = Supabase.instance.client.storage;
        await storage.from('gambar').uploadBinary(filePath, fileBytes);
        final publicUrl = storage.from('gambar').getPublicUrl(filePath);

        setState(() {
          _uploadedImageUrl = publicUrl;
        });

        await Supabase.instance.client.from('registrasi_umkm').insert({
          'nama': _namaController.text,
          'harga': int.tryParse(_hargaController.text) ?? 0,
          'deskripsi': _deskripsiController.text,
          'image_url': publicUrl,
          'lokasi': _lokasiController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan')),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan produk: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                height: 28,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Register UMKM',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6E3CB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Tambahkan Produk UMKM',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLabel('Nama UMKM'),
                        _buildInput(_namaController),
                        const SizedBox(height: 20),
                        _buildLabel('Harga UMKM'),
                        _buildInput(_hargaController,
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 20),
                        _buildLabel('Deskripsi UMKM'),
                        _buildInput(_deskripsiController, maxLines: 4),
                        const SizedBox(height: 20),
                        _buildLabel('Link Lokasi (Google Maps)'),
                        _buildInput(_lokasiController),
                        const SizedBox(height: 20),
                        _buildLabel('Foto Produk'),
                        Container(
                          height: 60,
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF5B5835)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD2D2D2),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              fixedSize: const Size(50, 45),
                            ),
                            child: Text(
                              _selectedImage == null
                                  ? 'Pilih Gambar'
                                  : 'Ganti Gambar',
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        if (_selectedImage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: kIsWeb
                                  ? Image.network(_selectedImage!.path,
                                      height: 150, fit: BoxFit.cover)
                                  : Image.file(File(_selectedImage!.path),
                                      height: 150, fit: BoxFit.cover),
                            ),
                          ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B5835),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text(
                                'Tambah Produk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: double.infinity,
      height: maxLines == 1 ? 60 : 137,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF5B5835)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        validator: (value) {
          if (value == null || value.isEmpty) return 'Wajib diisi';
          return null;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
