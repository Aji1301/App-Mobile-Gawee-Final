import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan file ThemeProvider Anda

// Data Model untuk setiap pahlawan
class HeroToggle {
  final String name;
  final Color activeColor;
  bool isEnabled;

  HeroToggle({
    required this.name,
    required this.activeColor,
    this.isEnabled = false,
  });
}

// Data daftar pahlawan dengan warna kustom
final List<HeroToggle> heroData = [
  HeroToggle(
    name: 'Batman',
    activeColor: const Color(0xFF673AB7),
    isEnabled: true,
  ),
  HeroToggle(
    name: 'Aquaman',
    activeColor: const Color(0xFF03A9F4),
    isEnabled: true,
  ),
  HeroToggle(
    name: 'Superman',
    activeColor: const Color(0xFFF44336),
    isEnabled: true,
  ),
  HeroToggle(
    name: 'Hulk',
    activeColor: const Color(0xFF4CAF50),
    isEnabled: true,
  ),
  HeroToggle(
    name: 'Spiderman',
    activeColor: const Color(0xFF9C27B0),
    isEnabled: true,
  ),
  HeroToggle(
    name: 'Ironman',
    activeColor: const Color(0xFF9147FF),
    isEnabled: true,
  ),
  HeroToggle(
    name: 'Thor',
    activeColor: const Color(0xFF795548),
    isEnabled: true,
  ),
  HeroToggle(
    name: 'Wonder',
    activeColor: const Color(0xFFFF9800).withOpacity(0.8),
    isEnabled: true,
  ),
];

class TogglePage extends StatefulWidget {
  const TogglePage({super.key});

  @override
  State<TogglePage> createState() => _TogglePageState();
}

class _TogglePageState extends State<TogglePage> {
  // Menggunakan list data hero sebagai state
  late List<HeroToggle> _heroes;

  @override
  void initState() {
    super.initState();
    // Menggunakan data dummy yang sudah diatur
    _heroes = List.from(heroData);
  }

  void _onToggleChanged(int index, bool newValue) {
    setState(() {
      _heroes[index].isEnabled = newValue;
    });
  }

  // --- Widget Pembantu: Judul Bagian Ungu (Sekarang Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, bottom: 12.0, left: 16.0), // Tambah padding left agar rapi
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryColor, // Mengikuti warna tema
        ),
      ),
    );
  }

  // --- Widget Pembantu: List Item dengan Toggle Kustom ---
  Widget _buildToggleListItem(
      BuildContext context, int index, HeroToggle hero, bool isDark) {
    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Switch saat OFF (Inactive)
    // Dark mode butuh warna track yang lebih gelap/transparan
    final inactiveTrack = isDark ? Colors.white10 : Colors.grey.shade200;
    final inactiveThumb = isDark ? Colors.white30 : Colors.grey.shade400;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            hero.name,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
          trailing: Switch(
            value: hero.isEnabled,
            onChanged: (newValue) => _onToggleChanged(index, newValue),

            // Warna ON: Tetap mengikuti warna khas pahlawan (sesuai data)
            activeColor: hero.activeColor,

            // Warna OFF: Disesuaikan dengan Dark/Light mode
            inactiveThumbColor: inactiveThumb,
            inactiveTrackColor: inactiveTrack,
          ),
          onTap: () {
            _onToggleChanged(index, !hero.isEnabled);
          },
        ),
        // Divider
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Divider(height: 1, thickness: 0.5, color: dividerColor),
        ),
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
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;

    // Warna AppBar
    final appBarBgColor = isDark ? Colors.transparent : Colors.white;
    // Jika light mode, appbar putih agar bersih, atau bisa pakai scaffoldBgColor
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
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
              'Toggle',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Judul Bagian (Warna mengikuti primaryColor)
            _buildSectionTitle('Super Heroes', primaryColor),

            // Daftar Toggle
            ..._heroes.asMap().entries.map((entry) {
              return _buildToggleListItem(
                  context, entry.key, entry.value, isDark);
            }).toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
