import 'package:flutter/material.dart';

// --- Warna Utama Aplikasi ---
const Color primaryPurple = Color(0xFF6A1B9A);

// --- Warna Scaffold (Latar Belakang Aplikasi) ---
// Warna latar belakang terang: Lilac pucat (sesuai gambar referensi)
const Color lightScaffoldColor = Color(0xFFF7F5FC);

// Warna latar belakang gelap: Ungu tua (bukan hitam pekat)
const Color darkScaffoldColor = Color(0xFF1E003A);

// --- Warna Kartu/Elemen Kontainer ---
const Color lightCardColor = Colors.white;
const Color darkCardColor = Color(0xFF2C2C2C);

// --- Daftar Warna Default untuk Pengaturan Tema ---
final Map<String, Color> defaultColors = {
  'Red': Colors.red,
  'Green': Colors.green,
  'Blue': Colors.blue,
  'Pink': Colors.pink,
  'Yellow': Colors.yellow.shade700,
  'Orange': Colors.orange,
  'Purple': primaryPurple,
  'DeepPurple': Colors.deepPurple,
  'LightBlue': Colors.lightBlue,
  'Teal': Colors.teal,
  'Lime': Colors.lime.shade700,
  'DeepOrange': Colors.deepOrange,
};
