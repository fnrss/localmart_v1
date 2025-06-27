import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch \$url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/Bg-Sriharjo.png',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _pillButton(
                            'Sriharjo',
                            const Color(0xFF5B5835),
                            () => Navigator.pushNamed(context, '/sejarah'),
                          ),
                          const SizedBox(width: 8),
                          _pillButton(
                            'Register',
                            const Color(0xFFB3AF8A),
                            () => Navigator.pushNamed(context, '/register'),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _launchUrl('https://g.co/kgs/jEkQ6ad'),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFB3AF8A),
                          child: Image.asset(
                            'assets/images/Icons-Location.png',
                            height: 27,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'LokalMart menampilkan produk UMKM, budaya, dan pesona '
                    'wisata Sriharjo lengkap dengan info lokasi dan kontak. Dukung '
                    'produk lokal, lestarikan budaya, dan majukan ekonomi desa!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7E7C7C),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('Wisata Sriharjo'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _cardItem('Srikeminut', 'assets/images/card-kali.png',
                          'https://g.co/kgs/nPpj3dU'),
                      _cardItem(
                          'Lembah Sorory',
                          'assets/images/card-sorori.png',
                          'https://g.co/kgs/fZxA3mE'),
                      _cardItem(
                          'Taman Girli Indah',
                          'assets/images/card-Girli.png',
                          'https://maps.app.goo.gl/4VTEmGdRroUU6X267'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Potensi Budaya'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _budayaItem('Sekar Wangi Tari', 'assets/images/Tari.png',
                          'https://jdih.bantulkab.go.id/produkhukum/download/5492/2023/keputusan-bupati-2023-521.pdf.html'),
                      _budayaItem(
                          'Sholawat Mudo Palupi',
                          'assets/images/card-sholawat.png',
                          'https://youtu.be/0WtafW8amDk?si=g_Y7TDCD-IbaC1BF'),
                      _budayaItem(
                          'Jatilan Mudho Langgen',
                          'assets/images/card-jatilan.png',
                          'https://youtu.be/jDZf9wLp7sM?si=Xb-Bam3Hp8hH4B_V'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF5B5835),
        selectedItemColor: const Color(0xFFE6E3CB),
        unselectedItemColor: const Color(0xFFE6E3CB),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/umkm');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'UMKM'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _pillButton(String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7E7C7C)),
      ],
    );
  }

  Widget _cardItem(String title, String imagePath, String url) {
    return Container(
      width: 124,
      decoration: BoxDecoration(
        color: const Color(0xFFB3AF8A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _launchUrl(url),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B5835),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.location_on, size: 10, color: Colors.white),
                        SizedBox(width: 2),
                        Text('Lokasi',
                            style: TextStyle(fontSize: 8, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _budayaItem(String title, String imagePath, String url) {
    return Container(
      width: 124,
      decoration: BoxDecoration(
        color: const Color(0xFFB3AF8A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _launchUrl(url),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B5835),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Selengkapnya',
                      style: TextStyle(fontSize: 8, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
