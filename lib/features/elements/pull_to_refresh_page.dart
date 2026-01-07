// lib/pull_to_refresh_page.dart
import 'package:flutter/material.dart';

class PullToRefreshPage extends StatefulWidget {
  const PullToRefreshPage({super.key});

  @override
  State<PullToRefreshPage> createState() => _PullToRefreshPageState();
}

class _PullToRefreshPageState extends State<PullToRefreshPage> {
  // Definisi Warna
  static const Color framework7Purple = Color(0xFF9147FF);
  static const Color dividerColor = Color(0xFFEFEFF4);

  // --- Data Musik Awal ---
  List<Map<String, String>> _dataList = [
    {
      'title': 'Yellow Submarine',
      'subtitle': 'Beatles',
      'color': '0xFF9400D3' // Warna ungu gelap untuk dummy image
    },
    {
      'title': 'Don\'t Stop Me Now',
      'subtitle': 'Queen',
      'color': '0xFF4B0082' // Warna indigo untuk dummy image
    },
    {
      'title': 'Billie Jean',
      'subtitle': 'Michael Jackson',
      'color': '0xFF00BFFF' // Warna biru muda untuk dummy image
    },
  ];

  // --- Fungsi Pull To Refresh ---
  Future<void> _handleRefresh() async {
    // Simulasi proses loading/pengambilan data
    await Future.delayed(const Duration(seconds: 2));

    // Tambahkan item baru ke data
    setState(() {
      final newItemIndex = _dataList.length + 1;
      _dataList.insert(
        0,
        {
          'title': 'New Song $newItemIndex',
          'subtitle': 'New Artist',
          'color': '0xFF808080' // Warna abu-abu untuk item baru
        },
      );
    });
  }

  // --- Widget Kustom untuk Item Daftar ---
  Widget _buildListItem(Map<String, String> item) {
    // Parsing string warna menjadi objek Color
    final Color itemColor = Color(int.parse(item['color']!));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Gambar Album (Menggunakan Container warna sebagai placeholder)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: LinearGradient(
                    colors: [itemColor, itemColor.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                //  // Placeholder visual
              ),
              const SizedBox(width: 12),
              
              // Judul dan Subjudul
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // Judul tebal
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54, // Subjudul sedikit pudar
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Ikon Panah (Sesuai desain menu F7)
              Icon(
                Icons.chevron_right, 
                color: Colors.grey.shade400, 
                size: 20
              ),
            ],
          ),
        ),
        // Garis pemisah antar item
        const Divider(height: 1, thickness: 1, color: dividerColor, indent: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- AppBar ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Pull To Refresh'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body dengan RefreshIndicator ---
      body: RefreshIndicator(
        color: framework7Purple,
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Memastikan bisa ditarik meskipun daftar pendek
          slivers: <Widget>[
            // Sliver untuk Daftar Item
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Jika item terakhir, tampilkan teks deskripsi
                  if (index >= _dataList.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Just pull page down to let the magic happen.',
                            style: TextStyle(fontSize: 16.0, height: 1.5, color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Note that pull-to-refresh feature is optimised for touch and native scrolling so it may not work on desktop browser.',
                            style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildListItem(_dataList[index]);
                },
                // Hitung jumlah item + 1 untuk teks deskripsi
                childCount: _dataList.length + 1, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}