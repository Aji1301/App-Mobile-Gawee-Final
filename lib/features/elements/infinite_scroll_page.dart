import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class InfiniteScrollPage extends StatefulWidget {
  const InfiniteScrollPage({super.key});

  @override
  State<InfiniteScrollPage> createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  final ScrollController _scrollController = ScrollController();

  // Batas maksimum item
  final int maxItems = 200;

  // Jumlah item yang saat ini dimuat
  List<String> _items = [];
  int _loadCount = 15; // Jumlah awal item yang dimuat
  bool _isLoading = false; // Status loading untuk mencegah pemuatan ganda
  bool _hasMore = true; // Apakah masih ada item yang perlu dimuat

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar awal
    _loadInitialData();
    // Menambahkan listener untuk mendeteksi scroll ke bawah
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    for (int i = 1; i <= _loadCount; i++) {
      _items.add('Item $i');
    }
  }

  // Fungsi untuk memuat data baru
  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    // Simulasi penundaan jaringan
    await Future.delayed(const Duration(milliseconds: 1000));

    int newIndex = _items.length + 1;
    int itemsToAdd = 15;

    // Batasi penambahan item agar tidak melebihi maxItems
    if (newIndex + itemsToAdd > maxItems) {
      itemsToAdd = maxItems - _items.length;
      _hasMore = false;
    }

    // Tambahkan item baru ke daftar
    List<String> newItems = [];
    for (int i = 0; i < itemsToAdd; i++) {
      newItems.add('Item ${newIndex + i}');
    }

    setState(() {
      _items.addAll(newItems);
      _isLoading = false;
    });
  }

  // Listener untuk mendeteksi posisi scroll
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Pengguna mencapai bagian bawah
      _loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          'Infinite Scroll',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Scroll bottom',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor, // Mengikuti tema
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _items.length +
                  (_hasMore ? 1 : 0), // Tambahkan 1 untuk indikator loading
              itemBuilder: (context, index) {
                if (index == _items.length && _hasMore) {
                  // Widget loading di bagian bawah
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                    ),
                  );
                }

                // Item List
                return ListTile(
                  title: Text(
                    _items[index],
                    style: TextStyle(color: textColor), // Mengikuti tema
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 0,
                  ),
                  dense: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
