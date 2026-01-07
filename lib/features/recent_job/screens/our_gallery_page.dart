// lib/features/recent_job/screens/our_gallery_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// Import Custom Drawer Anda
import '../../../widgets/custom_drawer.dart';

class OurGalleryScreen extends StatefulWidget {
  final List<Map<String, String>> images;

  const OurGalleryScreen({required this.images, super.key});

  @override
  _OurGalleryScreenState createState() => _OurGalleryScreenState();
}

class _OurGalleryScreenState extends State<OurGalleryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.images.isNotEmpty) {
      _pageController.addListener(() {
        if (_pageController.page != null &&
            _pageController.page!.round() != _currentPage) {
          setState(() {
            _currentPage = _pageController.page!.round();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // 2. Tentukan Warna berdasarkan Tema
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    // Warna background bottom bar: Light mode pakai tint primary, Dark mode pakai card color
    final bottomBarColor =
        isDark ? themeProvider.cardColor : primaryColor.withOpacity(0.1);
    final disabledIconColor = isDark ? Colors.white24 : Colors.grey.shade400;

    final totalImages = widget.images.length;

    if (widget.images.isEmpty) {
      return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          title: Text('Our Gallery', style: TextStyle(color: textColor)),
          backgroundColor: scaffoldBgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: Center(
          child: Text(
            'Tidak ada gambar di galeri.',
            style: TextStyle(color: textColor),
          ),
        ),
      );
    }

    final currentImage = widget.images[_currentPage];

    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: 320,
        child: Drawer(
          child: CustomDrawerBody(),
        ),
      ),
      backgroundColor: scaffoldBgColor, // Background dinamis
      appBar: AppBar(
        // Style AppBar mengikuti tema
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor), // Icon dinamis
          onPressed: () => Navigator.of(context).pop(),
        ),

        // Judul AppBar: "X of Total"
        title: Text(
          '${_currentPage + 1} of $totalImages',
          style: TextStyle(
            color: textColor, // Teks dinamis
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          // Tombol titik-tiga untuk membuka drawer
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor), // Icon dinamis
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // PageView: Tampilan Gambar Utama
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalImages,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  child: Center(
                    child: Image.asset(
                      widget.images[index]['url']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      // ERROR BUILDER DIHAPUS agar tidak menampilkan pesan error
                    ),
                  ),
                );
              },
            ),
          ),

          // Bagian Bottom Bar (Caption dan Navigasi) - Sesuai Screenshot
          Container(
            // Warna latar belakang bottom bar dinamis
            color: bottomBarColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol Kiri (Panah)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30,
                  color: _currentPage > 0
                      ? primaryColor
                      : disabledIconColor, // Warna disable dinamis
                  onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                ),

                // Caption
                Expanded(
                  child: Text(
                    currentImage['caption']!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor, // Teks caption dinamis
                    ),
                  ),
                ),

                // Tombol Kanan (Panah)
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  iconSize: 30,
                  color: _currentPage < totalImages - 1
                      ? primaryColor
                      : disabledIconColor, // Warna disable dinamis
                  onPressed:
                      _currentPage < totalImages - 1 ? _goToNextPage : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}