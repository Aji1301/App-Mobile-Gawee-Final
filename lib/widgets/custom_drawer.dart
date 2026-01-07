import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPOR HALAMAN UTAMA ---
import '../screens/dashboard_screen.dart';
import '../features/recent_job/screens/recent_job_page.dart';
import '../features/find_job/screens/find_job_screen.dart';
import '../features/notification/screens/notification_screen.dart';
import '../features/profile/screens/profile_page.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../settings/setting_page.dart';
import '../screens/login_screen.dart';

// 🚀 IMPOR ELEMENT PAGE
import '../features/elements/element_page.dart';

// 🚀 IMPOR FITUR COMPANY
import '../features/company/screens/company_my_jobs_page.dart';
import '../features/application/screens/my_applications_page.dart';
// import '../features/company/screens/post_job_screen.dart'; // [PENTING] Pastikan import halaman buat job ada

// 🚀 IMPOR SERVICE
import '../services/api_service.dart';

// ======= DRAWER (STATEFUL WIDGET) =======
class CustomDrawerBody extends StatefulWidget {
  const CustomDrawerBody({super.key});

  @override
  State<CustomDrawerBody> createState() => _CustomDrawerBodyState();
}

class _CustomDrawerBodyState extends State<CustomDrawerBody> {
  String _userRole = 'seeker'; // Default role
  bool _isLoading = true;      

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  // Cek Role User saat Drawer dibuka
  void _checkUserRole() async {
    try {
      final profile = await ApiService.getProfile();
      
      print("🔍 Drawer Role Check: ${profile?['role']}");

      if (mounted) {
        setState(() {
          if (profile != null && profile['role'] != null) {
            _userRole = profile['role'].toString().toLowerCase().trim();
          }
          _isLoading = false; 
        });
      }
    } catch (e) {
      print("Error fetching role: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- FUNGSI NAVIGASI UMUM ---
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

  // 🚀 FUNGSI LOGOUT
  void _logout(BuildContext context) async {
    await ApiService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kPrimaryColor = theme.primaryColor;

    final textColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.8)
        : Colors.black.withOpacity(0.7);

    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      child: Material(
        color: theme.cardColor,
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
                            Icon(Icons.work, color: kPrimaryColor, size: 40)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gawee',
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!_isLoading)
                          Text(
                            _userRole.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: textColor.withOpacity(0.5),
                              fontSize: 10,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                // ==========================================

                const SizedBox(height: 26),

                // === DAFTAR MENU ===
                Expanded(
                  child: _isLoading 
                      ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
                      : ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            // 1. HOME (Semua Role)
                            GestureDetector(
                              onTap: () {
                                if (currentRoute != '/dashboard') {
                                  _pushReplacementPage(
                                      context, const DashboardPage());
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: _DrawerItem(
                                icon: Icons.home_rounded,
                                label: 'Home',
                                highlighted: currentRoute == '/dashboard',
                              ),
                            ),

                            // =================================
                            //      MENU KHUSUS COMPANY
                            // =================================
                            if (_userRole == 'company') ...[
                              
                              // [BARU] MENU: POST A JOB (Buat Pekerjaan)
                              // GestureDetector(
                              //   onTap: () {
                              //     // Ganti PostJobScreen() dengan nama halaman buat lowongan kamu
                              //     // _pushPage(context, const PostJobScreen()); 
                                  
                              //     // Sementara pakai SnackBar jika halaman belum ada
                              //     Navigator.pop(context);
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(content: Text("Fitur Post Job belum dibuat")),
                              //     );
                              //   },
                              //   child: _DrawerItem(
                              //     icon: Icons.add_circle_outline, // Icon Tambah
                              //     label: 'Post a Job',
                              //     highlighted: currentRoute == '/post_job',
                              //   ),
                              // ),

                              // Menu: Manage Jobs / Applicants
                              GestureDetector(
                                onTap: () {
                                  _pushPage(context, const CompanyMyJobsPage());
                                },
                                child: _DrawerItem(
                                  icon: Icons.work_history_outlined,
                                  label: 'My Jobs',
                                  highlighted: currentRoute == '/company_my_jobs',
                                ),
                              ),
                            ],

                            // =================================
                            //      MENU KHUSUS SEEKER
                            // =================================
                            if (_userRole == 'seeker') ...[
                              // Menu: Recent Job
                              GestureDetector(
                                onTap: () {
                                  if (currentRoute != '/recent_job') {
                                    _pushPage(context, RecentJobScreen());
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: _DrawerItem(
                                  icon: Icons.article_outlined,
                                  label: 'Recent Job',
                                  highlighted: currentRoute == '/recent_job',
                                ),
                              ),

                              // Menu: Find Job
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
                                ),
                              ),

                              // Menu: My Applications
                              GestureDetector(
                                onTap: () {
                                  if (currentRoute != '/my_applications') {
                                    _pushPage(context, const MyApplicationsPage());
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: _DrawerItem(
                                  icon: Icons.assignment_outlined,
                                  label: 'My Applications',
                                  highlighted: currentRoute == '/my_applications',
                                ),
                              ),
                            ],

                            // =================================
                            //        MENU UMUM (SHARED)
                            // =================================

                            // Notifications
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
                                label: 'Notifications',
                                highlighted: currentRoute == '/notifications',
                              ),
                            ),

                            // Profile
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                if (currentRoute != '/profile') {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ProfilePage()),
                                  );
                                  if (result == true) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardPage()),
                                    );
                                  }
                                }
                              },
                              child: _DrawerItem(
                                icon: Icons.person_outline,
                                label: 'Profile',
                                highlighted: currentRoute == '/profile',
                              ),
                            ),

                            // Message
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
                              ),
                            ),

                            // Elements
                            GestureDetector(
                              onTap: () {
                                if (currentRoute != '/elements_page') {
                                  _pushPage(context, Framework7HomePage()); 
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: _DrawerItem(
                                icon: Icons.grid_view,
                                label: 'Elements',
                                highlighted: currentRoute == '/elements_page',
                              ),
                            ),

                            // Setting
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
                              ),
                            ),

                            // Logout
                            GestureDetector(
                              onTap: () => _logout(context),
                              child: const _DrawerItem(
                                  icon: Icons.logout, label: 'Logout'),
                            ),
                          ],
                        ),
                ),

                // === FOOTER ===
                Text(
                  'Gawee Job Portal',
                  style: GoogleFonts.poppins(
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'App Version 1.3',
                  style: GoogleFonts.poppins(
                    color: textColor.withOpacity(0.4),
                    fontSize: 12,
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

// Widget privat untuk setiap item di menu
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  const _DrawerItem({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kPrimaryColor = theme.primaryColor;

    final Color kLightPurple = theme.brightness == Brightness.dark
        ? kPrimaryColor.withOpacity(0.25)
        : kPrimaryColor.withOpacity(0.1);

    final Color textColor;
    if (highlighted) {
      textColor = kPrimaryColor;
    } else if (theme.brightness == Brightness.dark) {
      textColor = Colors.white.withOpacity(0.8);
    } else {
      textColor = Colors.black.withOpacity(0.7);
    }

    final finalColor = label == 'Logout' ? Colors.red.shade600 : textColor;

    return InkWell(
      onTap: null, 
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: highlighted ? kLightPurple : Colors.transparent,
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
                  fontWeight:
                      highlighted ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}