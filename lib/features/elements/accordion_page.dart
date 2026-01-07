import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// Data konten panjang yang diminta untuk item lainnya
final String accordionContent =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean elementum id neque nec commodo. Sed vel justo at turpis laoreet pellentesque quis sed lorem. Integer semper arcu nibh, non mollis arcu tempor vel. Sed pharetra tortor vitae est rhoncus, vel congue dui sollicitudin. Donec eu arcu dignissim felis viverra blandit suscipit eget ipsum.';

// Data untuk Nested List
final List<String> nestedItems = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

// Model Data untuk setiap item akordeon
class AccordionItemData {
  final String title;
  final Widget content;
  final bool isOpposite;

  AccordionItemData(this.title, this.content, this.isOpposite);
}

class AccordionPage extends StatefulWidget {
  const AccordionPage({super.key});

  @override
  State<AccordionPage> createState() => _AccordionPageState();
}

class _AccordionPageState extends State<AccordionPage> {
  // MANAJEMEN STATE: Kunci untuk melacak item mana yang sedang terbuka
  String? _currentlyOpenItem;

  late final List<AccordionItemData> listViewData;
  late final List<AccordionItemData> oppositeSideData;

  @override
  void initState() {
    super.initState();

    // Konten yang diperlukan (Text widget akan dibuild ulang di dalam ListView agar bisa menyesuaikan tema)

    // Inisialisasi List View Accordion
    // Konten akan dibuild secara dinamis di _buildAccordionItem agar bisa mengikuti tema
    listViewData = [
      AccordionItemData(
          'Lorem Ipsum', const Text(''), false), // Placeholder content
      AccordionItemData(
          'Nested List', const SizedBox(), false), // Placeholder content
      AccordionItemData(
          'Integer semper', const Text(''), false), // Placeholder content
    ];

    // Inisialisasi Opposite Side
    oppositeSideData = [
      AccordionItemData('Lorem Ipsum', const Text(''), true),
      AccordionItemData('Nested List', const SizedBox(), true),
      AccordionItemData('Integer semper', const Text(''), true),
    ];
  }

  // --- Widget Pembantu untuk Konten Daftar Bersarang (Nested List) ---
  Widget _buildNestedListContent(
      Color textColor, Color primaryColor, Color iconBgColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nestedItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- FUNGSI PEMBANTU BERSATU (_buildAccordionItem) ---
  Widget _buildAccordionItem(BuildContext context, AccordionItemData item,
      Color textColor, Color primaryColor, Color iconBgColor) {
    // Cek apakah item ini yang sedang terbuka
    final bool isExpanded = item.title == _currentlyOpenItem;

    // Tentukan konten berdasarkan judul (karena konten perlu akses ke warna tema)
    Widget content;
    if (item.title == 'Nested List') {
      content = _buildNestedListContent(textColor, primaryColor, iconBgColor);
    } else {
      content = Text(
        accordionContent,
        style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // MANAJEMEN STATE: Mengontrol apakah item terbuka atau tertutup
        initiallyExpanded: isExpanded,

        // MANAJEMEN STATE: Ketika item diperluas/ditutup, atur state-nya
        onExpansionChanged: (bool expanding) {
          setState(() {
            if (expanding) {
              _currentlyOpenItem = item.title;
            } else if (isExpanded) {
              _currentlyOpenItem = null;
            }
          });
        },

        // Panah kiri untuk Opposite Side
        leading: item.isOpposite
            ? Icon(
                Icons.keyboard_arrow_down,
                color: isExpanded
                    ? primaryColor
                    : Colors.grey, // Warna panah aktif
                size: 20,
              )
            : null,

        title: Text(
          item.title,
          style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal),
        ),

        // Panah kanan untuk List View Accordion
        trailing: item.isOpposite
            ? const SizedBox()
            : Icon(
                Icons.keyboard_arrow_down,
                color: isExpanded ? primaryColor : Colors.grey,
                size: 20,
              ),

        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),

        children: <Widget>[
          Padding(
            // Padding disesuaikan berdasarkan posisi ikon
            padding: EdgeInsets.only(
              left: item.isOpposite ? 48.0 : 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            child: content,
          ),
        ],
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
    final containerBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks & Icon
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconBgColor = isDark ? Colors.grey[700]! : const Color(0xFFF2F2F7);

    // Warna Border
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE0E0E0);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor, // Background dinamis

      // --- AppBar (Header Halaman) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor, // AppBar background dinamis
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor, // Warna teks/ikon AppBar dinamis
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Accordion',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Bagian 1: List View Accordion ---
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                'List View Accordion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor, // Mengikuti tema
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: containerBgColor, // Container background dinamis
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor, width: 1.0),
                ),
                child: Column(
                  children: listViewData.map((item) {
                    return _buildAccordionItem(
                        context, item, textColor, primaryColor, iconBgColor);
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- Bagian 2: Opposite Side ---
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Text(
                'Opposite Side',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor, // Mengikuti tema
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: containerBgColor, // Container background dinamis
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor, width: 1.0),
                ),
                child: Column(
                  children: oppositeSideData.map((item) {
                    return _buildAccordionItem(
                        context, item, textColor, primaryColor, iconBgColor);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
