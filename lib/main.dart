import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- IMPORT SERVICE ---
// Pastikan path ini sesuai dengan lokasi file chat_service.dart Anda
import 'services/chat_service.dart'; 

// --- IMPORTS UTAMA (AUTH & DASHBOARD) ---
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/role_selection_screen.dart';
import 'settings/setting_page.dart';
import 'features/chat/screens/chat_list_screen.dart';
import 'features/notification/screens/notification_screen.dart';
import 'features/profile/screens/profile_page.dart';

// --- IMPORTS FITUR RESUME ---
import 'features/resume/screens/awards_screen.dart';
import 'features/resume/screens/certifications_screen.dart';
import 'features/resume/screens/create_resume_form_screen.dart';
import 'features/resume/screens/education_screen.dart';
import 'features/resume/screens/employment_history_screen.dart';
import 'features/resume/screens/interests_screen.dart';
import 'features/resume/screens/language_screen.dart';
import 'features/resume/screens/links_screen.dart';
import 'features/resume/screens/personal_statement_screen.dart';
import 'features/resume/screens/references_screen.dart';
import 'features/resume/screens/resume_builder_screen.dart';
import 'features/resume/screens/resume_screen.dart';
import 'features/resume/screens/skills_screen.dart';
import 'features/resume/screens/upload_resume_form_screen.dart';
import 'features/resume/screens/volunteering_screen.dart';

// --- IMPORTS FITUR FIND JOB ---
import 'features/find_job/screens/find_job_screen.dart';
import 'features/find_job/screens/company_list_screen.dart';

// --- IMPORTS FITUR RECENT JOB ---
import 'features/recent_job/screens/recent_job_page.dart';

// --- IMPORTS ELEMENTS (UI COMPONENTS) ---
import 'features/elements/popover_page.dart';
import 'features/elements/element_page.dart'; 
import 'features/elements/skeleton_layout_page.dart';
import 'features/elements/swipeout_page.dart';
import 'features/elements/swiper_slider_page.dart';
import 'features/elements/popup_page.dart';
import 'features/elements/preloader_page.dart';
import 'features/elements/progress_bar_page.dart';
import 'features/elements/range_slider_page.dart';
import 'features/elements/searchbar_page.dart';
import 'features/elements/searchbar_expandable_page.dart';
import 'features/elements/sheet_modal_page.dart';
import 'features/elements/smart_select_page.dart';
import 'features/elements/stepper_page.dart';
import 'features/elements/subnavbar_page.dart';
import 'features/elements/calendar_page.dart';
import 'features/elements/photo_browser_page.dart';
import 'features/elements/color_picker_page.dart';
import 'features/elements/picker_page.dart';
import 'features/elements/toolbar_tabbar_page.dart';
import 'features/elements/autocomplete_page.dart';
import 'features/elements/panel_page.dart'; 

// --- PROVIDER ---
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- INISIALISASI SUPABASE ---
  await Supabase.initialize(
    url: 'https://pqbwiqkhywnauczsxtcz.supabase.co',
    anonKey: 'sb_publishable_e8OlmrmQj7aZSHYuEotyyQ_H5PK_J2R',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      // 1. UPDATE: Bungkus MyApp dengan LifecycleManager
      child: const LifecycleManager(
        child: MyApp(),
      ),
    ),
  );
}

// ==========================================
// 2. CLASS LIFECYCLE MANAGER (BARU)
// ==========================================
class LifecycleManager extends StatefulWidget {
  final Widget child;
  const LifecycleManager({super.key, required this.child});

  @override
  _LifecycleManagerState createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Set status Online saat aplikasi pertama kali dijalankan
    ChatService.updateUserStatus(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      // User membuka kembali aplikasi -> ONLINE
      ChatService.updateUserStatus(true);
      print("App Resumed: User Online");
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // User keluar/minimize aplikasi -> OFFLINE
      ChatService.updateUserStatus(false);
      print("App Paused/Detached: User Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// ==========================================
// CLASS MY APP
// ==========================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Fungsi untuk mengatur overlay sistem (Status Bar)
  void _setSystemOverlays(BuildContext context, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final Color navBarColor =
        isDark ? const Color(0xFF1E003A) : const Color(0xFFF7F5FC);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: navBarColor,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final Brightness currentBrightness =
            themeProvider.themeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light;

        _setSystemOverlays(context, currentBrightness);

        return MaterialApp(
          title: 'Gawee Job Portal',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          
          // --- KONFIGURASI TEMA ---
          theme: _buildThemeData(
            themeProvider.primaryColor,
            themeProvider.scaffoldColorLight,
            themeProvider.cardColor,
            Brightness.light,
          ),
          darkTheme: _buildThemeData(
            themeProvider.primaryColor,
            themeProvider.scaffoldColorDark,
            themeProvider.cardColor,
            Brightness.dark,
          ),

          home: const OnboardingScreen(),

          // --- DAFTAR SEMUA RUTE (ROUTES) ---
          routes: {
            // AUTH & CORE
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/dashboard': (context) => const DashboardPage(),
            '/reset_password': (context) => const ResetPasswordScreen(),
            '/role_selection': (context) => const RoleSelectionScreen(),
            '/settings': (context) => const SettingPage(),
            '/chat_list': (context) => const ChatListScreen(),
            '/notifications': (context) => const NotificationScreen(),
            '/profile': (context) => const ProfilePage(),

            // FITUR RESUME
            '/resume': (context) => const ResumeScreen(),
            '/resume_builder': (context) => const ResumeBuilderScreen(),
            '/resume_awards': (context) => const AwardsScreen(),
            '/resume_certifications': (context) => const CertificationsScreen(),
            '/resume_create_form': (context) => const CreateResumeFormScreen(),
            '/resume_education': (context) => const EducationScreen(),
            '/resume_employment': (context) => const EmploymentHistoryScreen(),
            '/resume_interests': (context) => const InterestsScreen(),
            '/resume_language': (context) => const LanguageScreen(),
            '/resume_links': (context) => const LinksScreen(),
            '/resume_personal_statement': (context) =>
                const PersonalStatementScreen(),
            '/resume_references': (context) => const ReferencesScreen(),
            '/resume_skills': (context) => const SkillsScreen(),
            '/resume_upload': (context) => const UploadResumeFormScreen(),
            '/resume_volunteering': (context) => const VolunteeringScreen(),

            // FITUR FIND JOB
            '/find_job': (context) => const FindJobScreen(),
            '/company_list': (context) => const CompanyListScreen(),

            // FITUR RECENT JOB
            '/recent_job': (context) => RecentJobScreen(),

            // FITUR ELEMENTS (UI COMPONENTS)
            '/panel_page': (context) => Framework7HomePage(),
            '/element_popover': (context) => const PopoverPage(),
            '/element_skeleton': (context) => const SkeletonLayoutPage(),
            '/element_swipeout': (context) => const SwipeoutPage(),
            '/element_swiper': (context) => const SwiperSliderPage(),
            '/element_popup': (context) => const PopupPage(),
            '/element_preloader': (context) => const PreloaderPage(),
            '/element_progressbar': (context) => const ProgressBarPage(),
            '/element_rangeslider': (context) => const RangeSliderPage(),
            '/element_searchbar': (context) => const SearchbarPage(),
            '/element_searchbar_expandable': (context) =>
                const SearchbarExpandablePage(),
            '/element_sheet_modal': (context) => const SheetModalPage(),
            '/element_smart_select': (context) => const SmartSelectPage(),
            '/element_stepper': (context) => const StepperPage(),
            '/element_subnavbar': (context) => const SubnavbarPage(),
            '/element_calendar': (context) => const CalendarPage(),
            '/element_photo_browser': (context) => const PhotoBrowserPage(),
            '/element_color_picker': (context) => const ColorPickerPage(),
            '/element_picker': (context) => const PickerPage(),
            '/element_toolbar_tabbar': (context) => const ToolbarTabbarPage(),
            '/element_autocomplete': (context) => const AutocompletePage(),
          },
        );
      },
    );
  }

  // --- BUILDER TEMA ---
  ThemeData _buildThemeData(
    Color primaryColor,
    Color scaffoldBackgroundColor,
    Color cardColor,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final ThemeData baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme);

    return baseTheme.copyWith(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      
      // Penyesuaian Text Theme
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(color: subtitleColor),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: titleColor),
        titleMedium: textTheme.titleMedium?.copyWith(color: subtitleColor),
        titleLarge: textTheme.titleLarge?.copyWith(color: titleColor),
        headlineSmall: textTheme.headlineSmall?.copyWith(color: titleColor),
        headlineMedium: textTheme.headlineMedium?.copyWith(color: titleColor),
        headlineLarge: textTheme.headlineLarge?.copyWith(color: titleColor),
        displaySmall: textTheme.displaySmall?.copyWith(color: titleColor),
        displayMedium: textTheme.displayMedium?.copyWith(color: titleColor),
        displayLarge: textTheme.displayLarge?.copyWith(color: titleColor),
      ),
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        background: scaffoldBackgroundColor,
      ),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: primaryColor,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        scrolledUnderElevation: 0,
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}