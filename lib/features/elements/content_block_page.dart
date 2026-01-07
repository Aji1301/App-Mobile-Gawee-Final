import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class ContentBlockPage extends StatelessWidget {
  const ContentBlockPage({super.key});

  final String dummyText =
      "Donec et nulla auctor massa pharetra adipiscing ut sit amet sem. Suspendisse molestie velit vitae mattis tincidunt. Ut sit amet quam mollis, vulputate turpis vel, sagittis felis.";
  final String longDummyText =
      "Here comes paragraph within content block. Donec et nulla auctor massa pharetra adipiscing ut sit amet sem. Suspendisse molestie velit vitae mattis tincidunt. Ut sit amet quam mollis, vulputate turpis vel, sagittis felis.";

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
    final subTextColor = isDark ? Colors.white60 : Colors.black54;

    // Warna Content Block (Light Purple di Light Mode, Card Color di Dark Mode)
    final blockBackgroundColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF0F0FF);

    // Warna Border
    final borderColor = isDark ? Colors.white54 : Colors.black;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          'Content Block',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),

              // Teks di luar Content Block
              Text(
                'This paragraph is outside of content block. Not cool, but useful for any custom elements with custom styling.',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 24),

              // --- 1. Block Title ---
              _buildBlockTitle('Block Title', primaryColor),
              _buildContentBlock(longDummyText, textColor),

              // --- 2. Strong Block ---
              _buildBlockTitle('Strong Block', primaryColor),
              _buildStrongContentBlock(
                  "Here comes another text block with additional “block-strong” class. Praesent nec imperdiet diam. Maecenas vel lectus porttitor, consectetur magna nec, viverra sem. Aliquam sed risus dolor. Morbi tincidunt ut libero id sodales. Integer blandit varius nisi quis consectetur.",
                  blockBackgroundColor,
                  textColor),

              // --- 3. Strong Outline Block (Berwarna + Garis) ---
              _buildBlockTitle('Strong Outline Block', primaryColor),
              _buildStrongOutlineContentBlock(
                  "Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptates itaque autem qui quaerat vero ducimus praesentium quibusdam veniam error ut alias, numquam iste ea quos maxime consequatur ullam at a.",
                  blockBackgroundColor,
                  borderColor,
                  textColor),

              // --- 4. Strong Inset Block ---
              _buildBlockTitle('Strong Inset Block', primaryColor),
              _buildStrongInsetBlock(
                  dummyText, blockBackgroundColor, textColor),

              // --- 5. Strong Inset Outline Block (Berwarna + Garis) ---
              _buildBlockTitle('Strong Inset Outline Block', primaryColor),
              _buildStrongInsetOutlineBlock(
                  dummyText, blockBackgroundColor, borderColor, textColor),

              // --- 6. Tablet Inset (Kotak warna, tanpa garis) ---
              _buildBlockTitle('Tablet Inset', primaryColor),
              _buildContentBlockWithBackground(
                  dummyText, blockBackgroundColor, textColor),

              // --- 7. With Header & Footer (Multiple) ---
              _buildBlockTitle('With Header & Footer', primaryColor),
              _buildBlockWithHeaderFooter(
                  longDummyText, blockBackgroundColor, subTextColor, textColor),
              _buildBlockWithHeaderFooter(
                  longDummyText, blockBackgroundColor, subTextColor, textColor),
              _buildBlockWithHeaderFooter(
                  longDummyText, blockBackgroundColor, subTextColor, textColor),

              // --- 8. Block Title Large ---
              _buildBlockTitle('Block Title Large', primaryColor,
                  isLarge: true),
              _buildContentBlockWithBackground(
                  dummyText, blockBackgroundColor, textColor),

              // --- 9. Block Title Medium ---
              _buildBlockTitle('Block Title Medium', primaryColor,
                  isMedium: true),
              _buildContentBlockWithBackground(
                  dummyText, blockBackgroundColor, textColor),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  //                       WIDGET PEMBANTU
  // =========================================================

  // Widget Pembantu untuk Judul Blok
  Widget _buildBlockTitle(
    String title,
    Color color, {
    bool isLarge = false,
    bool isMedium = false,
  }) {
    double fontSize = isLarge ? 22 : (isMedium ? 18 : 14);
    FontWeight fontWeight =
        isLarge || isMedium ? FontWeight.bold : FontWeight.w600;

    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: isLarge || isMedium ? 12 : 8.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

  // Widget Pembantu untuk Content Block Dasar
  Widget _buildContentBlock(String content, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(content,
          style: TextStyle(fontSize: 16, height: 1.5, color: textColor)),
    );
  }

  // Widget untuk Tablet Inset / Content Block dengan Background
  Widget _buildContentBlockWithBackground(
      String content, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(content,
          style: TextStyle(fontSize: 16, height: 1.5, color: textColor)),
    );
  }

  // Widget Pembantu untuk Strong Block
  Widget _buildStrongContentBlock(
      String content, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(content,
          style: TextStyle(fontSize: 16, height: 1.5, color: textColor)),
    );
  }

  // Widget Pembantu untuk Strong Outline Block
  Widget _buildStrongOutlineContentBlock(
      String content, Color bgColor, Color borderColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(content,
          style: TextStyle(fontSize: 16, height: 1.5, color: textColor)),
    );
  }

  // Widget Pembantu untuk Strong Inset Block
  Widget _buildStrongInsetBlock(
      String content, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(content,
            style: TextStyle(fontSize: 16, height: 1.5, color: textColor)),
      ),
    );
  }

  // Widget Pembantu untuk Strong Inset Outline Block
  Widget _buildStrongInsetOutlineBlock(
      String content, Color bgColor, Color borderColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Text(content,
            style: TextStyle(fontSize: 16, height: 1.5, color: textColor)),
      ),
    );
  }

  // Widget Pembantu dengan Header dan Footer
  Widget _buildBlockWithHeaderFooter(
      String content, Color bgColor, Color subTextColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Block Header',
            style: TextStyle(fontSize: 14, color: subTextColor),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              content,
              style: TextStyle(fontSize: 16, height: 1.5, color: textColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Block Footer',
            style: TextStyle(fontSize: 14, color: subTextColor),
          ),
        ],
      ),
    );
  }
}
