import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// ----------------------------------------------------
// 1. Navbar Options Page (Gambar 1)
// ----------------------------------------------------
class NavbarOptionsPage extends StatelessWidget {
  const NavbarOptionsPage({super.key});

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
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final cardColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Navbar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Right',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor, // Mengikuti tema
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Teks Pengantar
            Text(
              'Navbar is a fixed (with Fixed and Through layout types) area at the top of a screen that contains Page title and navigation elements.',
              style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Navbar has 3 main parts: Left, Title and Right. Each part may contain any HTML content.',
              style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
            ),
            const SizedBox(height: 24),

            // Tombol "Hide Navbar On Scroll"
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HideNavbarOnScrollPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: dividerColor, width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hide Navbar On Scroll',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    Icon(Icons.chevron_right,
                        color: isDark ? Colors.white54 : Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. Hide Navbar On Scroll Page (Gambar 2)
// ----------------------------------------------------
class HideNavbarOnScrollPage extends StatefulWidget {
  const HideNavbarOnScrollPage({super.key});

  @override
  State<HideNavbarOnScrollPage> createState() => _HideNavbarOnScrollPageState();
}

class _HideNavbarOnScrollPageState extends State<HideNavbarOnScrollPage> {
  final ScrollController _scrollController = ScrollController();
  final double _navbarHeight = kToolbarHeight + 1.0;
  bool _isNavbarVisible = true;
  double _lastScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final currentScroll = _scrollController.offset;
    const scrollThreshold = 50.0;

    if (!_scrollController.hasClients) return;

    if (currentScroll > _lastScrollOffset &&
        currentScroll > _navbarHeight + 10) {
      if (_isNavbarVisible &&
          currentScroll - _lastScrollOffset > scrollThreshold) {
        setState(() {
          _isNavbarVisible = false;
        });
        _lastScrollOffset = currentScroll;
      }
    } else if (currentScroll < _lastScrollOffset) {
      if (!_isNavbarVisible &&
          _lastScrollOffset - currentScroll > scrollThreshold) {
        setState(() {
          _isNavbarVisible = true;
        });
        _lastScrollOffset = currentScroll;
      }
    }
    if (currentScroll <= 0) {
      if (!_isNavbarVisible) {
        setState(() {
          _isNavbarVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Warna Dinamis
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // Menggunakan Stack untuk menempatkan custom AppBar di atas body
      body: Stack(
        children: <Widget>[
          // --- Body Halaman (Daftar Panjang) ---
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(top: _navbarHeight),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Navbar will be hidden if you scroll bottom',
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...List.generate(15, (index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quos maxime incidunt id ab culpa ipsa omnis eos, vel excepturi officiis neque illum perferendis dolorum magni rerum natus dolore nulla ex.\n\nEum dolore, amet enim quaerat omnis. Modi minus voluptatum quam veritatis assumenda, eligendi minima dolore in autem delectus sequi accusantium? Cupiditate praesentium autem eius, esse ratione consequatur dolor minus error.\n\nRepellendus ipsa sint quisquam delectus dolore quidem odio, praesentium, sequi temporibus amet architecto? Commodi molestiae, in repellat fugit Laudantium, fuga quia officiis error. Provident inventore iusto quas iure, expedita optio.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                );
              }),
            ],
          ),

          // --- Custom Animated AppBar (Navbar) ---
          _HiddenAppBar(
            isVisible: _isNavbarVisible,
            height: _navbarHeight,
            bgColor: appBarBgColor,
            textColor: textColor,
            dividerColor: dividerColor,
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 3. Custom Animated AppBar (Dinamis)
// ----------------------------------------------------
class _HiddenAppBar extends StatelessWidget {
  final bool isVisible;
  final double height;
  final Color bgColor;
  final Color textColor;
  final Color dividerColor;

  const _HiddenAppBar({
    required this.isVisible,
    required this.height,
    required this.bgColor,
    required this.textColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      top: isVisible ? 0 : -height,
      left: 0,
      right: 0,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
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
          title: const Text(
            'Hide Navbar On Scroll',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: false,
        ),
      ),
    );
  }
}
