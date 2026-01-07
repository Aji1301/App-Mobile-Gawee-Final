import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class ChipsPage extends StatelessWidget {
  ChipsPage({super.key});

  // Warna Solid Kustom (Tetap statis karena ini adalah contoh warna spesifik)
  static const Color solidOrange = Color(0xFFFF9800);
  static const Color solidRed = Color(0xFFD32F2F);
  static const Color solidGreen = Color(0xFF388E3C);
  static const Color solidBlue = Color(0xFF1976D2);
  static const Color solidPink = Color(0xFFC2185B);

  // Data Dummy
  final List<String> textChips = [
    'Example Chip',
    'Another Chip',
    'One More Chip',
    'Fourth Chip',
    'Last One',
  ];
  final List<Map<String, dynamic>> contactChips = [
    {'label': 'Jane Doe', 'avatar': 'https://picsum.photos/id/1011/40/40'},
    {'label': 'John Doe', 'avatar': 'https://picsum.photos/id/1025/40/40'},
    {'label': 'Adam Smith', 'avatar': 'https://picsum.photos/id/1012/40/40'},
    {'label': 'Jennifer', 'avatar': 'J', 'color': Colors.red},
    {'label': 'Chris', 'avatar': 'C', 'color': Colors.yellow},
    {'label': 'Kate', 'avatar': 'K', 'color': Colors.red},
  ];
  final List<Map<String, dynamic>> deletableChipsData = [
    {'label': 'Example Chip', 'type': 'text'},
    {
      'label': 'C Chris',
      'type': 'contact_letter',
      'avatar': 'C',
      'color': Colors.amber.shade700,
    },
    {
      'label': 'Jane Doe',
      'type': 'contact_image',
      'avatar': 'https://picsum.photos/id/1011/40/40',
    },
    {'label': 'One More Chip', 'type': 'text'},
    {
      'label': 'J Jennifer',
      'type': 'contact_letter',
      'avatar': 'J',
      'color': Colors.red.shade700,
    },
    {
      'label': 'Adam Smith',
      'type': 'contact_image',
      'avatar': 'https://picsum.photos/id/1012/40/40',
    },
  ];

  // --- Widget Pembantu: Judul Bagian ---
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

  // --- Widget Pembantu: Chip Dasar ---
  Widget _buildChip({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    Widget? leading,
    Widget? trailing,
    BorderSide border = BorderSide.none,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Chip(
        avatar: leading,
        label: Text(label, style: TextStyle(color: textColor, fontSize: 14)),
        deleteIcon: trailing,
        onDeleted: onDelete,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: border,
        ),
        padding: padding,
      ),
    );
  }

  // --- Widget Pembantu: Chip Kontak ---
  Widget _buildContactChip(
      Map<String, dynamic> contact, Color bgColor, Color textColor) {
    bool hasImage = contact['avatar'].toString().startsWith('http');

    Widget avatarWidget;

    if (hasImage) {
      avatarWidget = CircleAvatar(
        backgroundImage: NetworkImage(contact['avatar']),
        radius: 12,
      );
    } else {
      avatarWidget = CircleAvatar(
        backgroundColor: contact['color'],
        radius: 12,
        child: Text(
          contact['avatar'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return _buildChip(
      label: contact['label'],
      leading: avatarWidget,
      backgroundColor: bgColor,
      textColor: textColor,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
    );
  }

  // --- Widget Pembantu: Deletable Chip ---
  Widget _buildDeletableChip(
      Map<String, dynamic> data, Color chipBaseColor, Color textColor) {
    String type = data['type'];
    String label = data['label'];

    Widget? avatarWidget;
    // Menggunakan warna dasar chip yang dikirim dari build (menyesuaikan tema)
    Color chipBackgroundColor = chipBaseColor;

    switch (type) {
      case 'text':
        chipBackgroundColor = chipBaseColor;
        break;
      case 'contact_letter':
      case 'contact_image':
        chipBackgroundColor = chipBaseColor;

        if (data.containsKey('avatar')) {
          if (data['avatar'].toString().startsWith('http')) {
            avatarWidget = CircleAvatar(
              backgroundImage: NetworkImage(data['avatar']),
              radius: 12,
            );
          } else {
            avatarWidget = CircleAvatar(
              backgroundColor: data['color'],
              radius: 12,
              child: Text(
                data['avatar'],
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            );
          }
        }
        break;
    }

    return _buildChip(
      label: label,
      leading: avatarWidget,
      backgroundColor: chipBackgroundColor,
      textColor: textColor,
      trailing: const Icon(Icons.close, size: 14, color: Colors.grey),
      onDelete: () => print('$label deleted'),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // 2. Tentukan Warna berdasarkan Tema
    final scaffoldBackgroundColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    // Warna khusus Chip
    final chipOutlineBorderColor =
        isDark ? Colors.white54 : const Color(0xFF333333);

    // Warna background chip default (Ungu muda di light, Card color di dark)
    final defaultChipBgColor =
        isDark ? themeProvider.cardColor : primaryColor.withOpacity(0.1);

    // Warna background untuk contact/deletable (Abu muda di light, Card color di dark)
    final contactChipBgColor =
        isDark ? themeProvider.cardColor : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,

      // --- AppBar ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBgColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Chips',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Chips With Text
            _buildSectionTitle('Chips With Text', primaryColor),
            Wrap(
              children: textChips.map((label) {
                return _buildChip(
                  label: label,
                  backgroundColor: defaultChipBgColor,
                  textColor: textColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                );
              }).toList(),
            ),

            // 2. Outline Chips
            _buildSectionTitle('Outline Chips', primaryColor),
            Wrap(
              children: textChips.map((label) {
                return _buildChip(
                  label: label,
                  backgroundColor:
                      Colors.transparent, // Transparan untuk outline
                  textColor: textColor,
                  border: BorderSide(color: chipOutlineBorderColor, width: 1.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                );
              }).toList(),
            ),

            // 3. Icon Chips
            _buildSectionTitle('Icon Chips', primaryColor),
            Wrap(
              children: [
                _buildChip(
                  label: 'Add Contact',
                  leading: Icon(
                    Icons.add_circle,
                    color: primaryColor,
                    size: 18,
                  ),
                  backgroundColor: defaultChipBgColor,
                  textColor: textColor,
                ),
                _buildChip(
                  label: 'London',
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 18,
                  ),
                  backgroundColor: defaultChipBgColor,
                  textColor: textColor,
                ),
                _buildChip(
                  label: 'John Doe',
                  leading:
                      const Icon(Icons.person, color: Colors.red, size: 18),
                  backgroundColor: defaultChipBgColor,
                  textColor: textColor,
                ),
              ],
            ),

            // 4. Contact Chips
            _buildSectionTitle('Contact Chips', primaryColor),
            Wrap(
              children: contactChips.map((contact) {
                return _buildContactChip(
                    contact, contactChipBgColor, textColor);
              }).toList(),
            ),

            // 5. Deletable Chips / Tags
            _buildSectionTitle('Deletable Chips / Tags', primaryColor),
            Wrap(
              children: deletableChipsData.map((data) {
                return _buildDeletableChip(data, contactChipBgColor, textColor);
              }).toList(),
            ),

            // 6. Color Chips
            _buildSectionTitle('Color Chips', primaryColor),
            Wrap(
              children: [
                // Solid Colors (Text White agar kontras)
                _buildChip(
                  label: 'Red Chip',
                  backgroundColor: solidRed,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Green Chip',
                  backgroundColor: solidGreen,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Blue Chip',
                  backgroundColor: solidBlue,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Orange Chip',
                  backgroundColor: solidOrange,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Pink Chip',
                  backgroundColor: solidPink,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),

                // Outline Colors (Text & Border mengikuti warna tema/spesifik)
                _buildChip(
                  label: 'Red Chip',
                  backgroundColor: Colors.transparent,
                  textColor: textColor,
                  border: BorderSide(color: solidRed, width: 1.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Green Chip',
                  backgroundColor: Colors.transparent,
                  textColor: textColor,
                  border: BorderSide(color: solidGreen, width: 1.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Blue Chip',
                  backgroundColor: Colors.transparent,
                  textColor: textColor,
                  border: BorderSide(color: solidBlue, width: 1.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Orange Chip',
                  backgroundColor: Colors.transparent,
                  textColor: textColor,
                  border: BorderSide(color: solidOrange, width: 1.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                ),
                _buildChip(
                  label: 'Pink Chip',
                  backgroundColor: Colors.transparent,
                  textColor: textColor,
                  border: BorderSide(color: solidPink, width: 1.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
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
