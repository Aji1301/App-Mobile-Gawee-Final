import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/api_service.dart';

class ResumePreviewScreen extends StatefulWidget {
  final String? applicantId;

  const ResumePreviewScreen({
    super.key, 
    this.applicantId,
  });

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  Map<String, dynamic>? _resumeData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    final data = await ApiService.getResumeData(userId: widget.applicantId);
    if (mounted) {
      setState(() {
        _resumeData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchResumeUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch resume file.")),
        );
      }
    }
  }

  // Helper untuk cek apakah data kosong/valid
  bool _hasData(dynamic content) {
    if (content == null) return false;
    if (content is String && content.trim().isEmpty) return false;
    if (content is List && content.isEmpty) return false;
    if (content.toString() == "[]") return false; // Cek string array kosong
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // === SETUP VARIABEL TEMA ===
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;
    
    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (_resumeData == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: BackButton(color: textColor), 
          backgroundColor: backgroundColor, 
          elevation: 0
        ),
        body: Center(child: Text("Data resume tidak ditemukan.", style: GoogleFonts.poppins(color: textColor))),
      );
    }

    final String? resumeFileUrl = _resumeData!['resume_url'];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Resume Preview", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderProfile(primaryColor, textColor, isDark),
            const SizedBox(height: 24),

            // --- FILE UPLOAD SECTION ---
            if (_hasData(resumeFileUrl)) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // Adaptasi warna container biru untuk dark mode
                  color: isDark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.blue.shade800 : Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: isDark ? Colors.blue.shade200 : Colors.blue, size: 30),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Original Resume File", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.blue.shade100 : Colors.blue.shade900)),
                          Text("Tap to view/download", style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.blue.shade300 : Colors.blue.shade700)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.open_in_new, color: isDark ? Colors.blue.shade200 : Colors.blue),
                      onPressed: () => _launchResumeUrl(resumeFileUrl!),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildDivider(isDark),
            ],

            // --- DIGITAL DATA SECTIONS ---
            
            if (_hasData(_resumeData!['personal_statement'])) ...[
              _buildSimpleSection("Personal Statement", _resumeData!['personal_statement'], textColor, subTextColor),
              _buildDivider(isDark),
            ],
            
            if (_hasData(_resumeData!['employment_history'])) ...[
              _buildComplexSection("Experience", Icons.work_outline, _resumeData!['employment_history'], (d) => _buildExperienceItem(d, textColor, isDark), textColor),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['education_history'])) ...[
              _buildComplexSection("Education", Icons.school_outlined, _resumeData!['education_history'], (d) => _buildEducationItem(d, textColor, isDark), textColor),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['skills'])) ...[
              _buildSimpleSection("Skills", _resumeData!['skills'], textColor, subTextColor, icon: Icons.star_outline),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['languages'])) ...[
              _buildSimpleSection("Languages", _resumeData!['languages'], textColor, subTextColor, icon: Icons.g_translate_outlined),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['certifications'])) ...[
              _buildComplexSection("Certifications", Icons.article_outlined, _resumeData!['certifications'], (d) => _buildGenericItem(d, textColor, titleKey: 'title', subtitleKey: 'description'), textColor),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['awards'])) ...[
              _buildComplexSection("Awards", Icons.military_tech_outlined, _resumeData!['awards'], (d) => _buildGenericItem(d, textColor, titleKey: 'title', subtitleKey: 'description'), textColor),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['links'])) ...[
              _buildComplexSection("Links", Icons.link, _resumeData!['links'], (d) => _buildLinkItem(d, textColor), textColor),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['interests'])) ...[
              _buildSimpleSection("Interests", _resumeData!['interests'], textColor, subTextColor, icon: Icons.interests_outlined),
              _buildDivider(isDark),
            ],

            if (_hasData(_resumeData!['references'])) ...[
              _buildComplexSection("References", Icons.thumb_up_outlined, _resumeData!['references'], (d) => _buildReferenceItem(d, textColor, theme.cardColor, isDark), textColor),
            ],

            const SizedBox(height: 40),
            
            // Pesan jika kosong melompong
            if (!_hasData(resumeFileUrl) && 
                !_hasData(_resumeData!['personal_statement']) && 
                !_hasData(_resumeData!['employment_history']) &&
                !_hasData(_resumeData!['education_history']) &&
                !_hasData(_resumeData!['skills'])
                )
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.feed_outlined, size: 60, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text("No resume details provided yet.", style: GoogleFonts.poppins(color: subTextColor)),
                    ],
                  ),
                ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Looks Good!"))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Looks Good!", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildHeaderProfile(Color primaryColor, Color textColor, bool isDark) {
    String name = _resumeData!['full_name'] ?? _resumeData!['username'] ?? "No Name";
    String job = _resumeData!['job_title'] ?? "Job Title";
    String location = _resumeData!['location'] ?? "Location";
    String avatarUrl = _resumeData!['avatar_url'] ?? "https://cdn-icons-png.flaticon.com/512/847/847969.png";

    return Row(
      children: [
        CircleAvatar(
          radius: 35, 
          backgroundImage: NetworkImage(avatarUrl), 
          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
              Text(job, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: primaryColor)),
              const SizedBox(height: 4),
              Row(children: [Icon(Icons.location_on, size: 14, color: isDark ? Colors.grey.shade500 : Colors.grey.shade500), const SizedBox(width: 4), Text(location, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600))]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleSection(String title, dynamic content, Color textColor, Color subTextColor, {IconData? icon}) {
    // Format tampilan list jika content berupa array string (seperti interests [])
    String displayContent = content.toString();
    if (content is List) {
       if (content.isEmpty) return const SizedBox.shrink(); // Double check
       displayContent = content.join(", ");
    }
    // Bersihkan tanda kurung siku jika masih ada
    displayContent = displayContent.replaceAll('[', '').replaceAll(']', '');

    if (displayContent.trim().isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [if (icon != null) ...[Icon(icon, size: 18, color: textColor), const SizedBox(width: 8)], Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textColor))]),
        const SizedBox(height: 8),
        Text(displayContent, style: GoogleFonts.poppins(fontSize: 14, color: subTextColor, height: 1.5)),
      ],
    );
  }

  Widget _buildComplexSection(String title, IconData icon, dynamic jsonContent, Widget Function(Map<String, dynamic>) itemBuilder, Color textColor) {
    Map<String, dynamic>? dataMap;
    try {
      if (jsonContent is String) dataMap = jsonDecode(jsonContent);
      else dataMap = jsonContent;
    } catch (e) { return const SizedBox.shrink(); }

    if (dataMap == null || dataMap.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 18, color: textColor), const SizedBox(width: 8), Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textColor))]),
        const SizedBox(height: 12),
        itemBuilder(dataMap),
      ],
    );
  }

  // --- ITEM TEMPLATES (DENGAN COLOR PARAMETERS) ---
  
  Widget _buildExperienceItem(Map<String, dynamic> data, Color textColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(border: Border(left: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 2))),
      padding: const EdgeInsets.only(left: 12), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['job_title'] ?? "", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
          Text("${data['company']} • ${data['location']}", style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          Text("${data['start_month']} ${data['start_year']} - ${data['end_month']} ${data['end_year']}", style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.grey.shade500 : Colors.grey.shade500)),
          const SizedBox(height: 6),
          Text(data['description'] ?? "", style: GoogleFonts.poppins(fontSize: 13, color: textColor.withOpacity(0.9))),
      ]),
    );
  }

  Widget _buildEducationItem(Map<String, dynamic> data, Color textColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(border: Border(left: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 2))),
      padding: const EdgeInsets.only(left: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['school'] ?? "", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
          Text("${data['degree']} in ${data['major']}", style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          Text("${data['start_year']} - ${data['end_year']}", style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.grey.shade500 : Colors.grey.shade500)),
          if (data['description'] != null) ...[const SizedBox(height: 4), Text(data['description'], style: GoogleFonts.poppins(fontSize: 13, color: textColor.withOpacity(0.9)))]
      ]),
    );
  }

  Widget _buildGenericItem(Map<String, dynamic> data, Color textColor, {required String titleKey, required String subtitleKey}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(data[titleKey] ?? "", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
        if (data['start_year'] != null) Text("Issued: ${data['start_month']} ${data['start_year']}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 4), Text(data[subtitleKey] ?? "", style: GoogleFonts.poppins(fontSize: 13, color: textColor.withOpacity(0.9))),
    ]);
  }
  
  Widget _buildLinkItem(Map<String, dynamic> data, Color textColor) {
    return Row(children: [
        const Icon(Icons.link, size: 16, color: Colors.blue), const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data['title'] ?? "Link", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
            Text(data['url'] ?? "", style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline)),
        ]),
    ]);
  }

  Widget _buildReferenceItem(Map<String, dynamic> data, Color textColor, Color cardColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? cardColor : Colors.grey[50], 
        borderRadius: BorderRadius.circular(8), 
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200)
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['name'] ?? "", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
          Text("${data['position']} at ${data['company']}", style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700)),
          const SizedBox(height: 4),
          Row(children: [Icon(Icons.email_outlined, size: 14, color: isDark ? Colors.grey.shade500 : Colors.grey), const SizedBox(width: 4), Text(data['email'] ?? "", style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600))])
      ]),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, thickness: 1));
  }
}