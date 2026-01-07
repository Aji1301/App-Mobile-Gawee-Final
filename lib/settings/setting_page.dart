import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Sesuaikan path import ini
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // State lokal untuk bottom nav bar (jika halaman ini punya)
  // Jika bottom nav bar ada di dashboard, Anda tidak perlu ini.
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Ambil provider. 'listen: true' agar UI update saat tema berubah
    final themeProvider = Provider.of<ThemeProvider>(context);
    final Color activeColor = themeProvider.primaryColor;
    final bool isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Judul sudah di-style oleh AppBarTheme di main.dart
        title: const Text("Color Themes"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Link",
              // Style text di sini jika perlu override theme
              style: GoogleFonts.poppins(color: activeColor, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian Layout Themes ---
            _buildSectionTitle("Layout Themes", activeColor),
            _buildLayoutThemeCard(themeProvider, isDark, activeColor),
            const SizedBox(height: 24),

            // --- Bagian Default Color Themes ---
            _buildSectionTitle("Default Color Themes", activeColor),
            _buildDefaultColorCard(themeProvider),
            const SizedBox(height: 24),

            // --- Bagian Custom Color Theme ---
            _buildSectionTitle("Custom Color Theme", activeColor),
            _buildCustomColorCard(themeProvider, activeColor),
          ],
        ),
      ),

      // Jika halaman ini punya BottomNav sendiri
      // Hapus jika BottomNav ada di halaman lain (misal: Dashboard)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed, // Agar label selalu terlihat
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              backgroundColor: Colors.red,
              label: Text(
                '5',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
              ),
              child: const Icon(Icons.calendar_today),
            ),
            label: "Calendar",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: "Upload",
          ),
        ],
      ),
    );
  }

  // Helper widget untuk judul bagian
  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper widget untuk Card (latar belakang putih bulat)
  Widget _buildCard({required Widget child}) {
    // Card akan otomatis menggunakan cardColor dari ThemeData
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }

  // Card untuk pilihan Light/Dark Mode
  Widget _buildLayoutThemeCard(
    ThemeProvider provider,
    bool isDark,
    Color activeColor,
  ) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Framework7 comes with 2 main layout themes: Light (default) and Dark:",
            style: GoogleFonts.poppins(), // Terapkan font
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Tombol Light Mode
              GestureDetector(
                onTap: () => provider.toggleTheme(false), // Panggil provider
                child: Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: !isDark
                      ? Icon(Icons.check_box, color: activeColor)
                      : null,
                ),
              ),
              // Tombol Dark Mode
              GestureDetector(
                onTap: () => provider.toggleTheme(true), // Panggil provider
                child: Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.grey.shade600),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isDark
                      ? const Icon(Icons.check_box, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Card untuk 12 grid warna default
  Widget _buildDefaultColorCard(ThemeProvider provider) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Framework7 comes with 12 color themes set.",
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: defaultColors.length, // Gunakan dari constants.dart
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String name = defaultColors.keys.elementAt(index);
              Color color = defaultColors.values.elementAt(index);
              return Material(
                color: color,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    // INI KUNCINYA: Panggil provider, bukan setState di main
                    provider.setPrimaryColor(color);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: Text(
                      name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Card untuk pemilih warna custom
  Widget _buildCustomColorCard(ThemeProvider provider, Color activeColor) {
    return _buildCard(
      child: GestureDetector(
        onTap: () {
          // Menampilkan dialog color picker
          _showColorPicker(context, provider);
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HEX Color",
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
                Text(
                  // Menampilkan kode HEX
                  '#${activeColor.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog color picker
  void _showColorPicker(BuildContext context, ThemeProvider provider) {
    // Ambil warna saat ini dari provider
    Color currentColor = provider.primaryColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Color', style: GoogleFonts.poppins()),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                currentColor = color; // Simpan sementara
              },
              // colorPickerShape: ColorPickerAreaShape.wheel,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: GoogleFonts.poppins()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Done', style: GoogleFonts.poppins()),
              onPressed: () {
                // Set warna HANYA saat "Done" ditekan
                provider.setPrimaryColor(currentColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
