import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// ---------------------------------------------------------------------------
// ⬇️ IMPORT HALAMAN FITUR
// ---------------------------------------------------------------------------
import '../../features/recent_job/screens/recent_job_page.dart';
import '../../features/find_job/screens/find_job_screen.dart';
import '../../features/notification/screens/notification_screen.dart';
import '../../features/profile/screens/profile_page.dart';
import '../../features/chat/screens/chat_list_screen.dart';
import '../../settings/setting_page.dart';
import '../../screens/login_screen.dart';
import '../../screens/dashboard_screen.dart';

// 🚀 IMPORT ELEMENT PAGE
import 'element_page.dart';

// =============================================================================
// 1. PANEL PAGE (Halaman Utama)
// =============================================================================
class PanelPage extends StatelessWidget {
  const PanelPage({super.key});

  // Widget Pembantu untuk Tombol Ungu (Dinamis)
  Widget _buildPurpleButton(
    BuildContext context,
    String title,
    VoidCallback onTap,
    Color primaryColor, {
    double? width,
  }) {
    return SizedBox(
      height: 50,
      width: width,
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

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & Drawer
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final drawerBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // AppBar Background (Light Purple di Light Mode, Card Color di Dark Mode)
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- LEFT PANEL (Drawer Utama) ---
      drawer: Drawer(
        backgroundColor: drawerBgColor, // Dinamis
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const CustomDrawerBody(),
      ),

      // --- RIGHT PANEL (End Drawer) ---
      endDrawer: Drawer(
        backgroundColor: drawerBgColor, // Dinamis
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const CustomDrawerBody(),
      ),

      // --- AppBar ---
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
              'Panel / Side panels',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      // --- Body Halaman ---
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Framework7 comes with 2 panels (on left and on right), both are optional. You can put absolutely anything inside: data lists, forms, custom content, and even other isolated app view (like in right panel now) with its own dynamic navbar.',
                    style:
                        TextStyle(fontSize: 16, height: 1.4, color: textColor),
                  ),
                ),

                // Baris Tombol Kiri & Kanan
                Row(
                  children: [
                    Expanded(
                      child: _buildPurpleButton(
                        context,
                        'Open left panel',
                        () => Scaffold.of(context).openDrawer(),
                        primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPurpleButton(
                        context,
                        'Open right panel',
                        () => Scaffold.of(context).openEndDrawer(),
                        primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tombol Nested Panel (Full Width)
                SizedBox(
                  width: double.infinity,
                  child: _buildPurpleButton(
                    context,
                    'Open nested panel',
                    () {
                      // Tutup panel lain jika sedang terbuka
                      if (Scaffold.of(context).isDrawerOpen ||
                          Scaffold.of(context).isEndDrawerOpen) {
                        Navigator.pop(context);
                      }
                      _showNestedPanel(context);
                    },
                    primaryColor,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Logika Menampilkan Nested Panel ---
  void _showNestedPanel(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
          return Container(
            color: Colors.black.withOpacity(0.4),
            child: const _NestedPanelLayout(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.easeOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        },
      ),
    );
  }
}

// =============================================================================
// 2. CUSTOM DRAWER BODY (Dinamis dengan ThemeProvider)
// =============================================================================
class CustomDrawerBody extends StatelessWidget {
  const CustomDrawerBody({super.key});

  // --- FUNGSI NAVIGASI ---
  void _pushPage(BuildContext context, Widget page) {
    Navigator.pop(context); // Tutup drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _pushReplacementPage(BuildContext context, Widget page) {
    Navigator.pop(context); // Tutup drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // FUNGSI LOGOUT
  void _logout(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Warna Dinamis
    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor =
        isDark ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.8);
    final subTextColor =
        isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6);
    final closeBtnColor = isDark ? Colors.grey.shade700 : Colors.black87;

    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Material(
      color: cardColor, // Mengikuti tema
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 18, 18),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === HEADER ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png',
                      height: 40,
                      errorBuilder: (ctx, err, st) =>
                          Icon(Icons.work, color: primaryColor, size: 40)),
                  const SizedBox(width: 12),
                  Text(
                    'Gawee',
                    style: GoogleFonts.poppins(
                      color: primaryColor, // Mengikuti tema
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: closeBtnColor, // Dinamis
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // === DAFTAR MENU ===
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // 1. HOME
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/dashboard') {
                          _pushReplacementPage(context, const DashboardPage());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        highlighted: currentRoute == '/dashboard',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 2. RECENT JOB
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/recent_job') {
                          _pushPage(context, const RecentJobScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.article_outlined,
                        label: 'Recent Job',
                        highlighted: currentRoute == '/recent_job',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 3. FIND JOB
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/find_job') {
                          _pushPage(context, const FindJobScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.desktop_windows,
                        label: 'Find Job',
                        highlighted: currentRoute == '/find_job',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 4. NOTIFICATIONS
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/notifications') {
                          _pushPage(context, const NotificationScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.notifications_none_outlined,
                        label: 'Notifications (2)',
                        highlighted: currentRoute == '/notifications',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 5. PROFILE
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/profile') {
                          _pushPage(context, const ProfilePage());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        highlighted: currentRoute == '/profile',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 6. MESSAGE
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/chat_list') {
                          _pushPage(context, const ChatListScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.mail_outline,
                        label: 'Message',
                        highlighted: currentRoute == '/chat_list',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 7. ELEMENTS
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/element_page') {
                          _pushPage(context, const Framework7HomePage());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.grid_view,
                        label: 'Elements',
                        highlighted: currentRoute == '/element_page',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 8. SETTING
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/settings') {
                          _pushPage(context, const SettingPage());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.settings_outlined,
                        label: 'Setting',
                        highlighted: currentRoute == '/settings',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 9. LOGOUT
                    GestureDetector(
                      onTap: () => _logout(context),
                      child: _DrawerItem(
                        icon: Icons.logout,
                        label: 'Logout',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),
              ),

              // === FOOTER ===
              Text(
                'Gawee Job Portal',
                style: GoogleFonts.poppins(
                  color: subTextColor, // Dinamis
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'App Version 1.3',
                style: GoogleFonts.poppins(
                  color: subTextColor.withOpacity(0.4), // Dinamis
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Item Menu Drawer (Dinamis)
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  final Color primaryColor;
  final Color textColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.highlighted = false,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Logic warna
    final Color highlightBg = primaryColor.withOpacity(0.1);
    final Color itemColor = highlighted ? primaryColor : textColor;
    final Color finalColor =
        label == 'Logout' ? Colors.red.shade600 : itemColor;

    return InkWell(
      onTap: null, // onTap ditangani oleh GestureDetector parent
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: highlighted ? highlightBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: finalColor, size: 24),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: finalColor,
                  fontSize: 15,
                  fontWeight: highlighted ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 3. Nested Panel Layout (Tampilan saat 'Open nested panel' diklik)
// =============================================================================
class _NestedPanelLayout extends StatelessWidget {
  const _NestedPanelLayout();

  @override
  Widget build(BuildContext context) {
    final double panelWidth = MediaQuery.of(context).size.width * 0.75;

    // Ambil tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final scaffoldBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final primaryColor = themeProvider.primaryColor;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: panelWidth,
        height: double.infinity,
        color: scaffoldBgColor, // Dinamis
        child: Scaffold(
          backgroundColor: scaffoldBgColor, // Dinamis
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: appBarBgColor, // Dinamis
                border: Border(
                  bottom: BorderSide(color: dividerColor, width: 1.0),
                ),
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
                  'Panel / Side panels',
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
              children: [
                Text(
                  'This is page-nested Panel.',
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Close me',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor, // Dinamis
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
