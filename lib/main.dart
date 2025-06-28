import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Screens
import 'package:lokalmart/screens/awal/awal_screen.dart';
import 'package:lokalmart/screens/awal/login_screen.dart';
import 'screens/awal/signup_screen.dart';
import 'screens/home/beranda_screen.dart';
import 'screens/home/sejarah_screen.dart';
import 'screens/umkm/register_umkm.dart';
import 'package:lokalmart/screens/umkm/daftar_umkm.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile.dart';
import 'package:lokalmart/screens/profile/privacy_policy_screen.dart';
import 'package:lokalmart/screens/profile/keamanan_screen.dart';
import 'package:lokalmart/screens/profile/favorit_saya.dart'; // ← Tambahan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dffdwxmtfytpnndzxdch.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmZmR3eG10Znl0cG5uZHp4ZGNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5NTE1MzYsImV4cCI6MjA2NjUyNzUzNn0.QFhEjWLiT8ezRgIXrk5IT_FCbDw8b58lEispzerWWWQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LokalMart',
      home: const AwalScreen(),
      routes: {
        '/awal': (context) => const AwalScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/beranda': (context) => const BerandaScreen(),
        '/sejarah': (context) => const SejarahSriharjoScreen(),
        '/register': (context) => const RegisterUmkmScreen(),
        '/umkm': (context) => const DaftarUMKMScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/editProfile': (context) => const EditProfileScreen(),
        '/kebijakan': (context) => const PrivacyPolicyScreen(),
        '/keamanan': (context) => const KeamananScreen(),
        '/favorite': (context) => const FavoritSayaScreen(), // ← Rute baru
      },
    );
  }
}
