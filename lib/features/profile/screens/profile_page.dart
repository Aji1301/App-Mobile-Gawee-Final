// HAPUS import 'dart:io'; agar aman di Web
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker
import 'package:file_picker/file_picker.dart';   // 🚀 Import File Picker (Resume)
import 'package:url_launcher/url_launcher.dart'; // 🚀 Import URL Launcher (Buka PDF)

import '../../../services/api_service.dart'; // Import API Service
import '../../../widgets/custom_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // State Data User
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _mySkills = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchSkills();
  }

  // 1. Ambil Data Profil dari Supabase
  void _fetchProfile() async {
    final data = await ApiService.getProfile();
    if (mounted) {
      setState(() {
        _userProfile = data;
      });
    }
  }

  // 1.B Ambil Data Skills dari Supabase
  void _fetchSkills() async {
    final skills = await ApiService.getUserSkills();
    if (mounted) {
      setState(() {
        _mySkills = skills;
      });
    }
  }

  // 2. Fungsi Ganti Foto
  void _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _isLoading = true);

      bool success = await ApiService.updateAvatar(image);

      if (success) {
        await Future.delayed(const Duration(seconds: 1));
        _fetchProfile();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto profil berhasil diperbarui!")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal upload foto.")),
          );
        }
      }
      setState(() => _isLoading = false);
    }
  }

  // 3. FUNGSI UPLOAD RESUME (PDF)
  void _pickAndUploadResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() => _isLoading = true);
      
      PlatformFile file = result.files.first;

      bool success = await ApiService.uploadResume(file);

      if (success) {
        await Future.delayed(const Duration(seconds: 1));
        _fetchProfile();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Resume berhasil diupload!")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal upload resume.")),
          );
        }
      }
      setState(() => _isLoading = false);
    }
  }

  // 4. FUNGSI BUKA RESUME (VIEW)
  void _viewResume() async {
    final String? url = _userProfile?['resume_url'];
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tidak dapat membuka file.")),
          );
        }
      }
    }
  }

  // 5. FUNGSI TAMBAH SKILL (DIALOG)
  void _showAddSkillDialog() {
    String skillNameInput = '';
    double skillLevelInput = 0.5;

    // Ambil warna tema untuk Dialog
    final theme = Theme.of(context);
    final dialogBgColor = theme.cardColor;
    final dialogTextColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: dialogBgColor, // ✅ Tema Background Dialog
              title: Text("Add New Skill", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: dialogTextColor)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    // ✅ Style Text Input mengikuti tema
                    style: GoogleFonts.poppins(color: dialogTextColor),
                    decoration: InputDecoration(
                      labelText: "Skill Name (e.g. Flutter)",
                      labelStyle: GoogleFonts.poppins(color: dialogTextColor.withOpacity(0.6)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: dialogTextColor.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.primaryColor),
                      ),
                    ),
                    onChanged: (val) => skillNameInput = val,
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Proficiency:", style: GoogleFonts.poppins(color: dialogTextColor)),
                      Text("${(skillLevelInput * 100).toInt()}%", 
                           style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                    ],
                  ),
                  
                  Slider(
                    value: skillLevelInput,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    activeColor: theme.primaryColor,
                    inactiveColor: dialogTextColor.withOpacity(0.1),
                    onChanged: (val) {
                      setDialogState(() => skillLevelInput = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (skillNameInput.isNotEmpty) {
                      await ApiService.addUserSkill(skillNameInput, skillLevelInput);
                      _fetchSkills();
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Skill added successfully!")),
                        );
                      }
                    }
                  },
                  child: Text("Add", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // === SETUP VARIABEL TEMA ===
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark; // ✅ Cek Mode Gelap
    final Color primaryColor = theme.primaryColor;
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final Color subTextColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;
    final Color cardColor = theme.cardColor;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Data user
    final String userName = _userProfile?['name'] ?? 'Loading...';
    final String jobTitle = _userProfile?['job_title'] ?? 'User';
    final String? avatarUrl = _userProfile?['avatar'];
    
    // Resume Check
    final String? resumeUrl = _userProfile?['resume_url'];
    final bool hasResume = resumeUrl != null && resumeUrl.isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, true);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        drawer: const SizedBox(
          width: 320,
          child: Drawer(child: CustomDrawerBody()),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.1),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(
                    color: isDark ? Colors.grey.shade800 : const Color(0xFFDDDDDD),
                    width: 1.3),
              ),
            ),
            padding: EdgeInsets.only(
              top: screenHeight * 0.02,
              bottom: screenHeight * 0.005,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.1), blurRadius: 3, offset: const Offset(0, 1)),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor, size: 28),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ),
                    Text(
                      "Profile",
                      style: GoogleFonts.poppins(color: textColor, fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: textColor, size: 28),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // === FOTO PROFIL ===
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        width: screenWidth * 0.43,
                        height: screenWidth * 0.43,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : (avatarUrl != null && avatarUrl.isNotEmpty)
                                ? Image.network(
                                    avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: isDark ? Colors.grey[800] : Colors.grey[300], // ✅ Adaptif
                                      child: Icon(Icons.person, size: screenWidth * 0.2, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    color: isDark ? Colors.grey[800] : Colors.grey[300], // ✅ Adaptif
                                    child: Icon(Icons.person, size: screenWidth * 0.2, color: Colors.grey),
                                  ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.018),

              Text(
                userName,
                style: GoogleFonts.poppins(fontSize: 27, fontWeight: FontWeight.w800, color: textColor),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 3),

              Text(
                jobTitle,
                style: GoogleFonts.poppins(fontSize: 22, color: subTextColor, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: screenHeight * 0.018),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: textColor.withOpacity(0.9),
                    height: 1.35,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // === BAGIAN RESUME (UPDATE TEMA) ===
              GestureDetector(
                onTap: hasResume ? _viewResume : _pickAndUploadResume,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    // ✅ Jika belum ada resume, gunakan Card Color (bukan putih/abu terang)
                    color: hasResume ? primaryColor : (isDark ? cardColor : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(14),
                    // ✅ Border menyesuaikan tema
                    border: hasResume ? null : Border.all(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade400, 
                      width: 1, 
                      style: BorderStyle.solid
                    ),
                    boxShadow: hasResume 
                      ? [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 3))]
                      : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasResume ? 'My Resume' : 'Upload Resume',
                            style: GoogleFonts.poppins(
                              color: hasResume ? Colors.white : textColor, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 19
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            hasResume ? 'Tap to view document' : 'PDF, DOC, or DOCX',
                            style: GoogleFonts.poppins(
                              color: hasResume ? Colors.white70 : subTextColor, 
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            hasResume ? Icons.visibility : Icons.cloud_upload_outlined, 
                            color: hasResume ? Colors.white : primaryColor, 
                            size: 28
                          ),
                          if (hasResume) ...[
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: _pickAndUploadResume,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 18),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.045),

              // === BAGIAN SKILLS ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skills',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: textColor),
                  ),
                  InkWell(
                    onTap: _showAddSkillDialog,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 2),
                        shape: BoxShape.circle
                      ),
                      child: Icon(Icons.add, color: primaryColor, size: 20),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              if (_mySkills.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: Text(
                    "No skills added yet. Tap + to add.",
                    style: GoogleFonts.poppins(color: subTextColor, fontStyle: FontStyle.italic),
                  ),
                )
              else
                Column(
                  children: _mySkills.map((skill) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: _buildSkill(
                        skill['skill_name'] ?? 'Unknown',
                        (skill['level'] ?? 0).toDouble(),
                        primaryColor,
                        textColor,
                        subTextColor,
                      ),
                    );
                  }).toList(),
                ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSkill(String skill, double progress, Color color, Color textColor, Color subTextColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill,
              style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w600, color: textColor),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: GoogleFonts.poppins(fontSize: 16, color: subTextColor),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: subTextColor.withOpacity(0.2),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}