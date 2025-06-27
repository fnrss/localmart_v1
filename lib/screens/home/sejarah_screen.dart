import 'package:flutter/material.dart';

class SejarahSriharjoScreen extends StatelessWidget {
  const SejarahSriharjoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header: Back + Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: SizedBox(
                height: 28,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/beranda'),
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Sejarah Sriharjo',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Body Container
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo-sriharjo.png',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Kalurahan Sriharjo',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sejarah Kalurahan Sriharjo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Kalurahan Sriharjo dibentuk pada tahun 1946. Sedangkan nama ‘Sriharjo’ diambil dari geografi wilayah dan mata pencaharian penduduk. '
                        'Menurut mitos Jawa, kata ‘Sriharjo’ adalah pemberian dari Dewi Sri dan ‘harjo’ yaitu raharjo atau sejahtera. Jadi, nama Sriharjo berarti desa yang sejahtera dengan mata pencaharian pokok warganya adalah bercocok tanam.',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kalurahan Sriharjo awalnya merupakan penggabungan tiga kalurahan lama, yaitu:',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 8),
                      _buildNumberedList([
                        'Kalurahan Mojohuro',
                        'Kalurahan Dogongan',
                        'Kalurahan Kedungmiri',
                      ]),
                      const SizedBox(height: 12),
                      const Text(
                        'Kantor sementara pada waktu penggabungan bertempat di rumah Bapak Sosro Margono di Padukuhan Mojohuro. '
                        'Pada tahun 1951 dibangun kantor baru Pemerintah Kalurahan Sriharjo di atas tanah kas desa di wilayah Padukuhan Mojohuro.',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Berikut pembagian wilayah padukuhan Kalurahan Sriharjo pada saat itu:',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 8),
                      _buildNumberedList([
                        'Padukuhan Miri',
                        'Padukuhan Jati',
                        'Padukuhan Mojohuro',
                        'Padukuhan Pelemadu',
                        'Padukuhan Sungapan',
                        'Padukuhan Gondosuli',
                        'Padukuhan Trukan',
                        'Padukuhan Dogongan',
                        'Padukuhan Ketos',
                        'Padukuhan Ngrancah',
                        'Padukuhan Pengkol',
                        'Padukuhan Sompok',
                        'Padukuhan Wunut',
                      ]),
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

  Widget _buildNumberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '${index + 1}. ${items[index]}',
            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          ),
        );
      }),
    );
  }
}
