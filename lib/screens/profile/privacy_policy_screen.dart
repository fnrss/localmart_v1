import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Abu background luar
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Custom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Kebijakan Privasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Expanded content dengan background dan sudut melengkung
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6E3CB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Center(
                        child: Text(
                          'Kebijakan Privasi LokalMart',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Terakhir diperbarui: [10 Juni 2025]\n'
                        'Aplikasi LokalMart dikembangkan untuk memberikan informasi dan katalog produk UMKM yang berada di Kalurahan Sriharjo, Imogiri. '
                        'Kami menghargai privasi pengguna dan berkomitmen untuk menjaga serta melindungi data pribadi Anda.\n',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '1. Informasi yang Kami Kumpulkan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Kami dapat mengumpulkan informasi berikut:',
                        style: TextStyle(fontSize: 12),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 4, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Nama dan email saat Anda mendaftar atau mengisi form UMKM.',
                                style: TextStyle(fontSize: 12)),
                            Text('• Informasi produk UMKM yang Anda tambahkan (nama produk, deskripsi, alamat UMKM, kontak).',
                                style: TextStyle(fontSize: 12)),
                            Text('• Gambar produk atau profil yang diunggah ke Firebase Storage.',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        '2. Penggunaan Informasi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 4, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Menampilkan daftar produk UMKM kepada pengguna lain.',
                                style: TextStyle(fontSize: 12)),
                            Text('• Memungkinkan Anda mengelola produk UMKM yang Anda tambahkan.',
                                style: TextStyle(fontSize: 12)),
                            Text('• Meningkatkan layanan dan tampilan aplikasi.',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        '3. Penyimpanan dan Keamanan Data',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Data Anda disimpan secara aman di layanan Firebase Firestore dan Firebase Storage. Kami tidak membagikan informasi pribadi Anda kepada pihak ketiga tanpa izin.\n',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '4. Hak Pengguna',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 4, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Mengakses dan memperbarui informasi yang telah dikirimkan.',
                                style: TextStyle(fontSize: 12)),
                            Text('• Menghapus data produk yang ditambahkan.',
                                style: TextStyle(fontSize: 12)),
                            Text('• Menghubungi pengembang untuk penghapusan akun atau data secara permanen.',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        '5. Perubahan Kebijakan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Kebijakan ini dapat diperbarui sewaktu-waktu. Perubahan akan diinformasikan melalui aplikasi atau halaman khusus kebijakan privasi.\n',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '6. Kontak',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Jika Anda memiliki pertanyaan atau permintaan terkait kebijakan ini, silakan hubungi:\n'
                        'Email: lokalmart.sriharjo@gmail.com',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}