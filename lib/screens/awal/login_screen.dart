import 'package:flutter/material.dart';
import 'package:lokalmart/screens/awal/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isHovering = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        await _cekDanBuatProfileJikaBelumAda(user.id);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/beranda');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: ${e.toString()}')),
      );
    }
  }

  Future<void> _cekDanBuatProfileJikaBelumAda(String userId) async {
    final supabase = Supabase.instance.client;

    try {
      final data = await supabase
          .from('profile')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      if (data == null) {
        await supabase.from('profile').insert({
          'id': userId,
          'nama': 'Pengguna Baru',
          'alamat': '',
          'no_telepon': '',
          'jenis_kelamin': 'Laki-laki',
          'avatar_url': '',
        });
      }
    } catch (e) {
      debugPrint('Gagal insert atau cek profile: $e');
    }
  }

  Future<void> _loginWithProvider(Provider provider) async {
    await Supabase.instance.client.auth.signInWithOAuth(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E3CB),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hello!',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF424021),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Selamat datang di lokalmart',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9D9A89),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                Image.asset(
                  'assets/images/Logo-icon.png',
                  width: 135,
                ),
              ],
            ),
          ),
          const SizedBox(height: 66),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF424021),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      controller: _emailController,
                      hint: 'Email',
                      iconPath: 'assets/images/mail.png',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _passwordController,
                      hint: 'Kata sandi',
                      iconPath: 'assets/images/icon-lock.png',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          'assets/images/icon-hide.png',
                          width: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Lupa kata sandi?',
                        style: TextStyle(color: Color(0xFF424021)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHovering = true),
                      onExit: (_) => setState(() => _isHovering = false),
                      child: GestureDetector(
                        onTap: _login,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _isHovering
                                ? const Color(0xFF817D51)
                                : const Color(0xFF5B5835),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'atau masuk dengan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _loginWithProvider(Provider.google),
                          child: Image.asset('assets/images/google.png',
                              width: 40),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _loginWithProvider(Provider.facebook),
                          child: Image.asset('assets/images/facebook.png',
                              width: 42),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424021),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6E3CB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF424021)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(iconPath, width: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                style: const TextStyle(
                  color: Color(0xFF424021),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: const TextStyle(color: Color(0xFF424021)),
                ),
              ),
            ),
            if (suffixIcon != null) suffixIcon,
          ],
        ),
      ),
    );
  }
}
