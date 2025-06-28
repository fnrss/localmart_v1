import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritSayaScreen extends StatefulWidget {
  const FavoritSayaScreen({super.key});

  @override
  State<FavoritSayaScreen> createState() => _FavoritSayaScreenState();
}

class _FavoritSayaScreenState extends State<FavoritSayaScreen> {
  List<Map<String, dynamic>> favoritProduk = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorit();
  }

  Future<void> _loadFavorit() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final data = await Supabase.instance.client
        .from('favorit')
        .select('id, produk_id, registrasi_umkm(*)') // join ke produk
        .eq('user_id', userId);

    setState(() {
      favoritProduk = List<Map<String, dynamic>>.from(data);
      _isLoading = false;
    });
  }

  Future<void> _hapusFavorit(String favoritId) async {
    await Supabase.instance.client.from('favorit').delete().eq('id', favoritId);
    _loadFavorit(); // Refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E3CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E3CB),
        title: const Text('Favorit Saya'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoritProduk.isEmpty
              ? const Center(child: Text('Belum ada produk favorit'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoritProduk.length,
                  itemBuilder: (context, index) {
                    final item = favoritProduk[index];
                    final produk = item['registrasi_umkm'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: produk['image_url'] != null
                            ? Image.network(
                                produk['image_url'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image),
                        title: Text(produk['nama'] ?? '-'),
                        subtitle: Text('Rp ${produk['harga'] ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.bookmark_remove),
                          onPressed: () {
                            _hapusFavorit(item['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
