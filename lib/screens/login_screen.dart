import 'dart:async'; // ✅ WAJIB: Untuk menangani StreamSubscription
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // ✅ WAJIB: Untuk Auth Provider

import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  // ✅ TAMBAHAN: Parameter untuk menentukan tab awal (0 = Seeker, 1 = Company)
  final int initialIndex; 

  const LoginScreen({
    super.key,
    this.initialIndex = 0, // Default ke 0 (Job Seeker)
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ✅ VARIABLE BARU: Untuk memantau status login
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  // ✅ FUNGSI PENTING: Mendengarkan hasil login dari browser
  void _setupAuthListener() {
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        // Jika user berhasil login (termasuk balik dari Google)
        if (event == AuthChangeEvent.signedIn && session != null) {
          
          // 🔥 TAMBAHAN: Sinkronisasi data Google dulu sebelum pindah
          if (mounted) {
            // Tampilkan loading kecil jika perlu (opsional)
            // ...
            
            // Panggil fungsi sync yang baru kita buat
            await ApiService.syncSocialUserData(); 
            
            // Baru pindah ke Dashboard
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          }
        }
      });
    }

  @override
  void dispose() {
    // ✅ PENTING: Matikan pendengar saat keluar layar
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex, // ✅ UPDATE DI SINI: Gunakan parameter yang dikirim
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const SafeArea(
          child: Column(
            children: [
              _Header(),
              _TabSelector(),
              SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  children: [
                    _JobSeekerTab(),
                    _CompanyTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================================
// 1. LOGIC TAB: JOB SEEKER
// =======================================================================

class _JobSeekerTab extends StatefulWidget {
  const _JobSeekerTab();

  @override
  State<_JobSeekerTab> createState() => _JobSeekerTabState();
}

class _JobSeekerTabState extends State<_JobSeekerTab> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await ApiService.login(
      _emailController.text.trim(),
      _passwordController.text,
      'seeker',
    );

    setState(() => _isLoading = false);

    // Note: Navigasi manual di sini hanya untuk login email/password biasa.
    // Login Google ditangani oleh listener di atas.
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Failed. Check email & password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kTextTitle = Theme.of(context).textTheme.bodyLarge?.color;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign in to your registered account",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextTitle,
            ),
          ),
          const SizedBox(height: 24),
          _CustomTextField(
            hintText: "Email Address",
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          _CustomTextField(
            hintText: "Password",
            isPassword: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 24),
          _LoginButton(
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          const _ForgotPasswordText(),
          const SizedBox(height: 32),
          const _SocialLoginRow(),
          const SizedBox(height: 32),
          const _CreateAccountButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// =======================================================================
// 2. LOGIC TAB: COMPANY
// =======================================================================

class _CompanyTab extends StatefulWidget {
  const _CompanyTab();

  @override
  State<_CompanyTab> createState() => _CompanyTabState();
}

class _CompanyTabState extends State<_CompanyTab> {
  final _companyIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_companyIdController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await ApiService.login(
      _emailController.text.trim(),
      _passwordController.text,
      'company',
      companyId: _companyIdController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Failed. Check Company ID/Email/Pass.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _companyIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kTextTitle = Theme.of(context).textTheme.bodyLarge?.color;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Company account",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextTitle,
            ),
          ),
          const SizedBox(height: 24),
          _CustomTextField(
            hintText: "Company Id",
            controller: _companyIdController,
          ),
          const SizedBox(height: 16),
          _CustomTextField(
            hintText: "Email Address",
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          _CustomTextField(
            hintText: "Password",
            isPassword: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 24),
          _LoginButton(
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// =======================================================================
// WIDGET KOMPONEN
// =======================================================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 60,
            errorBuilder: (ctx, err, st) =>
                Icon(Icons.work, color: kPrimaryColor, size: 60),
          ),
          const SizedBox(height: 8),
          Text(
            "Gawee",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  const _TabSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kPrimaryColor = theme.primaryColor;
    final kInactiveTab = theme.brightness == Brightness.light
        ? Colors.grey.shade500
        : Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TabBar(
        indicatorColor: kPrimaryColor,
        indicatorWeight: 4.0,
        labelColor: kPrimaryColor,
        unselectedLabelColor: kInactiveTab,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle:
            GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
        tabs: const [
          Tab(text: "JOB SEEKER"),
          Tab(text: "COMPANY"),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  const _CustomTextField({
    required this.hintText,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final kInactiveText = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade500
        : Colors.grey.shade400;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.poppins(
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: kInactiveText),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _LoginButton({this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            onPressed: onPressed,
            child: Text(
              "LOGIN",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
  }
}

class _ForgotPasswordText extends StatelessWidget {
  const _ForgotPasswordText();

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    final kTextSubtitle =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ??
            Colors.grey;

    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: kTextSubtitle,
          ),
          children: [
            const TextSpan(text: "Forgot your password? "),
            TextSpan(
              text: "Reset here",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLoginRow extends StatelessWidget {
  const _SocialLoginRow();

  @override
  Widget build(BuildContext context) {
    final kTextSubtitle =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ??
            Colors.grey;

    return Column(
      children: [
        Text(
          "Or sign in with",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: kTextSubtitle,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- GOOGLE ---
            _SocialButton(
              imagePath: 'assets/images/google_logo.png',
              onTap: () async {
                await ApiService.signInWithOAuth(OAuthProvider.google);
              },
            ),
            const SizedBox(width: 20),
            
            // --- FACEBOOK ---
            _SocialButton(
              imagePath: 'assets/images/facebook_logo.png',
              onTap: () async {
                await ApiService.signInWithOAuth(OAuthProvider.facebook);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _SocialButton({
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Image.asset(
          imagePath,
          height: 30,
          width: 30,
          errorBuilder: (context, error, stackTrace) => 
            const Icon(Icons.error_outline, color: Colors.red),
        ),
      ),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        side: BorderSide(color: kPrimaryColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
      child: Text(
        "CREATE ACCOUNT",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}