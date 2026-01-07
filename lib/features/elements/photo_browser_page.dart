import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class PhotoBrowserPage extends StatelessWidget {
  const PhotoBrowserPage({super.key});

  // --- 5 Data Gambar Dummy ---
  static const List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470', // 1. Beach (Utama)
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb', // 2. Landscape nature
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b', // 3. Mountain
    'https://images.unsplash.com/photo-1472214103451-9374bd1c798e', // 4. Hills
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05', // 5. Foggy forest
  ];

  // --- Helper Widget: Judul (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.0,
          height: 1.4,
          color: textColor, // Mengikuti tema
        ),
      ),
    );
  }

  // --- Helper Widget: Bullet Point (Dinamis) ---
  Widget _buildBulletPoint(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor)), // Mengikuti tema
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 15.0,
                  height: 1.4,
                  color: textColor), // Mengikuti tema
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget: Tombol (Dinamis) ---
  Widget _buildPurpleButton(BuildContext context, String label,
      VoidCallback onPressed, Color buttonColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: buttonColor, // Mengikuti tema (primaryColor)
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // --- LOGIKA PEMBUKA PHOTO BROWSER ---
  // (Sekarang tidak perlu parameter darkTheme manual, karena viewer mengambil dari Provider)

  // 1. Mode Standalone (Fullscreen Dialog)
  void _openStandalone(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const _PhotoBrowserViewer(
          images: _imageUrls,
          mode: PhotoBrowserMode.standalone,
        ),
      ),
    );
  }

  // 2. Mode Popup (Dialog Mengambang di Tengah)
  void _openPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              // Background container popup mengikuti tema juga (opsional)
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: const _PhotoBrowserViewer(
                images: _imageUrls,
                mode: PhotoBrowserMode.popup,
              ),
            ),
          ),
        );
      },
    );
  }

  // 3. Mode Page (Navigasi Push Biasa)
  void _openPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const _PhotoBrowserViewer(
          images: _imageUrls,
          mode: PhotoBrowserMode.page,
        ),
      ),
    );
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

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final titleColor = isDark ? Colors.white : Colors.black;
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
            foregroundColor: titleColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Photo Browser'),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescription(
              'Photo Browser is a standalone and highly configurable component that allows to open window with photo viewer and navigation elements with the following features:',
              textColor,
            ),
            _buildBulletPoint('Swiper between photos', textColor),
            _buildBulletPoint('Multi-gestures support for zooming', textColor),
            _buildBulletPoint('Toggle zoom by double tap on photo', textColor),
            _buildBulletPoint(
                'Single click on photo to toggle Exposition mode', textColor),
            const SizedBox(height: 16),

            _buildDescription(
              'Photo Browser could be opened in a three ways - as a Standalone component (Popup modification), in Popup, and as separate Page:',
              textColor,
            ),

            const SizedBox(height: 8),
            // Tombol Navigasi (Sekarang satu set tombol yang dinamis)
            Row(
              children: [
                _buildPurpleButton(context, 'Standalone',
                    () => _openStandalone(context), primaryColor),
                _buildPurpleButton(
                    context, 'Popup', () => _openPopup(context), primaryColor),
                _buildPurpleButton(
                    context, 'Page', () => _openPage(context), primaryColor),
              ],
            ),

            const SizedBox(height: 16),
            _buildDescription(
              'The viewer will automatically adapt to the current application theme (Light or Dark).',
              textColor.withOpacity(0.7),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// --- ENUM UNTUK MODE ---
// ---------------------------------------------------------
enum PhotoBrowserMode { standalone, popup, page }

// ---------------------------------------------------------
// --- WIDGET VIEWER (UNIFIED UI & THEME AWARE) ---
// ---------------------------------------------------------
class _PhotoBrowserViewer extends StatefulWidget {
  final List<String> images;
  final PhotoBrowserMode mode;

  const _PhotoBrowserViewer({
    required this.images,
    required this.mode,
  });

  @override
  State<_PhotoBrowserViewer> createState() => _PhotoBrowserViewerState();
}

class _PhotoBrowserViewerState extends State<_PhotoBrowserViewer> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider untuk DETAIL FOTO
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna Viewer
    // Mode Gelap: Background Hitam Penuh, Teks Putih
    // Mode Terang: Background Putih, Teks Hitam
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color contentColor = isDark ? Colors.white : Colors.black;

    // Background kontrol (AppBar/Footer) semi-transparan
    final Color controlsBgColor =
        isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.9);

    return Scaffold(
      backgroundColor: backgroundColor, // Background mengikuti tema
      body: Stack(
        children: [
          // 1. IMAGE SLIDER
          GestureDetector(
            onTap: _toggleControls,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                            child:
                                CircularProgressIndicator(color: contentColor));
                      },
                      errorBuilder: (context, error, stackTrace) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image,
                              color: Colors.grey, size: 50),
                          Text("Failed to load",
                              style: TextStyle(color: contentColor)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. HEADER
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: _showControls ? 0 : -80,
            left: 0,
            right: 0,
            child: Container(
              color: controlsBgColor, // Background header dinamis
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Text(
                      '${_currentIndex + 1} of ${widget.images.length}',
                      style: TextStyle(
                        color: contentColor, // Warna teks dinamis
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.close, color: contentColor, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. FOOTER
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              color: controlsBgColor, // Background footer dinamis
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Image number ${_currentIndex + 1}',
                      style: TextStyle(
                          color: contentColor, // Warna teks dinamis
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: contentColor.withOpacity(0.8)),
                          onPressed: () {
                            if (_currentIndex > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                        Row(
                          children: List.generate(
                              3,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: index == 1
                                                  ? contentColor
                                                  : contentColor
                                                      .withOpacity(0.24),
                                              width: index == 1 ? 2 : 1),
                                          image: DecorationImage(
                                              image: NetworkImage(widget.images[
                                                  (index + _currentIndex) %
                                                      widget.images.length]),
                                              fit: BoxFit.cover)),
                                    ),
                                  )),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward,
                              color: contentColor.withOpacity(0.8)),
                          onPressed: () {
                            if (_currentIndex < widget.images.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
