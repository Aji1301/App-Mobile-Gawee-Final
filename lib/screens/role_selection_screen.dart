import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import '../utils/constants.dart'; // <-- IMPORT WARNA BARU

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kPageBackground = Theme.of(context).scaffoldBackgroundColor;
    const kTextTitle = Color(0xFF333333);
    const kTextSubtitle = Color(0xFF757575);
    // Warna biru sekunder dari desain Anda, tidak ada di konstanta
    const Color kSecondaryBlue = Color(0xFF4A90E2);

    return Scaffold(
      backgroundColor: kPageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset('assets/images/logo.png', height: 80),
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              Text(
                "Who are you?",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: kTextTitle,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Choose your account type to get started. Are you looking to hire talent or looking for a new job?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: kTextSubtitle,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              _RoleSelectionButton(
                title: "JOB SEEKERS",
                subtitle: "Finding a job here never been easier than before",
                color: primaryPurple, // <-- WARNA BARU
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(initialIndex: 0),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _RoleSelectionButton(
                title: "COMPANY",
                subtitle: "Let's recruit your great candidate faster here",
                color: kSecondaryBlue, // <-- Tetap biru, sesuai desain
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(initialIndex: 1),
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (Widget _RoleSelectionButton tetap sama)
class _RoleSelectionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onPressed;

  const _RoleSelectionButton({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              // Konten Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Ikon Panah
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
