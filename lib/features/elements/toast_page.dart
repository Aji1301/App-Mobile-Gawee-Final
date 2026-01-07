import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// ----------------------------------------------------
// 1. Toast Manager (Mengelola Overlay & Posisi)
// ----------------------------------------------------

enum ToastPosition { top, bottom, center }

class ToastManager {
  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext context, {
    required Widget content,
    required ToastPosition position,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onCloseCallback,
    List<Widget>? actions,
    Color? backgroundColor,
  }) {
    // Tutup toast sebelumnya jika ada
    dismiss();

    Alignment alignment;
    double? top, bottom;

    switch (position) {
      case ToastPosition.top:
        alignment = Alignment.topCenter;
        top = MediaQuery.of(context).padding.top + kToolbarHeight * 0.2;
        bottom = null;
        break;
      case ToastPosition.center:
        alignment = Alignment.center;
        top = null;
        bottom = null;
        break;
      case ToastPosition.bottom:
        alignment = Alignment.bottomCenter;
        bottom = MediaQuery.of(context).padding.bottom + 20;
        top = null;
        break;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        Widget toastWidget = Align(
          alignment: alignment,
          child: _CustomToast(
            content: content,
            actions: actions,
            backgroundColor: backgroundColor,
            onDismiss: () => dismiss(onCloseCallback: onCloseCallback),
          ),
        );

        if (position == ToastPosition.center) {
          return toastWidget;
        }

        return Positioned(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          child: toastWidget,
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    if (actions == null && onCloseCallback == null) {
      Future.delayed(duration, () => dismiss());
    }
  }

  static void dismiss({VoidCallback? onCloseCallback}) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      onCloseCallback?.call();
    }
  }
}

// ----------------------------------------------------
// 2. Custom Toast Widget (Tampilan UI)
// ----------------------------------------------------

class _CustomToast extends StatelessWidget {
  final Widget content;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final VoidCallback? onDismiss;

  const _CustomToast({
    required this.content,
    this.actions,
    this.backgroundColor,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    bool hasActions = actions != null && actions!.isNotEmpty;

    // Ambil tema untuk styling default jika backgroundColor null
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Default background color: Putih kebiruan (Light) atau Card Color (Dark)
    final defaultBg =
        isDark ? themeProvider.cardColor : const Color(0xFFF0F8FF);
    final actualBg = backgroundColor ?? defaultBg;

    // Default text style agar terlihat jelas di background gelap/terang
    final textColor = isDark ? Colors.white : Colors.black87;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      color: actualBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: IntrinsicWidth(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            hasActions ? 16 : 12,
            hasActions ? 8 : 12,
            hasActions ? 8 : 12,
            hasActions ? 8 : 12,
          ),
          child: DefaultTextStyle(
            // Pastikan teks dalam toast mengikuti warna kontras
            style: TextStyle(color: textColor),
            child: IconTheme(
              // Pastikan icon dalam toast mengikuti warna kontras
              data: IconThemeData(color: textColor),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: content),
                  if (hasActions) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 3. Toast Page (Halaman Utama)
// ----------------------------------------------------

class ToastPage extends StatelessWidget {
  const ToastPage({super.key});

  // Widget Pembantu: Tombol Dinamis
  Widget _buildDynamicButton(
      String title, VoidCallback onTap, Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Menggunakan warna dari Provider
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // Dialog yang muncul setelah callback (Dinamis)
  void _showCallbackDialog(BuildContext context, ThemeProvider themeProvider) {
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Warna Dialog
    final dialogBg =
        isDark ? themeProvider.cardColor : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = themeProvider.primaryColor;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: dialogBg,
          title: Text('Framework7', style: TextStyle(color: textColor)),
          content: Text('Toast closed', style: TextStyle(color: textColor)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Data Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight; // Pengganti lightPurpleBackground

    final appBarBgColor = isDark ? Colors.transparent : scaffoldBgColor;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final textColor = isDark ? Colors.white : Colors.black;

    // Warna Toast Background Dinamis (untuk parameter show)
    final toastBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF0F8FF);
    final centerToastBgColor = isDark ? themeProvider.cardColor : Colors.white;

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
              'Toast',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Toasts provide brief feedback about an operation through a message on the screen.',
                style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
              ),
            ),

            // 1. Toast on Bottom
            _buildDynamicButton(
              'Toast on Bottom',
              () => ToastManager.show(
                context,
                content: const Text('This is default bottom positioned toast'),
                position: ToastPosition.bottom,
                backgroundColor: toastBgColor,
              ),
              primaryColor,
            ),

            // 2. Toast on Top
            _buildDynamicButton(
              'Toast on Top',
              () => ToastManager.show(
                context,
                content: const Text('Top positioned toast'),
                position: ToastPosition.top,
                backgroundColor: toastBgColor,
              ),
              primaryColor,
            ),

            // 3. Toast on Center
            _buildDynamicButton(
              'Toast on Center',
              () => ToastManager.show(
                context,
                content: const Text('I\'m on center'),
                position: ToastPosition.center,
                backgroundColor: centerToastBgColor,
              ),
              primaryColor,
            ),

            // 4. Toast with icon
            _buildDynamicButton(
              'Toast with icon',
              () => ToastManager.show(
                context,
                content: Row(
                  // Row tidak const agar Icon bisa ambil tema
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star,
                        color: isDark ? Colors.white : Colors.black, size: 30),
                    const SizedBox(width: 8),
                    const Text('I\'m with icon'),
                  ],
                ),
                position: ToastPosition.center,
                backgroundColor: centerToastBgColor,
              ),
              primaryColor,
            ),

            // 5. Toast with large message
            _buildDynamicButton(
              'Toast with large message',
              () => ToastManager.show(
                context,
                content: const Text(
                  'This toast contains a lot of text. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nihil, quae, ab. Delectus amet optio facere autem sapiente quisquam beatae culpa dolore.',
                  style: TextStyle(fontSize: 14),
                ),
                duration: const Duration(seconds: 5),
                position: ToastPosition.bottom,
                backgroundColor: toastBgColor,
              ),
              primaryColor,
            ),

            // 6. Toast with close button
            _buildDynamicButton(
              'Toast with close button',
              () => ToastManager.show(
                context,
                content: const Text('Toast with additional close button'),
                position: ToastPosition.bottom,
                backgroundColor: toastBgColor,
                actions: [
                  TextButton(
                    onPressed: () => ToastManager.dismiss(),
                    child: Text(
                      'Ok',
                      style: TextStyle(
                          color:
                              primaryColor), // Warna teks tombol menyesuaikan tema
                    ),
                  ),
                ],
              ),
              primaryColor,
            ),

            // 7. Toast with custom button
            _buildDynamicButton(
              'Toast with custom button',
              () => ToastManager.show(
                context,
                content: const Text('Custom close button'),
                position: ToastPosition.bottom,
                backgroundColor: toastBgColor,
                actions: [
                  TextButton(
                    onPressed: () => ToastManager.dismiss(),
                    child: const Text(
                      'Close Me',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              primaryColor,
            ),

            // 8. Toast with callback on close
            _buildDynamicButton('Toast with callback on close', () {
              ToastManager.show(
                context,
                content: const Text('Callback on close'),
                position: ToastPosition.bottom,
                backgroundColor: toastBgColor,
                onCloseCallback: () =>
                    _showCallbackDialog(context, themeProvider),
                actions: [
                  TextButton(
                    onPressed: () => ToastManager.dismiss(
                      onCloseCallback: () =>
                          _showCallbackDialog(context, themeProvider),
                    ),
                    child: Text(
                      'Ok',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              );
            }, primaryColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
