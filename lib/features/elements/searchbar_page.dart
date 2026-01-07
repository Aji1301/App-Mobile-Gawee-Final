// lib/searchbar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class SearchbarPage extends StatefulWidget {
  const SearchbarPage({super.key});

  @override
  State<SearchbarPage> createState() => _SearchbarPageState();
}

class _SearchbarPageState extends State<SearchbarPage> {
  // Data List Mobil
  final List<String> _carBrands = [
    'Acura',
    'Audi',
    'BMW',
    'Cadillac',
    'Chevrolet',
    'Chrysler',
    'Dodge',
    'Ferrari',
    'Ford',
    'GMC',
    'Honda',
    'Hummer',
    'Hyundai',
    'Infiniti',
    'Isuzu',
    'Jaguar',
    'Jeep',
    'Kia',
    'Lamborghini',
    'Land Rover',
    'Lexus',
    'Lincoln',
    'Lotus',
    'Mazda',
    'Mercedes-Benz',
    'Mercury',
    'Mitsubishi',
    'Nissan',
    'Oldsmobile',
    'Peugeot',
    'Pontiac',
    'Porsche',
    'Regal',
    'Saab',
    'Saturn',
    'Subaru',
    'Suzuki',
    'Toyota',
    'Volkswagen',
    'Volvo'
  ];

  // State untuk menyimpan hasil filter
  List<String> _filteredBrands = [];

  @override
  void initState() {
    super.initState();
    _filteredBrands = _carBrands; // Inisialisasi dengan semua data
  }

  // --- Fungsi Filter ---
  void _filterBrands(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBrands = _carBrands;
      } else {
        _filteredBrands = _carBrands
            .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // --- Widget Search Field Kustom (Dinamis) ---
  Widget _buildCustomSearchField(
      Color bgColor, Color fieldColor, Color textColor, Color hintColor) {
    return Container(
      color: bgColor, // Latar belakang container search
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: TextField(
        onChanged: _filterBrands,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: hintColor, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: hintColor),
          filled: true,
          fillColor: fieldColor,
          // Bentuk pill
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        ),
      ),
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

    // Warna Teks, Hint, & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade600;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Search Field
    // Di mode gelap: search field lebih terang dikit dari background (cardColor)
    // Di mode terang: search field abu-abu muda (F7F7F8)
    final searchFieldColor =
        isDark ? themeProvider.scaffoldColorDark : const Color(0xFFF7F7F8);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar ---
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
            title: const Text('Searchbar'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: Column(
        children: [
          // 1. Widget Search Field
          _buildCustomSearchField(
              appBarBgColor, searchFieldColor, textColor, hintColor),

          // 2. Garis pemisah
          Divider(height: 1, thickness: 1, color: dividerColor),

          // 3. Daftar yang bisa di-scroll
          Expanded(
            child: ListView.separated(
              itemCount: _filteredBrands.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _filteredBrands[index],
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  onTap: () {
                    // Aksi saat item diklik (opsional)
                  },
                );
              },
              // Pemisah antar item
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 0.5,
                color: dividerColor,
                indent: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
