// lib/page_title_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class PageTitlePage extends StatelessWidget {
  const PageTitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna Dinamis
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks
    final titleColor = isDark ? Colors.white : Colors.black87;
    final bodyTextColor = isDark ? Colors.white70 : Colors.black87;

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Hanya Tombol Kembali, Judul ada di Body) ---
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: primaryColor, // Icon mengikuti warna tema
              onPressed: () => Navigator.pop(context),
            ),
            // Kosongkan title di AppBar
          ),
        ),
      ),

      // --- Body (Berisi Judul dan Teks) ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Halaman
            Text(
              'Page Title',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: titleColor, // Warna dinamis
              ),
            ),
            const SizedBox(height: 16),

            // Paragraf 1
            Text(
              'It also possible to use Subnavbar to display page title and keep navbar only for actions.',
              style:
                  TextStyle(fontSize: 16.0, height: 1.4, color: bodyTextColor),
            ),
            const SizedBox(height: 16),

            // Paragraf 2
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Unde, consequatur quia amet voluptatem vero quasi, veniam, quisquam dolorum magni sint enim, harum expedita excepturi quas iure magnam minus voluptatem quaerat!',
              style:
                  TextStyle(fontSize: 16.0, height: 1.4, color: bodyTextColor),
            ),
            const SizedBox(height: 16),

            // Paragraf 3
            Text(
              'Dolore laboriosam error magnam velit expedita recusandae, dolor asperiores unde, sint, veritatis illum ipsum? Nulla ratione nobis, ullam debitis. Inventore sapiente rem dolore eum ipsa totam perspiciatis cupiditate, amet maiores!',
              style:
                  TextStyle(fontSize: 16.0, height: 1.4, color: bodyTextColor),
            ),
            const SizedBox(height: 16),

            // Paragraf 4
            Text(
              'Ratione quod minus ipsum maxime cum voluptate molestiae adipisci placeat ut illo, alias nobis perferendis magni odio sunt, porro, totam praesentium possimus! Autem inventore ut provident animi quae, impedit id!',
              style:
                  TextStyle(fontSize: 16.0, height: 1.4, color: bodyTextColor),
            ),
            const SizedBox(height: 16),

            // Paragraf 5
            Text(
              'Aperiam ea ab harum. Quis dolorem cupiditate, incidunt mollitia ducimus voluptatem commodi! Odio quasi amet hic nesciunt, quibusdam, est vero repellat sapiente perferendis, optio laboriosam in culpa veniam alias ad.',
              style:
                  TextStyle(fontSize: 16.0, height: 1.4, color: bodyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
