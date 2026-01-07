import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class AppbarPage extends StatelessWidget {
  const AppbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    // Background Scaffold
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;

    // Background AppBar (Ungu muda di light mode, Card color di dark mode)
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks & Icon
    final textColor = isDark ? Colors.white : Colors.black87;
    final titleColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      // Latar belakang dinamis
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Navbar Bergaya Framework7) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            // Latar belakang AppBar dinamis
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: titleColor, // Warna icon & title dinamis
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Tombol kembali
              },
            ),
            // ✅ Judul AppBar adalah "Not found"
            title: const Text(
              'Not found',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
            actions: const [], // Menghapus ikon aksi yang tidak diperlukan
          ),
        ),
      ),

      // --- Body Halaman (Pesan Error Sederhana) ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            // ✅ Teks "Sorry"
            Text(
              'Sorry',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 8),
            // ✅ Teks "Requested content not found."
            Text(
              'Requested content not found.',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
