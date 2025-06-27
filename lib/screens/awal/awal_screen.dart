import 'dart:async';
import 'package:flutter/material.dart';

class AwalScreen extends StatefulWidget {
  const AwalScreen({super.key});

  @override
  State<AwalScreen> createState() => _AwalScreenState();
}

class _AwalScreenState extends State<AwalScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi otomatis ke halaman login setelah 5 detik
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE6E3CB), Color(0xE55B5835)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_lokalmart.png',
              width: 320,
              height: 320,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF424021), Color(0xFF9E9A47)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
              blendMode: BlendMode.srcIn,
              child: const Text(
                'LokalMart',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
