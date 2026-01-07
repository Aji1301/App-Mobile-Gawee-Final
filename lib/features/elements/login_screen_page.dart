import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// --- 1. Login Screen Layout (Gambar 1) ---
class LoginScreenLayout extends StatefulWidget {
  final bool isModal; // Flag untuk menentukan apakah ini modal atau halaman

  const LoginScreenLayout({super.key, this.isModal = false});

  @override
  State<LoginScreenLayout> createState() => _LoginScreenLayoutState();
}

class _LoginScreenLayoutState extends State<LoginScreenLayout> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk menampilkan dialog hasil input (Dinamis)
  void _showResultDialog(BuildContext context) {
    // Ambil tema
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // Warna Dialog
    final dialogBg = isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final textColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: dialogBg, // Mengikuti tema
          title: Text(
            'Framework7',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor, // Mengikuti tema
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: ${_usernameController.text}',
                  style: TextStyle(color: textColor)),
              const SizedBox(height: 4),
              Text('Password: ${_passwordController.text}',
                  style: TextStyle(color: textColor)),
            ],
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog

                // Kembali ke halaman opsi
                if (widget.isModal) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                }

                // Reset kolom input
                _usernameController.clear();
                _passwordController.clear();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: primaryColor, // Mengikuti tema
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget untuk Input Field (Dinamis)
  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String hint,
    Color fillColor,
    Color borderColor,
    Color textColor,
    Color hintColor, {
    bool isPassword = false,
  }) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: fillColor, // Mengikuti tema
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: borderColor, width: 1.0), // Mengikuti tema
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(fontSize: 16, color: textColor), // Mengikuti tema
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: hintColor, // Mengikuti tema
          ),
          hintStyle: TextStyle(color: hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 12.0),
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

    // Background Scaffold (Transparan jika modal, warna tema jika halaman)
    final scaffoldBgColor = widget.isModal
        ? Colors.transparent
        : (isDark ? themeProvider.scaffoldColorDark : Colors.white);

    // Warna Input Field
    final inputFillColor =
        isDark ? Colors.grey.shade800 : const Color(0xFFF7F7F7);
    final inputBorderColor =
        isDark ? Colors.grey.shade600 : const Color(0xFFDCDCDC);

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : const Color(0xFF6B6B6B);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Judul "Framework7"
              Text(
                'Framework7',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: textColor, // Mengikuti tema
                ),
              ),
              const SizedBox(height: 60),

              // Input Username
              _buildInputField(
                _usernameController,
                'Username',
                'Your username',
                inputFillColor,
                inputBorderColor,
                textColor,
                hintColor,
              ),

              // Input Password
              _buildInputField(
                _passwordController,
                'Password',
                'Your password',
                inputFillColor,
                inputBorderColor,
                textColor,
                hintColor,
                isPassword: true,
              ),

              const SizedBox(height: 20),

              // Tombol Sign In
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _showResultDialog(context),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: primaryColor, // Mengikuti tema
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Teks Informasi
              Text(
                'Some text about login information.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: hintColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: hintColor),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. Halaman Opsi Login (Gambar 2) ---
class LoginOptionsPage extends StatelessWidget {
  const LoginOptionsPage({super.key});

  // Fungsi untuk menampilkan Login Screen sebagai overlay (modal/popup)
  void _showOverlayLogin(BuildContext context, bool isDark, Color cardColor) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      barrierLabel: 'Login Overlay',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 40.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: cardColor, // Background dialog mengikuti tema
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              child: const LoginScreenLayout(isModal: true),
            ),
          ),
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
    final cardColor = isDark
        ? themeProvider.cardColor
        : const Color(0xFFF7F2FF); // Light purple di light mode

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final iconColor = isDark ? Colors.white54 : Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color:
                appBarBgColor, // Latar belakang AppBar mengikuti tema (light purple/card color)
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
              'Login Screen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Teks Pengantar
            Text(
              'Framework7 comes with ready to use Login Screen layout. It could be used inside of page or inside of popup (Embedded) or as a standalone overlay:',
              style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
            ),
            const SizedBox(height: 30),

            // Tombol "As Separate Page"
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreenLayout(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color:
                      cardColor, // Mengikuti tema (light purple / card color)
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: dividerColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'As Separate Page',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    Icon(Icons.chevron_right, color: iconColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol "AS OVERLAY"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    _showOverlayLogin(context, isDark, themeProvider.cardColor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Mengikuti tema
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'AS OVERLAY',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
