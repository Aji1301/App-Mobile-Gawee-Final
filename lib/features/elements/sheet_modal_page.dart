// lib/sheet_modal_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class SheetModalPage extends StatefulWidget {
  const SheetModalPage({super.key});

  @override
  State<SheetModalPage> createState() => _SheetModalPageState();
}

class _SheetModalPageState extends State<SheetModalPage> {
  // --- Helper: Judul Bagian (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor, // Mengikuti tema
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Helper: Deskripsi (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.4,
          color: textColor, // Mengikuti tema
        ),
      ),
    );
  }

  // --- Helper: Tombol Dinamis ---
  Widget _buildDynamicButton({
    required String text,
    required VoidCallback onPressed,
    required Color buttonColor,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: buttonColor, // Mengikuti tema
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- Aksi Universal (Menggunakan Bottom Sheet Bawaan) ---
  void _openStandardSheet(Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: content,
        );
      },
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

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

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
            title: const Text('Sheet Modal'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian 1: Intro ---
            _buildDescription(
              'Sheet Modals slide up from the bottom (or down from the top) of the screen to reveal more content. Such modals allow to create custom overlays with custom content.',
              textColor,
            ),
            const SizedBox(height: 16),

            // --- Bagian 2: Tombol Dasar ---
            Row(
              children: [
                Expanded(
                  child: _buildDynamicButton(
                    text: 'Open Sheet',
                    onPressed: () => _openStandardSheet(_DefaultSheetContent(
                        title: 'Hello!',
                        isDark: isDark,
                        primaryColor: primaryColor)),
                    buttonColor: primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDynamicButton(
                    text: 'Dynamic Sheet',
                    onPressed: () => _openStandardSheet(
                      _DefaultSheetContent(
                        title: 'Dynamic Sheet',
                        isDark: isDark,
                        primaryColor: primaryColor,
                        customContent: Text(
                          'Konten ini dibuat pada: ${DateFormat.yMd().add_Hms().format(DateTime.now())}',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ),
                    ),
                    buttonColor: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDynamicButton(
              text: 'Top Sheet',
              onPressed: () {
                _openStandardSheet(_DefaultSheetContent(
                    title: 'Top Sheet (Demo)',
                    isDark: isDark,
                    primaryColor: primaryColor));
              },
              buttonColor: primaryColor,
            ),

            // --- Bagian 3: Push View ---
            _buildSectionTitle('Push View', primaryColor),
            _buildDescription(
              'Sheet can push view behind on open. By default it has effect only when is more than zero (iOS fullscreen webapp or iOS cordova app) safe-area-inset-top',
              textColor,
            ),
            const SizedBox(height: 16),
            _buildDynamicButton(
              text: 'Sheet Push',
              onPressed: () {
                _openStandardSheet(_DefaultSheetContent(
                    title: 'Push Sheet (Demo)',
                    isDark: isDark,
                    primaryColor: primaryColor));
              },
              buttonColor: primaryColor,
            ),

            // --- Bagian 4: Swipeable Sheet ---
            _buildSectionTitle('Swipeable Sheet', primaryColor),
            _buildDescription(
              'Sheet modal can be closed with swipe to top (for top Sheet) or bottom (for default Bottom sheet):',
              textColor,
            ),
            const SizedBox(height: 16),
            _buildDynamicButton(
              text: 'Swipe To Close',
              onPressed: () {
                _openStandardSheet(_DefaultSheetContent(
                    title: 'Hello!',
                    isDark: isDark,
                    primaryColor: primaryColor));
              },
              buttonColor: primaryColor,
            ),

            const SizedBox(height: 16),
            _buildDescription(
              'Also there is swipe-step that can be set on Sheet modal to expand it with swipe:',
              textColor,
            ),
            const SizedBox(height: 16),
            _buildDynamicButton(
              text: 'Swipe To Step',
              onPressed: () {
                _openStandardSheet(_MakePaymentSheetContent(
                    isDark: isDark, primaryColor: primaryColor));
              },
              buttonColor: primaryColor,
            ),

            const SizedBox(height: 16),
            _buildDescription(
              'In addition to "swipe step" there is a support for position breakpoints (multiple steps):',
              textColor,
            ),
            const SizedBox(height: 16),
            _buildDynamicButton(
              text: 'Breakpoints',
              onPressed: () {
                _openStandardSheet(_MakePaymentSheetContent(
                    isDark: isDark, primaryColor: primaryColor));
              },
              buttonColor: primaryColor,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- WIDGET KONTEN 1: SHEET "Hello!" ---
// -----------------------------------------------------------------
class _DefaultSheetContent extends StatelessWidget {
  final String title;
  final Widget? customContent;
  final bool isDark;
  final Color primaryColor;

  const _DefaultSheetContent({
    Key? key,
    required this.title,
    this.customContent,
    required this.isDark,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tentukan warna background sheet dan teks
    final sheetBgColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white; // Card color umum di dark mode
    final textColor = isDark ? Colors.white : Colors.black87;

    return Material(
      color: sheetBgColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ukuran pas dengan konten
          children: [
            // --- Drag Handle ---
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // --- Konten yang Bisa di-scroll ---
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    Text(
                      title,
                      style: TextStyle(
                        color: primaryColor, // Mengikuti tema
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Konten (Bisa dinamis atau statis)
                    customContent ??
                        Text(
                          'Eaque maiores ducimus, impedit unde culpa qui, explicabo accusamus, non vero corporis voluptatibus similique odit ab. Quaerat quasi consectetur quidem libero? Repudiandae adipisci vel voluptatum, autem libero minus dignissimos repellat.',
                          style: TextStyle(
                              fontSize: 16.0, height: 1.5, color: textColor),
                        ),
                    const SizedBox(height: 16),
                    Text(
                      'Iusto, est corrupti! Totam minus voluptas natus esse possimus nobis, delectus veniam expedita sapiente ut cum reprehenderit aliquid odio amet praesentium vero temporibus obcaecati beatae aspernatur incidunt, perferendis voluptates doloribus?',
                      style: TextStyle(
                          fontSize: 16.0, height: 1.5, color: textColor),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- WIDGET KONTEN 2: SHEET "MAKE PAYMENT" ---
// -----------------------------------------------------------------
class _MakePaymentSheetContent extends StatelessWidget {
  final bool isDark;
  final Color primaryColor;

  const _MakePaymentSheetContent({
    Key? key,
    required this.isDark,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sheetBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Material(
      color: sheetBgColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Drag Handle ---
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // --- Konten Pembayaran ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Total
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                        Text(
                          '\$500',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol "MAKE PAYMENT"
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup sheet
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor, // Mengikuti tema
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'MAKE PAYMENT',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Teks "Swipe up"
                  Text(
                    'Swipe up for more details',
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
