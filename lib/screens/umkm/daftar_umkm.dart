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
  Set<String> favoriteProdukIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
    fetchFavorit();
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
    } catch (e) {
      print('❌ Error fetchProduk: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> fetchFavorit() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final data = await Supabase.instance.client
        .from('favorit')
        .select('produk_id')
        .eq('user_id', user.id);
    setState(() {
      favoriteProdukIds = {for (var item in data) item['produk_id'] as String};
    });
  }

  Future<void> toggleFavorite(String produkId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    if (favoriteProdukIds.contains(produkId)) {
      await Supabase.instance.client
          .from('favorit')
          .delete()
          .eq('user_id', user.id)
          .eq('produk_id', produkId);
      setState(() {
        favoriteProdukIds.remove(produkId);
      });
    } else {
      await Supabase.instance.client.from('favorit').insert({
        'user_id': user.id,
        'produk_id': produkId,
      });
      setState(() {
        favoriteProdukIds.add(produkId);
      });
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
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-sriharjo.png',
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'UMKM Kalurahan Sriharjo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() => _isLoading = true);
              fetchProduk();
              fetchFavorit();
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
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
                              .map((produk) => _ItemCard(
                                    data: produk,
                                    isFavorit: favoriteProdukIds
                                        .contains(produk['id']),
                                    onToggleFavorit: () =>
                                        toggleFavorite(produk['id']),
                                  ))
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
  final bool isFavorit;
  final VoidCallback onToggleFavorit;

  const _ItemCard({
    required this.data,
    required this.isFavorit,
    required this.onToggleFavorit,
  });

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
                        IconButton(
                          icon: Icon(
                            isFavorit ? Icons.bookmark : Icons.bookmark_border,
                            size: 18,
                          ),
                          onPressed: onToggleFavorit,
                        )
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
