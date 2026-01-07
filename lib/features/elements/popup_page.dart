// lib/popup_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class PopupPage extends StatelessWidget {
  const PopupPage({super.key});

  // --- Helper: Judul Bagian (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Text(
      title,
      style: TextStyle(
        color: primaryColor, // Mengikuti tema
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // --- Helper: Teks Deskripsi (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        height: 1.4,
        color: textColor, // Mengikuti tema
      ),
    );
  }

  // --- Helper: Tombol Dinamis ---
  Widget _buildDynamicButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Color buttonColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor, // Mengikuti tema
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- Helper untuk menampilkan popup (Layar Penuh) ---
  void _showAppPopup(
      BuildContext context, Widget contentWidget, Color bgColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor, // Mengikuti tema
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (modalContext) {
        return contentWidget;
      },
    );
  }

  // --- Helper untuk modal sheet standar ---
  void _showAppModalSheet(
      BuildContext context, Widget contentWidget, Color bgColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor, // Mengikuti tema
      useSafeArea: true,
      builder: (modalContext) {
        return contentWidget;
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

    // Warna Background Popup/Sheet
    final popupBgColor = isDark ? themeProvider.cardColor : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(
              bottom: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Popup'),
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
            // --- Bagian 1: Popup ---
            _buildSectionTitle('Popup', primaryColor),
            const SizedBox(height: 8),
            _buildDescription(
              'Popup is a modal window with any HTML content that pops up over App\'s main content. Popup as all other overlays is part of so called "Temporary Views".',
              textColor,
            ),
            _buildDynamicButton(
              context: context,
              text: 'Open Popup',
              buttonColor: primaryColor,
              onPressed: () => _showAppPopup(
                  context,
                  _DefaultPopupContent(
                      isDark: isDark,
                      textColor: textColor,
                      dividerColor: dividerColor,
                      bgColor: popupBgColor,
                      primaryColor: primaryColor),
                  popupBgColor),
            ),
            _buildDynamicButton(
              context: context,
              text: 'Create Dynamic Popup',
              buttonColor: primaryColor,
              onPressed: () => _showAppPopup(
                  context,
                  _DynamicPopupContent(
                      isDark: isDark,
                      textColor: textColor,
                      dividerColor: dividerColor,
                      bgColor: popupBgColor,
                      primaryColor: primaryColor),
                  popupBgColor),
            ),

            const SizedBox(height: 32),

            // --- Bagian 2: Swipe To Close ---
            _buildSectionTitle('Swipe To Close', primaryColor),
            const SizedBox(height: 8),
            _buildDescription(
              'Popup can be closed with swipe to top or bottom:',
              textColor,
            ),
            _buildDynamicButton(
              context: context,
              text: 'Swipe To Close',
              buttonColor: primaryColor,
              onPressed: () => _showAppPopup(
                  context,
                  _SwipeToClosePopupContent(
                      isDark: isDark,
                      textColor: textColor,
                      dividerColor: dividerColor,
                      bgColor: popupBgColor),
                  popupBgColor),
            ),
            const SizedBox(height: 16),
            _buildDescription(
              'Or it can be closed with swipe on special swipe handler and, for example, only to bottom:',
              textColor,
            ),
            _buildDynamicButton(
              context: context,
              text: 'With Swipe Handler',
              buttonColor: primaryColor,
              onPressed: () => _showAppModalSheet(
                  context,
                  _SwipeHandlerPopupContent(
                      isDark: isDark,
                      textColor: textColor,
                      bgColor: popupBgColor,
                      primaryColor: primaryColor),
                  popupBgColor),
            ),

            const SizedBox(height: 32),

            // --- Bagian 3: Push View ---
            _buildSectionTitle('Push View', primaryColor),
            const SizedBox(height: 8),
            _buildDescription(
              'Popup can push view behind. By default it has effect only when "safe-area-inset-top" is more than zero (iOS fullscreen webapp or iOS cordova app)',
              textColor,
            ),
            _buildDynamicButton(
              context: context,
              text: 'Popup Push',
              buttonColor: primaryColor,
              onPressed: () {
                debugPrint('Popup Push tapped');
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- KUMPULAN WIDGET KONTEN POPUP ---
// -------------------------------------------------------------------

// --- 1. Konten untuk "Open Popup" ---
class _DefaultPopupContent extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color dividerColor;
  final Color bgColor;
  final Color primaryColor;

  const _DefaultPopupContent({
    required this.isDark,
    required this.textColor,
    required this.dividerColor,
    required this.bgColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      color: bgColor,
      child: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                border:
                    Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
              ),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: textColor,
                automaticallyImplyLeading: false,
                title: const Text('Popup'),
                centerTitle: true,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close',
                        style: TextStyle(color: primaryColor, fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This is default popup',
                    style: TextStyle(
                        fontSize: 16.0, height: 1.5, color: textColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse faucibus mauris leo, eu bibendum neque congue non. Ut leo turpis, eleifend blanditsen, varius quis nisl. Ut justo sem, donec vel ullamcorper, ultrices et minim. Aliquam lorem massa, reprof occult, tristique id sen. Aliquam erat volutpat.',
                    style: TextStyle(
                        fontSize: 16.0, height: 1.5, color: textColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Duis ac facilisis leo, nec commodo ligula. Quisque sodales vel ligula acf maximus. Pellentesque finibus aliquet tellus, eu eleifend facilis. Nulla in pharetra ipsum, et posuere turpis. Pellentesque curabitur at nibh acd bunc. Aenea commodo, erat vel finibus sodales, dolor diam facilisis purusa, non pulvinar felis sapien vel eros. Nunc in rutrum augue. Pellentesque non justo non lectus vulputate fringilla. Aenean nec tamen mauris. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
                    style: TextStyle(
                        fontSize: 16.0, height: 1.5, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. Konten untuk "Create Dynamic Popup" ---
class _DynamicPopupContent extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color dividerColor;
  final Color bgColor;
  final Color primaryColor;

  const _DynamicPopupContent({
    required this.isDark,
    required this.textColor,
    required this.dividerColor,
    required this.bgColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      color: bgColor,
      child: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                border:
                    Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
              ),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: textColor,
                automaticallyImplyLeading: false,
                title: const Text('Dynamic Popup'),
                centerTitle: true,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close',
                        style: TextStyle(color: primaryColor, fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This popup was created dynamically',
                    style: TextStyle(
                        fontSize: 16.0,
                        height: 1.5,
                        color: textColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse faucibus mauris leo, eu bibendum neque congue non. Ut leo mauris, eleifend in lacus faucibus, viverra ipsum pulvinar, molestie arcu. Etiam lacinia venenatis dignissim. Suspendisse non nisl semper tellus malesuada suscipit eu et eros. Nulla eu enim quis quam elementum vulputate. Mauris ornare consequat nunc viverra pellentesque. Aenean semper eu massa sit amet aliquam. Integer et neque sed libero mollis elementum at vitae ligula. Vestibulum pharetra sed libero sed porttitor. Suspendisse a faucibus lectus.',
                    style: TextStyle(
                        fontSize: 16.0, height: 1.5, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. Konten untuk "Swipe To Close" ---
class _SwipeToClosePopupContent extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color dividerColor;
  final Color bgColor;

  const _SwipeToClosePopupContent({
    required this.isDark,
    required this.textColor,
    required this.dividerColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      color: bgColor,
      child: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                border:
                    Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
              ),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: textColor,
                automaticallyImplyLeading: false,
                title: const Text('Swipe To Close'),
                centerTitle: true,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close',
                        style: TextStyle(color: textColor, fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Swipe me up or down',
                style: TextStyle(
                    fontSize: 16.0,
                    color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 4. Konten untuk "With Swipe Handler" ---
class _SwipeHandlerPopupContent extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color bgColor;
  final Color primaryColor;

  const _SwipeHandlerPopupContent({
    required this.isDark,
    required this.textColor,
    required this.bgColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor, // Pastikan background modal mengikuti tema
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

          // --- Konten ---
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello!',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse faucibus mauris leo, eu bibendum neque congue non. Ut leo mauris, eleifend in lacus faucibus, viverra ipsum pulvinar, molestie arcu. Etiam lacinia venenatis dignissim. Suspendisse non nisl semper tellus malesuada suscipit eu et eros. Nulla eu enim quis quam elementum vulputate. Mauris ornare consequat nunc viverra pellentesque. Aenean semper eu massa sit amet aliquam. Integer et neque sed libero mollis elementum at vitae ligula. Vestibulum pharetra sed libero sed porttitor. Suspendisse a faucibus lectus.',
                    style: TextStyle(
                        fontSize: 16.0, height: 1.5, color: textColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Duis ut mauris sollicitudin, venenatis nisi sed, luctus ligula. Phasellus blandit nisl ut lorem semper pharetra. Nullam tortor nibh, suscipit in consequat vel, feugiat sed quam. Nam risus libero, auctor vel tristique ac, at vulputate eros sapien nec libero. Mauris dapibus laoreet nibh quis bibendum. Fusce dolor sem, suscipit in iaculis id, pharetra at urna. Pellentesque tempor congue massa quis faucibus.',
                    style: TextStyle(
                        fontSize: 16.0, height: 1.5, color: textColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse faucibus mauris leo, eu bibendum neque congue non. Ut leo mauris, eleifend in lacus faucibus, viverra ipsum pulvinar, molestie arcu. Etiam lacinia venenatis dignissim.',
                    style: TextStyle(
                        fontSize: 16.0, height: 1.5, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
