// lib/swiper_slider_page.dart
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// --- 🖼️ Data Gambar Asli (Sesuai Desain Anda) ---
final List<String> _demoImages = [
  'https://i.pinimg.com/736x/ad/32/f6/ad32f60e7a3df2be32552fb1cc839446.jpg', // Gambar Semut
  'https://i.pinimg.com/1200x/d4/22/43/d4224308bad7588e66b58278c63895da.jpg', // Gambar Sunset
  'https://i.pinimg.com/1200x/d4/22/43/d4224308bad7588e66b58278c63895da.jpg', // Gambar Kopi
  'https://i.pinimg.com/736x/ad/32/f6/ad32f60e7a3df2be32552fb1cc839446.jpg', // Gambar Pizza
  'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445', // Gambar Pancake
];

// --- Helper: Widget Slide Gambar (Lazy Loading) ---
Widget _buildImageSlide(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0), // Beri sedikit lengkungan
    child: Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        return progress == null
            ? child
            : const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stack) {
        return const Center(child: Icon(Icons.error, color: Colors.red));
      },
    ),
  );
}

// -----------------------------------------------------------------
// --- 1. HALAMAN MENU UTAMA ---
// -----------------------------------------------------------------
class SwiperSliderPage extends StatelessWidget {
  const SwiperSliderPage({super.key});

  // --- Helper: Membuka Halaman Demo ---
  void _openDemo(BuildContext context, String title, Widget swiperWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SwiperDemoPage(
          title: title,
          swiper: swiperWidget,
        ),
      ),
    );
  }

  // --- Helper: Menampilkan "Not Implemented" ---
  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo ini belum diimplementasikan.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // --- Helper: Membangun Item Menu ---
  Widget _buildMenuItem(BuildContext context, String title) {
    // Ambil tema untuk styling item menu dan widget swiper di dalamnya
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white54 : Colors.grey.shade400;

    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          trailing: Icon(Icons.chevron_right, color: iconColor, size: 20),
          onTap: () {
            // --- 💡 Logika Navigasi untuk SEMUA Demo ---

            // 1. Swiper Horizontal (Default)
            if (title == 'Swiper Horizontal') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                    control: SwiperControl(color: primaryColor),
                    loop: false,
                  ));
            }
            // 2. Swiper Vertical
            else if (title == 'Swiper Vertical') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    pagination: SwiperPagination(
                        alignment: Alignment.centerRight,
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                  ));
            }
            // 3. Space Between Slides
            else if (title == 'Space Between Slides') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    viewportFraction: 0.85, // Menampilkan 85%
                    scale: 0.9, // Mengecilkan yang tidak aktif
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                  ));
            }
            // 4. Multiple Per Page
            else if (title == 'Multiple Per Page') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    // Menampilkan 2 item per halaman (0.5)
                    viewportFraction: 0.5,
                    scale: 0.7,
                  ));
            }
            // 5. Nested Swipers
            else if (title == 'Nested Swipers') {
              final nestedSwiper = Swiper(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => Container(
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(child: Text('Nested $index'))),
                itemCount: 3,
                pagination:
                    const SwiperPagination(alignment: Alignment.centerRight),
              );

              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) {
                      return (index == 1)
                          ? nestedSwiper
                          : _buildImageSlide(_demoImages[index]);
                    },
                    itemCount: 4,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                  ));
            }
            // 6. Infinite Loop Mode
            else if (title == 'Infinite Loop Mode') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) => _buildImageSlide(
                        _demoImages[index % _demoImages.length]),
                    itemCount: 20, // Jumlah virtual
                    loop: true, // 👈 Aktifkan loop
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                  ));
            }

            // --- 💡 PERBAIKAN JALAN PINTAS (MENGHILANGKAN ERROR) ---
            else if (title == '3D Cube Effect' ||
                title == '3D Coverflow Effect' ||
                title == '3D Flip Effect') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    // Kita gunakan STACK karena CUBE/COVERFLOW/FLIP tidak ada di v2.0.4
                    layout: SwiperLayout.STACK,
                    itemWidth: 300.0,
                    itemHeight: 400.0,
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                  ));
            }
            // --- 🔼 AKHIR PERBAIKAN ---

            // 10. Fade Effect
            else if (title == 'Fade Effect') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    // Efek Fade
                    fade: 0.5,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                  ));
            }
            // 11. With Scrollbar
            else if (title == 'With Scrollbar') {
              _showNotImplemented(
                  context); // 'card_swiper' v2 tidak punya scrollbar
            }
            // 12. Thumbs Gallery
            else if (title == 'Thumbs Gallery') {
              // Ini demo kompleks, perlu halaman sendiri
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const _ThumbsGalleryPage()));
            }
            // 13. Parallax
            else if (title == 'Parallax') {
              _showNotImplemented(context); // Memerlukan implementasi kustom
            }
            // 14. Lazy Loading
            else if (title == 'Lazy Loading') {
              // Image.network() sudah lazy loading secara default
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: primaryColor)),
                  ));
            }
            // 15. Progress Pagination
            else if (title == 'Progress Pagination') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    pagination: const SwiperPagination(
                      builder: SwiperPagination
                          .fraction, // v2 tidak punya 'progressbar' bawaan
                    ),
                  ));
            }
            // 16. Fraction Pagination
            else if (title == 'Fraction Pagination') {
              _openDemo(
                  context,
                  title,
                  Swiper(
                    itemBuilder: (context, index) =>
                        _buildImageSlide(_demoImages[index]),
                    itemCount: _demoImages.length,
                    pagination: const SwiperPagination(
                      builder:
                          SwiperPagination.fraction, // 👈 Fraksi (misal: 1/4)
                    ),
                  ));
            }
            // 17. Zoom
            else if (title == 'Zoom') {
              // Ini demo kompleks, perlu halaman sendiri
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const _ZoomDemoPage()));
            } else {
              _showNotImplemented(context);
            }
          },
        ),
        Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Colors.white12 : const Color(0xFFEFEFF4),
            indent: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final containerBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Daftar menu
    final List<String> menuItems = [
      'Swiper Horizontal',
      'Swiper Vertical',
      'Space Between Slides',
      'Multiple Per Page',
      'Nested Swipers',
      'Infinite Loop Mode',
      '3D Cube Effect',
      '3D Coverflow Effect',
      '3D Flip Effect',
      'Fade Effect',
      'With Scrollbar',
      'Thumbs Gallery',
      'Parallax',
      'Lazy Loading',
      'Progress Pagination',
      'Fraction Pagination',
      'Zoom',
    ];

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Swiper Slider'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deskripsi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Framework7 comes with powerful and most modern touch slider ever - Swiper Slider with super flexible configuration and lot, lot of features. Just check the following demos:',
                style: TextStyle(fontSize: 16.0, height: 1.4, color: textColor),
              ),
            ),

            // Daftar Menu
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: containerBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  children: menuItems
                      .map((title) => _buildMenuItem(context, title))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 2. HALAMAN HELPER GENERIC (UNTUK DEMO SEDERHANA) ---
// -----------------------------------------------------------------
class _SwiperDemoPage extends StatelessWidget {
  final String title;
  final Widget swiper;

  const _SwiperDemoPage({
    Key? key,
    required this.title,
    required this.swiper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(title),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Beri ukuran agar Swiper tidak error
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: swiper,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 3. HALAMAN HELPER KHUSUS (UNTUK "Thumbs Gallery") ---
// -----------------------------------------------------------------
class _ThumbsGalleryPage extends StatefulWidget {
  const _ThumbsGalleryPage({Key? key}) : super(key: key);

  @override
  State<_ThumbsGalleryPage> createState() => _ThumbsGalleryPageState();
}

class _ThumbsGalleryPageState extends State<_ThumbsGalleryPage> {
  // Controller untuk sinkronisasi
  final SwiperController _controller = SwiperController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Thumbs Gallery'),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Swiper Utama (Besar)
            Expanded(
              flex: 3,
              child: Swiper(
                controller: _controller, // 👈 Terhubung ke controller
                itemBuilder: (context, index) =>
                    _buildImageSlide(_demoImages[index]),
                itemCount: _demoImages.length,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.grey, activeColor: primaryColor)),
                onIndexChanged: (index) {
                  setState(() {
                    _currentIndex = index; // Update index saat digeser
                  });
                },
              ),
            ),
            const SizedBox(height: 10),

            // 2. Swiper Thumbnail (Kecil)
            Expanded(
              flex: 1,
              child: Swiper(
                itemBuilder: (context, index) {
                  // Beri border jika aktif
                  final bool isActive = index == _currentIndex;
                  return GestureDetector(
                    onTap: () {
                      _controller.move(
                          index); // 👈 Klik thumbnail menggerakkan swiper utama
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: isActive
                            ? Border.all(
                                color: primaryColor,
                                width: 3.0) // Warna ikut tema
                            : null,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: _buildImageSlide(_demoImages[index]),
                    ),
                  );
                },
                itemCount: _demoImages.length,
                viewportFraction: 0.3,
                scale: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 4. HALAMAN HELPER KHUSUS (UNTUK "Zoom") ---
// -----------------------------------------------------------------
class _ZoomDemoPage extends StatelessWidget {
  const _ZoomDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Zoom'),
            centerTitle: true,
          ),
        ),
      ),
      body: Swiper(
        itemBuilder: (context, index) {
          // Bungkus gambar dengan InteractiveViewer untuk zoom
          return InteractiveViewer(
            panEnabled: false,
            minScale: 1.0,
            maxScale: 4.0,
            child: _buildImageSlide(_demoImages[index]),
          );
        },
        itemCount: _demoImages.length,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: Colors.grey, activeColor: primaryColor)),
      ),
    );
  }
}
