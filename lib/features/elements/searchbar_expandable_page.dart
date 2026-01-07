// lib/searchbar_expandable_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// --- Data List Mobil (Sama seperti halaman Searchbar) ---
const List<String> _carBrands = [
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

// --- Halaman Utama (Stateless) ---
class SearchbarExpandablePage extends StatelessWidget {
  const SearchbarExpandablePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Hanya Judul dan Ikon Search) ---
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
            title: const Text('Searchbar'), // Judul halaman
            centerTitle: true,
            actions: [
              // --- Tombol Pemicu Search ---
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Memanggil SearchDelegate dengan Theme Provider
                  showSearch(
                    context: context,
                    delegate: _CarSearchDelegate(
                      _carBrands,
                      themeProvider, // Pass theme provider ke delegate
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // --- Body (Daftar Awal) ---
      body: ListView.separated(
        itemCount: _carBrands.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_carBrands[index],
                style: TextStyle(fontSize: 16, color: textColor)),
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 0.5,
          color: dividerColor,
          indent: 16.0,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- LOGIKA PENCARIAN (Search Delegate) ---
// -----------------------------------------------------------------
class _CarSearchDelegate extends SearchDelegate<String> {
  final List<String> carBrands;
  final ThemeProvider themeProvider; // Terima ThemeProvider

  // Konstruktor
  _CarSearchDelegate(this.carBrands, this.themeProvider);

  // --- 1. Tombol Aksi (di sebelah kanan, misal: Clear) ---
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Menghapus teks di search bar
        },
      ),
    ];
  }

  // --- 2. Tombol Leading (di sebelah kiri, misal: Back) ---
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Menutup halaman pencarian
      },
    );
  }

  // --- 3. Hasil setelah menekan Enter ---
  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  // --- 4. Sugesti yang muncul saat mengetik ---
  @override
  Widget buildSuggestions(BuildContext context) {
    // Ambil warna tema untuk hasil pencarian
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;

    // Filter daftar berdasarkan query
    final List<String> suggestionList = query.isEmpty
        ? []
        : carBrands
            .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
            .toList();

    // Bungkus dengan Container warna background agar sesuai tema
    return Container(
      color: scaffoldBgColor,
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          final String suggestion = suggestionList[index];
          return ListTile(
            title: Text(suggestion, style: TextStyle(color: textColor)),
            onTap: () {
              close(context, suggestion);
            },
          );
        },
      ),
    );
  }

  // Mengganti tema search bar agar sesuai dengan ThemeProvider
  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.grey;

    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      scaffoldBackgroundColor:
          isDark ? themeProvider.scaffoldColorDark : Colors.white,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: appBarBgColor,
        elevation: 0,
        foregroundColor: textColor,
        iconTheme: IconThemeData(color: textColor),
        toolbarTextStyle: TextStyle(color: textColor, fontSize: 18),
        titleTextStyle: TextStyle(color: textColor, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: hintColor),
        border: InputBorder.none,
      ),
      // Penting: textSelectionTheme untuk kursor dan highlight
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: themeProvider.primaryColor,
        selectionColor: themeProvider.primaryColor.withOpacity(0.3),
        selectionHandleColor: themeProvider.primaryColor,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(color: textColor, fontSize: 18),
      ),
    );
  }
}
