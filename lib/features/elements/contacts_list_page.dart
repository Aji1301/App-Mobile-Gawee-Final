import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// Definisi data kontak (Tetap sama)
final Map<String, List<String>> contactsData = {
  'A': [
    'Aaron',
    'Abbie',
    'Adam',
    'Adele',
    'Agatha',
    'Agnes',
    'Albert',
    'Alexander'
  ],
  'B': ['Bailey', 'Barclay', 'Bartolo', 'Bellamy', 'Belle', 'Benjamin'],
  'C': ['Caiden', 'Calvin', 'Candy', 'Carl', 'Cherilyn', 'Chester', 'Chloe'],
  'V': ['Vladimir'],
};

List<dynamic> getFlattenedContacts() {
  List<dynamic> flattenedList = [];
  contactsData.forEach((key, value) {
    flattenedList.add(key);
    flattenedList.addAll(value);
  });
  return flattenedList;
}

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

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

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE0E0E0);

    final List<dynamic> contacts = getFlattenedContacts();

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          'Contacts List',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final item = contacts[index];

          if (item is String &&
              item.length == 1 &&
              contactsData.containsKey(item)) {
            // Ini adalah Header (Indeks Huruf)
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor, // Mengikuti tema
                ),
              ),
            );
          } else {
            // Ini adalah Item Kontak
            return Column(
              children: [
                ListTile(
                  title: Text(
                    item.toString(),
                    style: TextStyle(
                        fontSize: 16, color: textColor), // Mengikuti tema
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Anda mengklik: ${item.toString()}'),
                      ),
                    );
                  },
                ),
                // Divider dinamis
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: dividerColor, // Mengikuti tema
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
