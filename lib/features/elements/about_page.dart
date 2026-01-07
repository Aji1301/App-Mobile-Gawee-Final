import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBackgroundColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;

    final appBarBackgroundColor =
        isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,

      // --- AppBar (Hanya Ikon Panah Kembali) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBackgroundColor, // Latar belakang AppBar dinamis
            border: Border(
              bottom: BorderSide(
                color: dividerColor, // Garis pembatas bawah dinamis
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor:
                Colors.transparent, // Transparan agar terlihat warna Container
            foregroundColor: textColor, // Warna ikon dinamis
            // HANYA Ikon Panah Kembali
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(''), // Judul di AppBar DIKOSONGKAN
            centerTitle: false,
          ),
        ),
      ),

      // --- BODY (Tempat Judul 'About' berada) ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),

            // Judul 'About'
            Text(
              'About',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: textColor, // Warna teks dinamis
              ),
            ),

            // Jarak di antara 'About' dan 'Welcome to Framework7'
            const SizedBox(height: 32),

            // Judul "Welcome to Framework7"
            Text(
              'Welcome to Framework7',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryColor, // Mengikuti warna tema utama
              ),
            ),
            const SizedBox(height: 16),

            // Paragraf 1
            Text(
              'Framework7 – is a free and open source HTML mobile framework to develop hybrid mobile apps or web apps with iOS or Android (Material) native look and feel. It is also an indispensable prototyping apps tool to show working app prototype as soon as possible in case you need to. Framework7 is created by Vladimir Kharlampidi.',
              style: TextStyle(fontSize: 16, height: 1.5, color: textColor),
            ),
            const SizedBox(height: 20),

            // Paragraf 2
            Text(
              'The main approach of the Framework7 is to give you an opportunity to create iOS and Android (Material) apps with HTML, CSS and JavaScript easily and clear. Framework7 is full of freedom. It doesn\'t limit your imagination or offer ways of any solutions somehow. Framework7 gives you freedom!',
              style: TextStyle(fontSize: 16, height: 1.5, color: textColor),
            ),
            const SizedBox(height: 20),

            // Paragraf 3
            Text(
              'Framework7 is not compatible with all platforms. It is focused only on iOS and Android (Material) to bring the best experience and simplicity.',
              style: TextStyle(fontSize: 16, height: 1.5, color: textColor),
            ),
            const SizedBox(height: 20),

            // Paragraf 4
            Text(
              'Framework7 is definitely for you if you decide to build iOS and Android hybrid app (Cordova or Capacitor) or web app that looks like and feels as great native iOS or Android (Material) apps.',
              style: TextStyle(fontSize: 16, height: 1.5, color: textColor),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
