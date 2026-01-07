// lib/skeleton_layout_page.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class SkeletonLayoutPage extends StatefulWidget {
  const SkeletonLayoutPage({super.key});

  @override
  State<SkeletonLayoutPage> createState() => _SkeletonLayoutPageState();
}

class _SkeletonLayoutPageState extends State<SkeletonLayoutPage> {
  // State untuk mengontrol demo "Loading Effects"
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _reloadDemo() {
    setState(() {
      _isLoading = true;
    });
    _loadData();
  }

  // --- Helper: Judul Bagian (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor, // Mengikuti tema
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Helper: Deskripsi (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.4,
          color: textColor, // Mengikuti tema
        ),
      ),
    );
  }

  // --- Helper: Tombol Dinamis ---
  Widget _buildDynamicButton({
    required String text,
    required VoidCallback onPressed,
    required Color buttonColor,
  }) {
    return Expanded(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor, // Mengikuti tema
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- Helper: Skeleton List Item (Dinamis) ---
  Widget _buildSkeletonListItem(Color baseColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 16, color: baseColor),
                const SizedBox(height: 8),
                Container(width: double.infinity, height: 14, color: baseColor),
                const SizedBox(height: 8),
                Container(width: 200, height: 14, color: baseColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper: Skeleton Card (Dinamis) ---
  Widget _buildSkeletonCard(
      Color cardBgColor, Color borderColor, Color skeletonColor) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBgColor, // Mengikuti tema
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 150, height: 20, color: skeletonColor),
          const SizedBox(height: 16),
          Container(width: double.infinity, height: 16, color: skeletonColor),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 16, color: skeletonColor),
          const SizedBox(height: 8),
          Container(width: 200, height: 16, color: skeletonColor),
          const SizedBox(height: 8),
          Container(width: 100, height: 16, color: skeletonColor),
        ],
      ),
    );
  }

  // --- Helper: Konten Asli (Dinamis) ---
  Widget _buildContentListItem({
    required String title,
    required String subtitle,
    required String description,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: subtitleColor.withOpacity(0.1),
            child: Icon(Icons.person, color: subtitleColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                Text(subtitle,
                    style: TextStyle(fontSize: 14, color: subtitleColor)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 14, color: subtitleColor.withOpacity(0.7))),
              ],
            ),
          ),
        ],
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

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor =
        isDark ? Colors.white70 : Colors.black54; // Untuk teks sekunder

    // Warna Divider & Border
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Skeleton & Shimmer (Penting agar terlihat bagus di dark mode)
    final skeletonBaseColor = isDark ? Colors.white10 : const Color(0xFFE0E0E0);
    final skeletonHighlightColor =
        isDark ? Colors.white24 : const Color(0xFFF5F5F5);
    final cardBgColor = isDark ? themeProvider.cardColor : Colors.white;

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
            title: const Text('Skeleton Elements'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // --- Intro Teks ---
            _buildDescription(
              'Skeleton (or Ghost) elements designed to improve perceived performance and make app feels faster.',
              textColor,
            ),
            const SizedBox(height: 16),
            _buildDescription(
              'Framework7 comes with two types of such elements: Skeleton Block and Skeleton Text. Skeleton block is a gray box that can be used as placeholder for any element. Skeleton text uses special built-in skeleton font to render each character of such text as gray rectangle. Skeleton text allows to make such elements responsive and can be feel more natural. It can be used in any places and with any elements.',
              textColor,
            ),

            // --- Skeleton List (Statis) ---
            _buildSectionTitle('Skeleton List', primaryColor),
            _buildSkeletonListItem(skeletonBaseColor),
            _buildSkeletonListItem(skeletonBaseColor),

            // --- Skeleton Card (Statis) ---
            _buildSectionTitle('Skeleton Card', primaryColor),
            _buildSkeletonCard(cardBgColor, dividerColor, skeletonBaseColor),

            // --- Loading Effects (Dinamis) ---
            _buildSectionTitle('Loading Effects', primaryColor),
            _buildDescription('It supports few loading effects:', textColor),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildDynamicButton(
                      text: 'Fade',
                      onPressed: _reloadDemo,
                      buttonColor: primaryColor),
                  const SizedBox(width: 16),
                  _buildDynamicButton(
                      text: 'Wave',
                      onPressed: _reloadDemo,
                      buttonColor: primaryColor),
                  const SizedBox(width: 16),
                  _buildDynamicButton(
                      text: 'Pulse',
                      onPressed: _reloadDemo,
                      buttonColor: primaryColor),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Daftar Konten (Dinamis: Shimmer vs Content) ---
            if (_isLoading)
              Shimmer.fromColors(
                baseColor: skeletonBaseColor,
                highlightColor: skeletonHighlightColor,
                child: Column(
                  children: [
                    _buildSkeletonListItem(skeletonBaseColor),
                    _buildSkeletonListItem(skeletonBaseColor),
                    _buildSkeletonListItem(skeletonBaseColor),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _buildContentListItem(
                    title: 'John Doe',
                    subtitle: 'CEO',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis et massa ac...',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  _buildContentListItem(
                    title: 'Jane Doe',
                    subtitle: 'Marketing',
                    description:
                        'Cras consequat felis at consequat hendrerit. Aliquam vestibulum vitae lorem ac...',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  _buildContentListItem(
                    title: 'Kate Johnson',
                    subtitle: 'Admin',
                    description:
                        'Sed tincidunt, lectus eu convallis elementum, nibh nisi aliquet urna, nec...',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                ],
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
