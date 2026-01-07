// lib/subnavbar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda
import 'page_title_page.dart';

class SubnavbarPage extends StatefulWidget {
  const SubnavbarPage({super.key});

  @override
  State<SubnavbarPage> createState() => _SubnavbarPageState();
}

class _SubnavbarPageState extends State<SubnavbarPage> {
  // State untuk melacak tab yang aktif
  int _selectedTabIndex = 0;

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

    // Warna Teks, Icon, & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    // PERBAIKAN: Membuat warna icon dinamis
    final iconColor = isDark ? Colors.white54 : Colors.grey.shade400;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna ToggleButtons
    final toggleBorderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final toggleFillColor = isDark ? themeProvider.cardColor : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Hanya Judul dan Tombol Kembali) ---
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
            title: const Text('Subnavbar'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Subnavbar (Tab "Link 1, 2, 3") ---
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: ToggleButtons(
              isSelected: [
                _selectedTabIndex == 0,
                _selectedTabIndex == 1,
                _selectedTabIndex == 2
              ],
              onPressed: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(8.0),

              // Styling Dinamis
              selectedColor: primaryColor, // Warna teks saat aktif
              color: textColor, // Warna teks saat tidak aktif
              fillColor: toggleFillColor, // Latar belakang tombol terpilih

              selectedBorderColor: primaryColor, // Garis batas saat aktif
              borderColor: toggleBorderColor, // Garis batas saat tidak aktif

              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Link 1')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Link 2')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Link 3')),
              ],
            ),
          ),

          // --- Teks Deskripsi ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Subnavbar is useful when you need to put any additional elements into Navbar, like Tab Links or Search Bar. It also remains visible when Navbar hidden.',
              style: TextStyle(fontSize: 16.0, height: 1.4, color: textColor),
            ),
          ),

          // --- Tautan ke Halaman "Page Title" ---
          Divider(height: 1, thickness: 1, color: dividerColor),
          ListTile(
            tileColor: isDark
                ? themeProvider.cardColor
                : null, // Warna bg di dark mode
            title: Text('Subnavbar Title',
                style: TextStyle(fontSize: 16, color: textColor)),
            // PERBAIKAN: Menggunakan iconColor yang dinamis
            trailing: Icon(Icons.chevron_right, color: iconColor, size: 20),
            onTap: () {
              // Navigasi ke Halaman "Page Title"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PageTitlePage()),
              );
            },
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
        ],
      ),
    );
  }
}
