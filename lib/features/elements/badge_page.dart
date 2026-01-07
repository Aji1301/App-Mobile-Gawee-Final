import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

  // Warna Badge (Tetap statis karena ini adalah contoh warna spesifik)
  static const Color greenBadge = Color(0xFF4CAF50);
  static const Color orangeBadge = Color(0xFFFF9800);

  // --- Widget Pembantu untuk Membuat Ikon List Item (Gaya Halaman Utama) ---
  Widget _buildListItemIcon(Color primaryColor, Color iconBgColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: iconBgColor, // Kotak luar dinamis
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_outlined, // Ikon tas default
            color: Colors.white,
            size: 14,
          ),
        ),
      ),
    );
  }

  // --- Widget Pembantu untuk Membuat Badge (Diperkecil) ---
  Widget _buildBadge(
    String text, {
    required Color backgroundColor,
    Color textColor = Colors.white,
    double fontSize = 9,
    double paddingHorizontal = 5,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10), // Bentuk oval/pill
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Widget Pembantu untuk Membuat List Item ---
  Widget _buildListItem({
    required Widget leadingWidget, // Menerima widget ikon yang sudah custom
    required String title,
    required String badgeText,
    required Color badgeColor,
    required Color textColor,
    Color badgeTextColor = Colors.white,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      leading: leadingWidget,
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
      // Badge dengan ukuran diperkecil
      trailing: _buildBadge(
        badgeText,
        backgroundColor: badgeColor,
        textColor: badgeTextColor,
        fontSize: 12, // Badge di List Item sedikit lebih besar
        paddingHorizontal: 8,
      ),
      onTap: () {
        // Aksi ketika list item ditekan
        print('$title pressed');
      },
    );
  }

  // --- Implementasi Halaman ---
  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks & Icon
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white : Colors.black;

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Background Icon List Item
    final iconBgColor = isDark ? Colors.grey[800]! : const Color(0xFFF2F2F7);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Header Halaman) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(top: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: iconColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Badge',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
            actions: [
              // Ikon profil dengan badge di AppBar
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person, size: 28),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    // ✅ Badge di AppBar diperkecil
                    child: _buildBadge(
                      '5',
                      backgroundColor: Colors.red,
                      fontSize: 9,
                      paddingHorizontal: 5,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),

      // --- Body Halaman (List Item dengan Badge) ---
      body: ListView(
        children: <Widget>[
          _buildListItem(
            leadingWidget: _buildListItemIcon(primaryColor, iconBgColor),
            title: 'Foo Bar',
            badgeText: '0',
            badgeColor: Colors.grey,
            textColor: textColor,
          ),
          _buildListItem(
            leadingWidget: _buildListItemIcon(primaryColor, iconBgColor),
            title: 'Ivan Petrov',
            badgeText: 'CEO',
            badgeColor: primaryColor, // Mengikuti tema
            textColor: textColor,
          ),
          _buildListItem(
            leadingWidget: _buildListItemIcon(primaryColor, iconBgColor),
            title: 'John Doe',
            badgeText: '5',
            badgeColor: greenBadge,
            textColor: textColor,
          ),
          _buildListItem(
            leadingWidget: _buildListItemIcon(primaryColor, iconBgColor),
            title: 'Jane Doe',
            badgeText: 'NEW',
            badgeColor: orangeBadge,
            badgeTextColor: Colors.white,
            textColor: textColor,
          ),
        ],
      ),

      // --- BottomNavigationBar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: appBarBgColor, // Mengikuti tema
          border: Border(top: BorderSide(color: dividerColor, width: 1.0)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor, // Mengikuti tema
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          showUnselectedLabels: true,

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.mail),
                  Positioned(
                    right: 0,
                    top: 0,
                    // ✅ Badge di BottomNav diperkecil
                    child: _buildBadge(
                      '5',
                      backgroundColor: greenBadge,
                      fontSize: 9,
                      paddingHorizontal: 5,
                    ),
                  ),
                ],
              ),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.calendar_today),
                  Positioned(
                    right: 0,
                    top: 0,
                    // ✅ Badge di BottomNav diperkecil
                    child: _buildBadge(
                      '7',
                      backgroundColor: Colors.red,
                      fontSize: 9,
                      paddingHorizontal: 5,
                    ),
                  ),
                ],
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.upload_file),
                  Positioned(
                    right: 0,
                    top: 0,
                    // ✅ Badge di BottomNav diperkecil
                    child: _buildBadge(
                      '1',
                      backgroundColor: Colors.red,
                      fontSize: 9,
                      paddingHorizontal: 5,
                    ),
                  ),
                ],
              ),
              label: 'Upload',
            ),
          ],
          currentIndex: 0,
          onTap: (index) {
            print('Bottom nav item $index pressed');
          },
        ),
      ),
    );
  }
}
