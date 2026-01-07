// lib/preloader_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class PreloaderPage extends StatelessWidget {
  const PreloaderPage({super.key});

  // --- Helper: Judul Bagian (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Text(
      title,
      style: TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // --- Helper: Deskripsi (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        height: 1.4,
        color: textColor,
      ),
    );
  }

  // --- Helper: Deskripsi dengan Kode (Dinamis) ---
  Widget _buildDescriptionWithCode(List<TextSpan> spans, Color textColor,
      Color codeBgColor, Color codeTextColor) {
    // Style default untuk teks biasa
    final defaultStyle = TextStyle(
      fontSize: 16.0,
      height: 1.4,
      color: textColor,
      fontFamily: 'Roboto',
    );

    // Style untuk kode
    final codeStyle = TextStyle(
      fontFamily: 'monospace',
      backgroundColor: codeBgColor,
      color: codeTextColor,
      fontWeight: FontWeight.w900,
    );

    // Rekonstruksi spans dengan style yang benar
    final List<TextSpan> styledSpans = spans.map((span) {
      if (span.style != null && span.style!.fontFamily == 'monospace') {
        return TextSpan(text: span.text, style: codeStyle);
      }
      return TextSpan(text: span.text); // Gunakan style parent
    }).toList();

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: styledSpans,
      ),
    );
  }

  // --- Helper: Tombol Dinamis ---
  Widget _buildDynamicButton({
    required String text,
    required VoidCallback onPressed,
    required Color buttonColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size(double.infinity, 48),
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

  // --- Aksi Tombol 1: Small Indicator (Dinamis) ---
  void _showSmallIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted &&
              Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
        return Center(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors
                  .black, // Tetap hitam agar kontras dengan indikator putih
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.5,
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Aksi Tombol 2 & 3: Dialog Preloader (Dinamis) ---
  void _showDialogPreloader(BuildContext context, Color dialogBgColor,
      Color textColor, Color primaryColor,
      {String? title}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted &&
              Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        });

        return Dialog(
          backgroundColor: dialogBgColor,
          surfaceTintColor: dialogBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 24),
                CircularProgressIndicator(
                  color: primaryColor, // Mengikuti tema
                ),
              ],
            ),
          ),
        );
      },
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
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Khusus untuk Deskripsi Kode
    final codeBgColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final codeTextColor =
        isDark ? Colors.redAccent.shade100 : const Color.fromARGB(255, 0, 0, 0);

    // Warna Dialog
    final dialogBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(
              bottom: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Preloader'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian 1: Intro ---
            _buildDescription(
              'How about an activity indicator? Framework7 has a nice one. The F7 Preloader is made with SVG and animated with CSS so it can be easily resized.',
              textColor,
            ),
            const SizedBox(height: 32),

            // --- Bagian 2: Default ---
            _buildSectionTitle('Default', primaryColor),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(
                    color: isDark ? Colors.white70 : Colors.grey.shade600),
                // Indicator dengan latar belakang hitam
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4)),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                CircularProgressIndicator(
                    color: isDark ? Colors.white70 : Colors.grey.shade600),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4)),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Bagian 3: Color ---
            _buildSectionTitle('Color Preloaders', primaryColor),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(color: Colors.red),
                CircularProgressIndicator(color: Colors.green),
                CircularProgressIndicator(color: Colors.orange),
                CircularProgressIndicator(color: Colors.blue),
              ],
            ),
            const SizedBox(height: 32),

            // --- Bagian 4: Multi-color ---
            _buildSectionTitle('Multi-color', primaryColor),
            const SizedBox(height: 16),
            Center(
              child: CircularProgressIndicator(
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 32),

            // --- Bagian 5: Modals ---
            _buildSectionTitle('Preloader Modals', primaryColor),
            const SizedBox(height: 8),
            _buildDescriptionWithCode([
              const TextSpan(text: 'With '),
              const TextSpan(
                  text: 'app.preloader.show()',
                  style: TextStyle(fontFamily: 'monospace')),
              const TextSpan(
                  text:
                      ' you can show small overlay with preloader indicator.'),
            ], textColor, codeBgColor, codeTextColor),
            _buildDynamicButton(
              text: 'Open Small Indicator',
              onPressed: () => _showSmallIndicator(context),
              buttonColor: primaryColor,
            ),
            const SizedBox(height: 24),

            _buildDescriptionWithCode([
              const TextSpan(text: 'With '),
              const TextSpan(
                  text: 'app.dialog.preloader()',
                  style: TextStyle(fontFamily: 'monospace')),
              const TextSpan(
                  text: ' you can show dialog modal with preloader indicator.'),
            ], textColor, codeBgColor, codeTextColor),
            _buildDynamicButton(
              text: 'Open Dialog Preloader',
              onPressed: () => _showDialogPreloader(
                  context, dialogBgColor, textColor, primaryColor),
              buttonColor: primaryColor,
            ),
            const SizedBox(height: 24),

            _buildDescriptionWithCode([
              const TextSpan(text: 'With '),
              const TextSpan(
                  text: 'app.dialog.preloader(\'My text...\')',
                  style: TextStyle(fontFamily: 'monospace')),
              const TextSpan(
                  text:
                      ' you can show dialog preloader modal with custom title.'),
            ], textColor, codeBgColor, codeTextColor),
            _buildDynamicButton(
              text: 'Open Dialog Preloader',
              onPressed: () => _showDialogPreloader(
                  context, dialogBgColor, textColor, primaryColor,
                  title: 'My text...'),
              buttonColor: primaryColor,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
