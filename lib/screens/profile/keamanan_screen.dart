import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KeamananScreen extends StatefulWidget {
  const KeamananScreen({super.key});

  @override
  State<KeamananScreen> createState() => _KeamananScreenState();
}

class _KeamananScreenState extends State<KeamananScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final email = Supabase.instance.client.auth.currentUser?.email;
    if (email == null) {
      _showMessage('User tidak ditemukan');
      return;
    }

    try {
      // Verifikasi password lama
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: _oldPasswordController.text,
      );

      if (res.user == null) {
        _showMessage('Password lama salah');
        return;
      }

      // Ubah password
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _newPasswordController.text),
      );

      if (mounted) {
        _showMessage('Password berhasil diubah');
        Navigator.pop(context);
      }
    } catch (e) {
      _showMessage('Gagal: ${e.toString()}');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E3CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B5835),
        title: const Text(
          'Ubah Password',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Keamanan Akun',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF5B5835),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _oldPasswordController,
                label: 'Password Lama',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _newPasswordController,
                label: 'Password Baru',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Konfirmasi Password',
                validator: (val) => val == _newPasswordController.text
                    ? null
                    : 'Password tidak cocok',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B5835),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _updatePassword,
                child: const Text(
                  'Simpan Password',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator ??
          (val) => val != null && val.length >= 6 ? null : 'Minimal 6 karakter',
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
