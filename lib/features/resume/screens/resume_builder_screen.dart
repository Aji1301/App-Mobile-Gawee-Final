import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/api_service.dart';
import '../../../widgets/custom_drawer.dart';

// Import screen sub-menu
import 'edit_resume_language_screen.dart'; 
import 'personal_statement_screen.dart'; 
import 'employment_history_screen.dart';
import 'education_screen.dart';
import 'skills_screen.dart';
import 'language_screen.dart';
import 'certifications_screen.dart';
import 'awards_screen.dart';
import 'links_screen.dart';
import 'volunteering_screen.dart';
import 'interests_screen.dart';
import 'references_screen.dart';

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  String _currentLanguage = "English"; 
  String _name = "Loading...";
  String _jobTitle = "";
  String _location = "";
  String _email = "";
  String? _avatarUrl;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResumeData();
  }

  void _loadResumeData() async {
    final data = await ApiService.getResumeData();
    final user = Supabase.instance.client.auth.currentUser; 

    if (mounted) {
      setState(() {
        if (data != null) {
          _currentLanguage = data['resume_language'] ?? "English";
          _name = data['full_name'] ?? data['username'] ?? "No Name";
          _jobTitle = data['job_title'] ?? "Job Title belum diisi";
          _location = data['location'] ?? "";
          _avatarUrl = data['avatar_url'];
          _email = user?.email ?? "No Email";
        }
        _isLoading = false;
      });
    }
  }

  void _editLanguage() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      builder: (BuildContext sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: EditResumeLanguageScreen(
            currentLanguage: _currentLanguage,
          ),
        );
      },
    );

    if (result != null && result is String) {
      setState(() {
        _currentLanguage = result;
      });
      await ApiService.updateResumeDetail('resume_language', result);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Language updated to $result"), duration: const Duration(seconds: 2)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // === AMBIL WARNA DARI TEMA ===
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor; // ✅ Gunakan warna kartu dari tema
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87; // ✅ Teks menyesuaikan tema
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    // Warna background ikon (transparan ungu)
    final Color iconBackground = primaryColor.withOpacity(0.1); 

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: SizedBox(width: 320, child: Drawer(child: CustomDrawerBody())),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: textColor), // Icon back menyesuaikan tema
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Resume",
          style: GoogleFonts.poppins(
            color: textColor, // Judul menyesuaikan tema
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.more_vert, color: textColor), // Titik 3 menyesuaikan tema
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create your resume",
              style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor,
              ),
            ),
            const SizedBox(height: 20),

            _buildProfileCard(cardColor, primaryColor, textColor, subTextColor),
            const SizedBox(height: 24),

            _buildLanguageSection(primaryColor, textColor, subTextColor),
            const SizedBox(height: 16),

            // TILES MENU
            _buildSectionTile(context, Icons.description_outlined, "Personal statement", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.work_outline, "Employment history", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.school_outlined, "Education", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.star_outline, "Skills", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.g_translate_outlined, "Language", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.article_outlined, "Certifications", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.military_tech_outlined, "Awards", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.link_outlined, "Links", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.volunteer_activism_outlined, "Volunteering", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.interests_outlined, "Interests", iconBackground, primaryColor, cardColor, textColor),
            _buildSectionTile(context, Icons.thumb_up_outlined, "References", iconBackground, primaryColor, cardColor, textColor),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildProfileCard(Color cardColor, Color primaryColor, Color textColor, Color subTextColor) {
    ImageProvider imageProvider;
    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      imageProvider = NetworkImage(_avatarUrl!);
    } else {
      imageProvider = const NetworkImage('https://cdn-icons-png.flaticon.com/512/847/847969.png');
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor, // ✅ Sekarang menggunakan warna tema (bukan hardcode putih)
        borderRadius: BorderRadius.circular(16.0),
        // Border tipis transparan agar terlihat bagus di dark mode
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Shadow halus
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: imageProvider,
                  onBackgroundImageError: (_, __) {},
                ),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: primaryColor, 
                    shape: BoxShape.circle, 
                    border: Border.all(color: cardColor, width: 2) // Border ikut warna kartu
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(_name, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(_jobTitle, style: GoogleFonts.poppins(color: subTextColor, fontSize: 14, fontWeight: FontWeight.w500)),
          
          if (_location.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 14, color: primaryColor.withOpacity(0.7)),
                const SizedBox(width: 4),
                Text(_location, style: GoogleFonts.poppins(color: subTextColor, fontSize: 13)),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Text(_email, style: GoogleFonts.poppins(color: subTextColor, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(Color primaryColor, Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Resume Language", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            IconButton(
              onPressed: _editLanguage,
              icon: Icon(Icons.edit_outlined, color: primaryColor, size: 20),
            )
          ],
        ),
        Text(_currentLanguage, style: GoogleFonts.poppins(color: subTextColor, fontSize: 14)),
      ],
    );
  }

  Widget _buildSectionTile(BuildContext context, IconData icon, String title, Color iconBackground, Color primaryColor, Color cardColor, Color textColor) {
    void showResumeFormSheet(Widget formContent, double maxHeightFactor) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * maxHeightFactor),
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: formContent,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: cardColor, // ✅ Latar belakang item list mengikuti tema
        elevation: 0, 
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          // Border menyesuaikan tema (lebih gelap di light mode, transparan di dark mode)
          side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        child: InkWell(
          onTap: () {
            if (title == "Personal statement") showResumeFormSheet(const PersonalStatementScreen(), 0.90);
            else if (title == "Employment history") showResumeFormSheet(const EmploymentHistoryScreen(), 0.95);
            else if (title == "Education") showResumeFormSheet(const EducationScreen(), 0.95);
            else if (title == "Skills") showResumeFormSheet(const SkillsScreen(), 0.65);
            else if (title == "Language") showResumeFormSheet(const LanguageScreen(), 0.65);
            else if (title == "Certifications") showResumeFormSheet(const CertificationsScreen(), 0.95);
            else if (title == "Awards") showResumeFormSheet(const AwardsScreen(), 0.85);
            else if (title == "Links") showResumeFormSheet(const LinksScreen(), 0.65);
            else if (title == "Volunteering") showResumeFormSheet(const VolunteeringScreen(), 0.95);
            else if (title == "Interests") showResumeFormSheet(const InterestsScreen(), 0.80);
            else if (title == "References") showResumeFormSheet(const ReferencesScreen(), 0.95);
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), 
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: iconBackground, 
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Icon(icon, color: primaryColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}