import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Tambahkan package ini di pubspec.yaml jika belum ada
import '../../../services/api_service.dart';
import '../../../widgets/custom_drawer.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({Key? key}) : super(key: key);

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  // State untuk menyimpan URL resume
  String? _resumeUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkExistingResume();
  }

  // Fungsi Cek Resume di Database saat halaman dibuka
  void _checkExistingResume() async {
    final profile = await ApiService.getProfile();
    if (mounted) {
      setState(() {
        _resumeUrl = profile?['resume_url']; // Ambil kolom resume_url
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk Membuka PDF di Browser/External App
  Future<void> _viewResume() async {
    if (_resumeUrl != null) {
      final Uri url = Uri.parse(_resumeUrl!);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_resumeUrl');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color colorPrimaryButton = theme.primaryColor;
    final Color colorPurpleText = theme.primaryColor;
    final Color colorGreyText = theme.textTheme.bodyMedium?.color ?? Colors.grey[600]!;
    final Color colorTitleText = theme.textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Resume"),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: const SizedBox(
        width: 320,
        child: Drawer(child: CustomDrawerBody()),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  // --- BAGIAN 1: UPLOAD / VIEW RESUME ---
                  
                  // LOGIKA TAMPILAN DINAMIS
                  if (_resumeUrl != null) 
                    // JIKA SUDAH ADA RESUME -> TAMPILKAN KARTU "VIEW"
                    _buildUploadedState(context, colorPurpleText, colorPrimaryButton)
                  else
                    // JIKA BELUM ADA -> TAMPILKAN KARTU "UPLOAD"
                    _buildUploadSection(context, colorPurpleText, colorGreyText, colorTitleText, colorPrimaryButton),

                  const Divider(height: 60, thickness: 1, color: Colors.grey),

                  // --- BAGIAN 2: CREATE RESUME ---
                  _buildCreateSection(context, colorGreyText, colorTitleText, colorPrimaryButton),
                ],
              ),
            ),
    );
  }

  // --- WIDGET BARU: Tampilan Jika Resume Sudah Ada ---
  Widget _buildUploadedState(BuildContext context, Color colorPurpleText, Color colorPrimaryButton) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          Text(
            "Resume Uploaded!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorPurpleText),
          ),
          const SizedBox(height: 8),
          const Text(
            "You have a resume saved. You can view it or upload a new one to replace it.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _viewResume, // Buka PDF
                  icon: const Icon(Icons.visibility),
                  label: const Text("View"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorPrimaryButton,
                    side: BorderSide(color: colorPrimaryButton),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Buka halaman upload lagi untuk menimpa file lama
                    await Navigator.pushNamed(context, '/resume_upload');
                    _checkExistingResume(); // Refresh setelah kembali
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Replace"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimaryButton,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ... (Widget _buildUploadSection dan _buildCreateSection SAMA SEPERTI SEBELUMNYA)
  // Copy-paste saja widget _buildUploadSection dan _buildCreateSection dari kode lama Anda ke sini.
  // Pastikan parameter function-nya sesuai.
  
  Widget _buildUploadSection(BuildContext context, Color colorPurpleText, Color colorGreyText, Color colorTitleText, Color colorPrimaryButton) {
    return Column(
      children: [
        Text("Post Your Resumes", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorPurpleText)),
        const SizedBox(height: 8),
        Text("Adding your resume allows you to reply very\nquickly to many jobs from any device", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: colorGreyText, height: 1.4)),
        const SizedBox(height: 24),
        Image.asset('assets/images/upload_resume_icon.png', height: 100, errorBuilder: (ctx, err, stack) => Icon(Icons.upload_file, size: 100, color: colorGreyText)),
        const SizedBox(height: 16),
        Text("Upload your resume", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorTitleText)),
        const SizedBox(height: 8),
        Text("Upload your resume and you'll be able to apply to\njobs in just one click!", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: colorGreyText, height: 1.4)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // Tunggu hasil dari halaman upload
              await Navigator.pushNamed(context, '/resume_upload');
              // Saat kembali, cek ulang database
              _checkExistingResume();
            },
            style: ElevatedButton.styleFrom(backgroundColor: colorPrimaryButton, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
            child: const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Text("Upload", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateSection(BuildContext context, Color colorGreyText, Color colorTitleText, Color colorPrimaryButton) {
    return Column(
      children: [
        Image.asset('assets/images/create_resume_icon.png', height: 100, errorBuilder: (ctx, err, stack) => Icon(Icons.edit_document, size: 100, color: colorGreyText)),
        const SizedBox(height: 16),
        Text("Create your resume", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorTitleText)),
        const SizedBox(height: 8),
        Text("Don't have a resume? Create one in no time with\nour easy-to-use Resume-builder tool", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: colorGreyText, height: 1.4)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/resume_create_form'),
            style: ElevatedButton.styleFrom(backgroundColor: colorPrimaryButton, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
            child: const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Text("Create", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
        ),
      ],
    );
  }
}