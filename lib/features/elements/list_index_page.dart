import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// Data kontak lengkap (Sama seperti sebelumnya)
final Map<String, List<String>> fullContactsData = {
  'A': [
    'Aaron',
    'Adam',
    'Aiden',
    'Albert',
    'Alex',
    'Alexander',
    'Alfie',
    'Archie',
    'Arthur',
    'Austin'
  ],
  'B': ['Benjamin', 'Blake', 'Bobby'],
  'C': ['Caleb', 'Callum', 'Cameron', 'Charles', 'Charlie', 'Connor'],
  'D': ['Daniel', 'David', 'Dexter', 'Dylan'],
  'E': ['Edward', 'Elijah', 'Elliot', 'Elliott', 'Ethan', 'Evan'],
  'F': ['Felix', 'Finlay', 'Finley', 'Frankie', 'Freddie', 'Frederick'],
  'G': ['Gabriel', 'George'],
  'H': ['Harley', 'Harrison', 'Harry', 'Harvey', 'Henry', 'Hugo'],
  'I': ['Ibrahim', 'Isaac'],
  'J': [
    'Jack',
    'Jacob',
    'Jake',
    'James',
    'Jamie',
    'Jayden',
    'Jenson',
    'Joseph',
    'Joshua',
    'Jude'
  ],
  'K': ['Kai', 'Kian'],
  'L': [
    'Leo',
    'Leon',
    'Lewis',
    'Liam',
    'Logan',
    'Louie',
    'Louis',
    'Luca',
    'Lucas',
    'Luke'
  ],
  'M': [
    'Mason',
    'Matthew',
    'Max',
    'Michael',
    'Mohammad',
    'Mohammed',
    'Muhammad'
  ],
  'N': ['Nathan', 'Noah'],
  'O': ['Oliver', 'Ollie', 'Oscar', 'Owen'],
  'R': ['Reuben', 'Riley', 'Robert', 'Ronnie', 'Rory', 'Ryan'],
  'S': ['Samuel', 'Sebastian', 'Seth', 'Sonny', 'Stanley'],
  'T': ['Teddy', 'Theo', 'Theodore', 'Thomas', 'Toby', 'Tommy', 'Tyler'],
  'W': ['William'],
  'Z': ['Zachary'],
};

// Urutan alfabet
final List<String> alphabeticalIndex = fullContactsData.keys.toList();

// Kelas ListItem
class ListItem {
  final String title;
  final bool isHeader;
  ListItem(this.title, {this.isHeader = false});
}

// Helper Map ke List
List<ListItem> getListItems() {
  List<ListItem> listItems = [];
  fullContactsData.forEach((key, value) {
    listItems.add(ListItem(key, isHeader: true));
    value.map((name) => listItems.add(ListItem(name))).toList();
  });
  return listItems;
}

// -------------------------------------------------------------------
// HALAMAN UTAMA
// -------------------------------------------------------------------

class ListIndexPage extends StatefulWidget {
  const ListIndexPage({super.key});

  @override
  State<ListIndexPage> createState() => _ListIndexPageState();
}

class _ListIndexPageState extends State<ListIndexPage> {
  final List<ListItem> listItems = getListItems();
  final ScrollController _scrollController = ScrollController();
  final Map<String, double> _headerOffsets = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _calculateHeaderOffsets(),
    );
  }

  void _calculateHeaderOffsets() {
    double offset = 0.0;
    const double headerHeight = 16.0 + 16.0;
    const double listItemHeight = 56.0;

    for (var item in listItems) {
      if (item.isHeader) {
        _headerOffsets[item.title] = offset;
        offset += headerHeight;
      } else {
        offset += listItemHeight;
      }
    }
  }

  void _jumpToLetter(String letter) {
    if (_headerOffsets.containsKey(letter)) {
      _scrollController.animateTo(
        _headerOffsets[letter]!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;

    // Background AppBar (Ungu muda di light mode, Card color di dark mode)
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black;

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: scaffoldBgColor, // Background dinamis

      // --- AppBar ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor, // Background dinamis
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor, // Warna icon/teks dinamis
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'List Index',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      body: Stack(
        children: [
          // --- 1. Konten List View Utama ---
          ListView.builder(
            controller: _scrollController,
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              final item = listItems[index];

              if (item.isHeader) {
                // Header Huruf (A, B, C, dst.)
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor, // Mengikuti tema
                    ),
                  ),
                );
              } else {
                // Item Kontak
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 16.0),
                      dense: true,
                      title: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 16, color: textColor), // Teks dinamis
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Anda mengklik: ${item.title}'),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor, // Divider dinamis
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          // --- 2. Side Index Bar (Di Kanan) ---
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Container(
                width: 20,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: alphabeticalIndex.map((letter) {
                    return GestureDetector(
                      onTap: () => _jumpToLetter(letter),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.5),
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor, // Warna index dinamis
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
