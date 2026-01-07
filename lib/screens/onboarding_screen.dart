import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class OnboardingPageData {
  final String imagePath;
  final String title;
  final String subtitle;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      imagePath: 'assets/images/onboarding_1.png',
      title: "Let's get started",
      subtitle:
          "Find your dream job with ease. Explore thousands of opportunities tailored to your skills and career goals",
    ),
    OnboardingPageData(
      imagePath: 'assets/images/onboarding_2.png',
      title: "Recomended Jobs",
      subtitle:
          "Get personalized job recommendations based on your profile. Stop searching and start applying to the right roles",
    ),
    OnboardingPageData(
      imagePath: 'assets/images/onboarding_1.png',
      title: "Let's get started",
      subtitle:
          "Connect directly with top companies. Apply with a single tap and track your application status in real-time",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kPageBackground = theme.scaffoldBackgroundColor;
    final kPrimaryColor = theme.primaryColor;
    const kTextTitle = Color(0xFF333333);
    const kTextSubtitle = Color(0xFF757575);

    return Scaffold(
      backgroundColor: kPageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 60),
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
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return _OnboardingPageContent(
                    imagePath: page.imagePath,
                    title: page.title,
                    subtitle: page.subtitle,
                    kTextTitle: kTextTitle,
                    kTextSubtitle: kTextSubtitle,
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: pages.length,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: kPrimaryColor,
                dotColor: const Color(0xFFDCDCDC),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_currentPage == pages.length - 1) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const RoleSelectionScreen(),
                      ),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(
                  "GET STARTED",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color kTextTitle;
  final Color kTextSubtitle;

  const _OnboardingPageContent({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.kTextTitle,
    required this.kTextSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // --- PERBAIKAN DI SINI ---
          Container(
            // Membungkus Image dengan Container agar alignment lebih rapi
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain, // ✅ Agar gambar utuh (tidak terpotong)
              width: double.infinity, // Agar gambar terpusat horizontal
            ),
          ),
          // -------------------------
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kTextTitle,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: kTextSubtitle,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}