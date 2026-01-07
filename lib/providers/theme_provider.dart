import 'package:flutter/material.dart';
import '../utils/constants.dart'; // Import konstanta Anda

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = primaryPurple; // Ini adalah warna "tema" utama

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  // --- LOGIKA BARU UNTUK LATAR BELAKANG (SCAFFOLD) ---

  // 1. Saat Mode Terang:
  // Latar belakang berubah berdasarkan _primaryColor (dibuat jadi cerah)
  Color get scaffoldColorLight {
    // Jika warnanya ungu (default), gunakan lilac pucat yang sudah Anda tentukan
    if (_primaryColor == primaryPurple) {
      return lightScaffoldColor; // Default: 0xFFF7F5FC
    }

    // Jika warnanya lain (misal: biru), buat versi "cerah" dari warna itu.
    // Di sini kita campur 85% Putih dengan 15% Warna Primer.
    // Ini akan menghasilkan warna "pastel" atau "cerah" yang Anda inginkan.
    return Color.lerp(Colors.white, _primaryColor, 0.15)!;
  }

  // 2. Saat Mode Gelap:
  // Latar belakang SELALU TETAP ungu tua, tidak peduli apa warna temanya.
  Color get scaffoldColorDark =>
      const Color.fromARGB(255, 0, 0, 0); // Default: 0xFF1E003A

  // 3. Warna Kartu (Card):
  // Logika ini tetap sama, bergantung pada mode terang/gelap.
  Color get cardColor {
    return _themeMode == ThemeMode.dark ? darkCardColor : lightCardColor;
  }

  // --- FUNGSI UNTUK MENGUBAH PENGATURAN ---

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // setPrimaryColor sekarang JAUH LEBIH SEDERHANA
  void setPrimaryColor(Color color) {
    _primaryColor = color;
    // Kita tidak perlu menghitung scaffoldColorDark di sini lagi.
    // Getter di atas akan mengurus semuanya secara otomatis.
    notifyListeners();
  }
}
