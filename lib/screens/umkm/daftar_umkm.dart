import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DaftarUMKMScreen extends StatefulWidget {
  const DaftarUMKMScreen({super.key});

  @override
  State<DaftarUMKMScreen> createState() => _DaftarUMKMScreenState();
}

class _DaftarUMKMScreenState extends State<DaftarUMKMScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> produkUMKM = [];
  List<Map<String, dynamic>> _filteredProduk = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();

    _searchController.addListener(() {
      final keyword = _searchController.text.toLowerCase();
      setState(() {
        _filteredProduk = produkUMKM
            .where((produk) =>
                (produk['nama'] ?? '').toLowerCase().contains(keyword) ||
                (produk['deskripsi'] ?? '').toLowerCase().contains(keyword))
            .toList();
      });
    });
  }

  Future<void> fetchProduk() async {
    try {
      final data = await Supabase.instance.client
          .from('registrasi_umkm')
          .select()
          .order('id', ascending: false);

      setState(() {
        produkUMKM = List<Map<String, dynamic>>.from(data);
        _filteredProduk = List.from(produkUMKM);
        _isLoading = false;
      });
    } catch (e, stack) {
      print('❌ Error fetchProduk: $e');
      print('📍 Stacktrace: $stack');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E3CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E3CB),
        elevation: 0,
        title: const Text(
          'UMKM Kalurahan Sriharjo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              fetchProduk();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temukan Produk UMKM Kesukaanmu!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Colors.black45),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Mau cari UMKM apa?',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProduk.isEmpty
                      ? const Center(child: Text('Produk tidak ditemukan'))
                      : GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                          children: _filteredProduk
                              .map((produk) => _ItemCard(produk))
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF5B5835),
        selectedItemColor: const Color(0xFFE6E3CB),
        unselectedItemColor: const Color(0xFFE6E3CB),
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/beranda');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/umkm');
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
}

class _ItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ItemCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: (data['image_url'] ?? '').toString().isNotEmpty
                  ? Image.network(
                      data['image_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    )
                  : const Icon(Icons.image_not_supported),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['nama'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Rp ${data['harga'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        data['deskripsi'] ?? '',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if ((data['lokasi'] ?? '').toString().isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.location_on, size: 16),
                            onPressed: () async {
                              final url = data['lokasi'];
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url),
                                    mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Tidak dapat membuka link lokasi')),
                                );
                              }
                            },
                          ),
                        const Icon(Icons.bookmark_border, size: 16),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
