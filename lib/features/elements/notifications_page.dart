import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// ----------------------------------------------------
// 1. Notification Content Widget (Custom Toast/Overlay - Dinamis)
// ----------------------------------------------------

class NotificationContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;
  final bool showCloseButton;
  final bool closeOnClick;
  final VoidCallback? onClose;
  final VoidCallback? onNotificationTap;
  final bool isDark; // Tambahan untuk tema
  final Color primaryColor; // Tambahan untuk tema

  const NotificationContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
    this.showCloseButton = false,
    this.closeOnClick = false,
    this.onClose,
    this.onNotificationTap,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Warna Background Notifikasi
    // Light: Biru muda (E8F0FE)
    // Dark: Card Color (abu-abu gelap) atau warna surface
    final bgColor = isDark ? const Color(0xFF333333) : const Color(0xFFE8F0FE);
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white70 : Colors.black54;
    final iconColor = primaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.2), // Sedikit lebih gelap shadow-nya
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: closeOnClick ? onNotificationTap : null,
          borderRadius: BorderRadius.circular(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Ikon Notifikasi
              Padding(
                padding: const EdgeInsets.only(top: 2.0, right: 10.0),
                child: Icon(
                  Icons.phone_android,
                  color: iconColor,
                  size: 24,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Title dan Waktu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$title · now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: titleColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Subtitle
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: subColor,
                        ),
                      ),
                    // Message
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Close
              if (showCloseButton)
                GestureDetector(
                  onTap: onNotificationTap,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                    child: Icon(Icons.close, color: subColor, size: 20),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. Notification Manager Class (Overlay Logic)
// ----------------------------------------------------

class NotificationManager {
  static OverlayEntry? _overlayEntry;

  static void showNotification(
    BuildContext context,
    NotificationContent content, {
    Duration duration = const Duration(seconds: 4),
  }) {
    dismissNotification();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 0,
        right: 0,
        child: content,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    if (!content.closeOnClick && content.showCloseButton == false) {
      Future.delayed(duration, () {
        dismissNotification(onCloseCallback: content.onClose);
      });
    }
  }

  static void dismissNotification({VoidCallback? onCloseCallback}) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      onCloseCallback?.call();
    }
  }
}

// ----------------------------------------------------
// 3. Notifications Page (Halaman Utama - Dinamis)
// ----------------------------------------------------

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  // Widget Pembantu untuk Tombol (Dinamis)
  Widget _buildPurpleButton(
      String title, VoidCallback onTap, Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Mengikuti tema
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // --- Logika Notifikasi ---

  // 1. Full Layout Notification
  void _showFullLayoutNotification(
      BuildContext context, bool isDark, Color primaryColor) {
    NotificationManager.showNotification(
      context,
      NotificationContent(
        title: 'Framework7',
        subtitle: 'This is a subtitle',
        message: 'This is a simple notification message',
        isDark: isDark,
        primaryColor: primaryColor,
      ),
    );
  }

  // 2. With Close Button
  void _showWithCloseButtonNotification(
      BuildContext context, bool isDark, Color primaryColor) {
    NotificationManager.showNotification(
      context,
      NotificationContent(
        title: 'Framework7',
        subtitle: 'Notification with close button',
        message: 'Click (x) button to close me',
        showCloseButton: true,
        onNotificationTap: () => NotificationManager.dismissNotification(),
        isDark: isDark,
        primaryColor: primaryColor,
      ),
      duration: const Duration(hours: 1),
    );
  }

  // 3. Click to Close
  void _showClickToCloseNotification(
      BuildContext context, bool isDark, Color primaryColor) {
    NotificationManager.showNotification(
      context,
      NotificationContent(
        title: 'Framework7',
        subtitle: 'Notification with close on click',
        message: 'Click me to close',
        closeOnClick: true,
        onNotificationTap: () => NotificationManager.dismissNotification(),
        isDark: isDark,
        primaryColor: primaryColor,
      ),
      duration: const Duration(hours: 1),
    );
  }

  // 4. Callback on Close
  void _showCallbackOnCloseNotification(BuildContext context, bool isDark,
      Color primaryColor, Color cardColor, Color textColor) {
    void showDialogOnClose() {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: cardColor, // Background dialog mengikuti tema
            title: Text('Framework7', style: TextStyle(color: textColor)),
            content:
                Text('Notification closed', style: TextStyle(color: textColor)),
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

    NotificationManager.showNotification(
      context,
      NotificationContent(
        title: 'Framework7',
        subtitle: 'Notification with close on click',
        message: 'Click me to close',
        closeOnClick: true,
        onClose: showDialogOnClose,
        onNotificationTap: () => NotificationManager.dismissNotification(
          onCloseCallback: showDialogOnClose,
        ),
        isDark: isDark,
        primaryColor: primaryColor,
      ),
      duration: const Duration(seconds: 4),
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
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor, // Dinamis
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor, // Dinamis
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Notifications',
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
            // Teks Pengantar
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Framework7 comes with simple Notifications component that allows you to show some useful messages to user and request basic actions.',
                style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
              ),
            ),

            // Tombol 1
            _buildPurpleButton(
              'Full layout notification',
              () => _showFullLayoutNotification(context, isDark, primaryColor),
              primaryColor,
            ),

            // Tombol 2
            _buildPurpleButton(
              'With close button',
              () => _showWithCloseButtonNotification(
                  context, isDark, primaryColor),
              primaryColor,
            ),

            // Tombol 3
            _buildPurpleButton(
              'Click to close',
              () =>
                  _showClickToCloseNotification(context, isDark, primaryColor),
              primaryColor,
            ),

            // Tombol 4
            _buildPurpleButton(
              'Callback on close',
              () => _showCallbackOnCloseNotification(
                  context, isDark, primaryColor, cardColor, textColor),
              primaryColor,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
