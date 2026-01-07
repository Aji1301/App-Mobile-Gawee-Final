import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart'; // 1. Import Provider
import '../../../services/api_service.dart';
import '../../../providers/theme_provider.dart'; // 2. Sesuaikan path ke ThemeProvider Anda

class UploadResumeFormScreen extends StatefulWidget {
  const UploadResumeFormScreen({super.key});

  @override
  State<UploadResumeFormScreen> createState() => _UploadResumeFormScreenState();
}

class _UploadResumeFormScreenState extends State<UploadResumeFormScreen> {
  PlatformFile? _selectedFile;
  String? _fileName;
  bool _isLoading = false;

  // 1. Fungsi Pilih File (Tetap)
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.single;
          _fileName = _selectedFile!.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  // 2. Fungsi Upload ke API (Tetap)
  Future<void> _handleUpload() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a file first!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await ApiService.uploadResume(_selectedFile!);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Resume uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload resume."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- UI BUILD ---
  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // 2. Tentukan Warna Dinamis
    final scaffoldBgColor = isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[600]!;
    
    // Warna untuk Input & Box
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final hintColor = isDark ? Colors.white54 : Colors.grey[400]!;
    final handleColor = isDark ? Colors.grey[700] : Colors.grey[300];
    
    // Warna Latar Upload Box (Ungu muda di light, transparan primary di dark)
    final uploadBoxBg = isDark ? primaryColor.withOpacity(0.1) : const Color(0xFFF7F4FD);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Resume",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Handle
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 24),

            // Icon Header
            Image.asset(
              'assets/images/upload_resume_icon.png',
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.upload_file, size: 80, color: subTextColor);
              },
            ),
            const SizedBox(height: 16),

            // Title & Subtitle
            Text("Upload your resume",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)), // Menggunakan primaryColor tema
            const SizedBox(height: 8),
            Text(
              "Adding your resume allows you to apply very\nquickly to many jobs from any device",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: subTextColor, height: 1.4),
            ),
            const SizedBox(height: 24),

            // --- KOTAK UPLOAD ---
            _buildDottedUploadBox(primaryColor, uploadBoxBg, textColor),

            const SizedBox(height: 24),

            // Form Fields
            _buildFormLabel("Your job title or qualification", textColor),
            _buildTextField("Your job title or qualification", cardColor, textColor, hintColor, isDark),
            const SizedBox(height: 16),
            _buildFormLabel("Your location", textColor),
            _buildTextField("Town, county or country", cardColor, textColor, hintColor, isDark),
            const SizedBox(height: 32),

            // --- TOMBOL UPLOAD ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _handleUpload,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  backgroundColor: uploadBoxBg, // Background dinamis
                  side: BorderSide(color: primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor))
                    : const Text("Upload",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Cancel
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text("Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Updated) ---

  Widget _buildDottedUploadBox(
      Color primaryColor, Color bgColor, Color textColor) {
    return GestureDetector(
      onTap: _pickFile,
      child: DottedBorder(
        color: primaryColor.withOpacity(0.7),
        strokeWidth: 1.5,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12.0),
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: double.infinity,
            color: bgColor, // Warna background dinamis
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _fileName ?? "+ Upload Resume (PDF/DOC)",
                    style: TextStyle(
                      color: _fileName != null ? textColor : primaryColor, // Warna teks dinamis
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (_fileName != null)
                  const Icon(Icons.check_circle, color: Colors.green)
                else
                  Icon(Icons.upload_rounded, color: primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: TextStyle(color: textColor),
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText, Color fillColor, Color textColor, Color hintColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
              color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3))
        ],
      ),
      child: TextField(
        style: TextStyle(color: textColor), // Warna input text
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
      ),
    );
  }
}