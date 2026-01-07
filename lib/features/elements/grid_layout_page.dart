import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class GridLayoutPage extends StatelessWidget {
  const GridLayoutPage({super.key});

  static const double columnHeight = 40.0;
  static const double gapSize = 8.0;

  // --- Widget Pembantu: Judul Bagian (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryColor, // Mengikuti tema
        ),
      ),
    );
  }

  // --- Widget Pembantu: Kotak Kolom Dasar (Dinamis) ---
  Widget _buildColumnBox(String text, Color bgColor, Color textColor,
      {double horizontalPadding = 8.0}) {
    return Container(
      height: columnHeight,
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: bgColor, // Mengikuti tema
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: textColor), // Mengikuti tema
      ),
    );
  }

  // --- Bagian 1: Columns with gap ---
  Widget _buildGapGrid(Color colBgColor, Color colTextColor) {
    return Column(
      children: <Widget>[
        // Row 1: 50% / 50% (2 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('2 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('2 cols', colBgColor, colTextColor)),
          ],
        ),
        const SizedBox(height: gapSize),

        // Row 2: 25% / 25% / 25% / 25% (4 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
          ],
        ),
        const SizedBox(height: gapSize),

        // Row 3: 33% / 33% / 33% (3 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('3 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('3 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('3 cols', colBgColor, colTextColor)),
          ],
        ),
        const SizedBox(height: gapSize),

        // Row 4: 20% x 5 (5 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
          ],
        ),
      ],
    );
  }

  // --- Bagian 2: No gap between columns ---
  Widget _buildNoGapGrid(Color colBgColor, Color colTextColor) {
    return Column(
      children: <Widget>[
        // Row 1: 50% / 50% (2 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('2 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('2 cols', colBgColor, colTextColor)),
          ],
        ),
        const Divider(
          height: 1,
          thickness: 0,
          color: Colors.transparent,
        ),
        // Row 2: 25% / 25% / 25% / 25% (4 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('4 cols', colBgColor, colTextColor)),
          ],
        ),
        const Divider(height: 1, thickness: 0, color: Colors.transparent),

        // Row 3: 33% / 33% / 33% (3 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('3 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('3 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('3 cols', colBgColor, colTextColor)),
          ],
        ),
        const Divider(height: 1, thickness: 0, color: Colors.transparent),

        // Row 4: 20% x 5 (5 cols)
        Row(
          children: [
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
            Expanded(
                child: _buildColumnBox('5 cols', colBgColor, colTextColor)),
          ],
        ),
      ],
    );
  }

  // --- Bagian 3: Responsive Grid ---
  Widget _buildResponsiveGrid(
      BuildContext context, Color colBgColor, Color colTextColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMedium = screenWidth > 600;

    // Baris 1: 1 col / medium 2 cols
    Widget buildResponsiveRow1() {
      if (isMedium) {
        // Tampilan Tablet (Medium): 2 kolom
        return Row(
          children: [
            Expanded(
                child: _buildColumnBox(
                    '1 col / medium 2 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox(
                    '1 col / medium 2 cols', colBgColor, colTextColor)),
          ],
        );
      } else {
        // Tampilan HP (Kecil): 1 kolom
        return Column(
          children: [
            _buildColumnBox('1 col / medium 2 cols', colBgColor, colTextColor),
            const SizedBox(height: gapSize),
            _buildColumnBox('1 col / medium 2 cols', colBgColor, colTextColor),
          ],
        );
      }
    }

    // Baris 2: 2 col / medium 4 cols
    Widget buildResponsiveRow2() {
      if (isMedium) {
        // Tampilan Tablet (Medium): 4 kolom
        return Row(
          children: [
            Expanded(
                child: _buildColumnBox(
                    '2 col / medium 4 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox(
                    '2 col / medium 4 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox(
                    '2 col / medium 4 cols', colBgColor, colTextColor)),
            const SizedBox(width: gapSize),
            Expanded(
                child: _buildColumnBox(
                    '2 col / medium 4 cols', colBgColor, colTextColor)),
          ],
        );
      } else {
        // Tampilan HP (Kecil): 2 kolom per baris
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildColumnBox(
                        '2 col / medium 4 cols', colBgColor, colTextColor)),
                const SizedBox(width: gapSize),
                Expanded(
                    child: _buildColumnBox(
                        '2 col / medium 4 cols', colBgColor, colTextColor)),
              ],
            ),
            const SizedBox(height: gapSize),
            Row(
              children: [
                Expanded(
                    child: _buildColumnBox(
                        '2 col / medium 4 cols', colBgColor, colTextColor)),
                const SizedBox(width: gapSize),
                Expanded(
                    child: _buildColumnBox(
                        '2 col / medium 4 cols', colBgColor, colTextColor)),
              ],
            ),
          ],
        );
      }
    }

    return Column(
      children: [
        buildResponsiveRow1(),
        const SizedBox(height: gapSize),
        buildResponsiveRow2(),
      ],
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
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor =
        isDark ? Colors.white60 : Colors.black54; // Untuk teks sekunder

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Kotak Kolom (Abu-abu muda di light, Abu-abu tua di dark)
    final colBgColor =
        isDark ? Colors.grey[800]! : const Color.fromARGB(255, 224, 223, 223);
    final colTextColor = isDark ? Colors.white : Colors.black87;

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
            title: const Text(
              'Grid / Layout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Teks Deskripsi
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Columns within a row are automatically set to have equal width. Otherwise you can define your column with pourcentage of screen you want.',
                style:
                    TextStyle(fontSize: 16, height: 1.4, color: subTextColor),
              ),
            ),

            // 1. Columns with gap
            _buildSectionTitle('Columns with gap', primaryColor),
            _buildGapGrid(colBgColor, colTextColor),

            // 2. No gap between columns
            _buildSectionTitle('No gap between columns', primaryColor),
            _buildNoGapGrid(colBgColor, colTextColor),

            // 3. Responsive Grid
            _buildSectionTitle('Responsive Grid', primaryColor),
            Text(
              'Grid cells have different size on Phone/Tablet',
              style: TextStyle(fontSize: 16, height: 1.4, color: subTextColor),
            ),
            const SizedBox(height: 12),
            _buildResponsiveGrid(context, colBgColor, colTextColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
