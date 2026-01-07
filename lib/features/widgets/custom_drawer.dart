import 'package:flutter/material.dart';
import 'package:gawe/screens/login_screen.dart';
import 'package:gawe/services/api_service.dart';
// import '../services/api_service.dart';
// Sesuaikan import layar login/register Anda jika perlu logout
// import '../features/auth/screens/login_screen.dart'; 

class CustomDrawerBody extends StatefulWidget {
  const CustomDrawerBody({super.key});

  @override
  State<CustomDrawerBody> createState() => _CustomDrawerBodyState();
}

class _CustomDrawerBodyState extends State<CustomDrawerBody> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final data = await ApiService.getProfile();
    if (mounted) {
      setState(() {
        _profileData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil URL Avatar dengan aman
    final String? avatarUrl = _profileData?['avatar_url'];
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    final String name = _profileData?['full_name'] ?? _profileData?['username'] ?? 'User';
    final String email = _profileData?['email'] ?? ''; // Jika Anda simpan email di profil

    return Column(
      children: [
        // --- HEADER DRAWER ---
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          accountName: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          accountEmail: Text(email),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            // 1. LOGIKA GAMBAR AMAN
            backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
            // 2. ERROR HANDLER HANYA JIKA ADA GAMBAR
            onBackgroundImageError: hasAvatar ? (_, __) {} : null,
            // 3. ICON PENGGANTI JIKA KOSONG
            child: !hasAvatar 
                ? Icon(Icons.person, size: 40, color: Theme.of(context).primaryColor) 
                : null,
          ),
        ),

        // --- MENU ITEMS ---
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                   Navigator.pop(context); // Tutup drawer
                   // Navigasi ke Home jika perlu
                },
              ),
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text("My Applications"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigasi ke halaman lamaran saya
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await ApiService.logout();
                  if (mounted) {
                    // Kembali ke Login Screen dan hapus semua history
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}