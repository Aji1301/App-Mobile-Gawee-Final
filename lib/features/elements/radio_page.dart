// lib/radio_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// Data untuk Radio Group
final List<String> groupOptions = ['Books', 'Movies', 'Food', 'Drinks'];

// Data untuk Media List
final List<Map<String, dynamic>> mediaListItems = [
  {
    'title': 'Facebook',
    'subtitle':
        'New messages from John Doe\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis tellus ut turpis...',
    'time': '17:14',
    'id': 'msg_1',
  },
  {
    'title': 'John Doe (via Twitter)',
    'subtitle':
        'John Doe (@_johndoe) mentioned you on Twitter!\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis tellus ut turpis...',
    'time': '17:11',
    'id': 'msg_2',
  },
  {
    'title': 'Facebook',
    'subtitle':
        'New messages from John Doe\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis tellus ut turpis...',
    'time': '16:48',
    'id': 'msg_3',
  },
  {
    'title': 'John Doe (via Twitter)',
    'subtitle':
        'John Doe (@_johndoe) mentioned you on Twitter!\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis tellus ut turpis...',
    'time': '15:32',
    'id': 'msg_4',
  },
];

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  // State untuk Radio Group 1 (Inline)
  String? _inlineSelected = 'radio_1';

  // State untuk Radio Group 2 (Kiri)
  String? _groupLeftSelected = 'Food';

  // State untuk Radio Group 3 (Kanan)
  String? _groupRightSelected = 'Books';

  // State untuk Media List
  String? _mediaListSelected = 'msg_1';

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

  // --- Widget Pembantu: Radio Kustom Kompak (Dinamis) ---
  Widget _buildInlineRadio({
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required Color activeColor,
  }) {
    return Transform.scale(
      scale: 0.9,
      child: Radio<String>(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor, // Mengikuti tema
      ),
    );
  }

  // --- Widget Pembantu: Item Radio Group Sederhana (Dinamis) ---
  Widget _buildSimpleRadioItem({
    required String label,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required bool radioOnLeft,
    required Color activeColor,
    required Color textColor,
  }) {
    // Radio Group (Radio di Kiri)
    if (radioOnLeft) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
        title: Text(
          label,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        onTap: () => onChanged(value),
      );
    }
    // Radio Group (Radio di Kanan)
    else {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          label,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        trailing: Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
        onTap: () => onChanged(value),
      );
    }
  }

  // --- Widget Pembantu: Item Radio Media List (Dinamis) ---
  Widget _buildMediaRadioItem(Map<String, dynamic> item, Color activeColor,
      Color textColor, Color subtitleColor, Color dividerColor) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Radio<String>(
            value: item['id'],
            groupValue: _mediaListSelected,
            onChanged: (newValue) {
              setState(() {
                _mediaListSelected = newValue;
              });
            },
            activeColor: activeColor,
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  item['time'],
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ),
          subtitle: Text(
            item['subtitle'],
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            setState(() {
              _mediaListSelected = item['id'];
            });
          },
        ),
        Divider(height: 1, thickness: 0.5, color: dividerColor),
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
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor =
        isDark ? Colors.white60 : Colors.black54; // Untuk teks sekunder

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Header Halaman) ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBgColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Radio',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        // Tambahan border bawah di appbar agar konsisten
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: dividerColor, height: 1.0),
        ),
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Inline Radio
            _buildSectionTitle('Inline', primaryColor),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: textColor,
                  ),
                  children: [
                    const TextSpan(text: 'Lorem '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: _buildInlineRadio(
                        value: 'radio_1',
                        groupValue: _inlineSelected,
                        activeColor: primaryColor,
                        onChanged: (newValue) {
                          setState(() {
                            _inlineSelected = newValue;
                          });
                        },
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' ipsum dolor sit amet, consectetur adipisicing elit. Alias beatae illo nihil aut eius commodi sint eveniet aliquid eligendi',
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: _buildInlineRadio(
                        value: 'radio_2',
                        groupValue: _inlineSelected,
                        activeColor: primaryColor,
                        onChanged: (newValue) {
                          setState(() {
                            _inlineSelected = newValue;
                          });
                        },
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' ad delectus impedit tempore nemo, enim vel praesentium consequatur nulla mollitia!',
                    ),
                  ],
                ),
              ),
            ),

            // 2. Radio Group (Radio di Kiri)
            _buildSectionTitle('Radio Group', primaryColor),
            Column(
              children: groupOptions.map((option) {
                return _buildSimpleRadioItem(
                  label: option,
                  value: option,
                  groupValue: _groupLeftSelected,
                  activeColor: primaryColor,
                  textColor: textColor,
                  onChanged: (newValue) {
                    setState(() {
                      _groupLeftSelected = newValue;
                    });
                  },
                  radioOnLeft: true,
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // 3. Radio Group (Radio di Kanan)
            _buildSectionTitle('Radio Group', primaryColor),
            Column(
              children: groupOptions.map((option) {
                return _buildSimpleRadioItem(
                  label: option,
                  value: option,
                  groupValue: _groupRightSelected,
                  activeColor: primaryColor,
                  textColor: textColor,
                  onChanged: (newValue) {
                    setState(() {
                      _groupRightSelected = newValue;
                    });
                  },
                  radioOnLeft: false,
                );
              }).toList(),
            ),

            // 4. With Media Lists
            _buildSectionTitle('With Media Lists', primaryColor),
            Column(
              children: mediaListItems.map((item) {
                return _buildMediaRadioItem(
                    item, primaryColor, textColor, subtitleColor, dividerColor);
              }).toList(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
