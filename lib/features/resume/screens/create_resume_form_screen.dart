import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../widgets/custom_drawer.dart'; // ✅ 1. IMPORT DRAWER

class CreateResumeFormScreen extends StatefulWidget {
  const CreateResumeFormScreen({Key? key}) : super(key: key);

  @override
  State<CreateResumeFormScreen> createState() => _CreateResumeFormScreenState();
}

class _CreateResumeFormScreenState extends State<CreateResumeFormScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _jobTitleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    setState(() => _isLoading = true);

    try {
      if (_jobTitleController.text.isNotEmpty) {
        await ApiService.updateResumeDetail('job_title', _jobTitleController.text);
      }

      if (_locationController.text.isNotEmpty) {
        await ApiService.updateResumeDetail('location', _locationController.text);
      }

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pushNamed(context, '/resume_builder');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan data: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color colorPrimaryButton = theme.primaryColor;
    final Color colorPurpleText = theme.primaryColor;
    final Color colorGreyText = theme.textTheme.bodyMedium?.color ?? Colors.black54; 
    final Color colorTitleText = theme.textTheme.bodyLarge?.color ?? Colors.black87; 

    return Scaffold(
      // ✅ 2. PASANG DRAWER DISINI
      drawer: SizedBox(width: 320, child: Drawer(child: CustomDrawerBody())),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Resume"),
        centerTitle: true,
        actions: [
          // ✅ 3. UPDATE TOMBOL TITIK TIGA UNTUK BUKA DRAWER
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Membuka Drawer
                Scaffold.of(ctx).openDrawer(); 
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Handle
            Container(
              width: 50, height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            // Ikon
            Image.asset(
              'assets/images/create_resume_icon.png',
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.edit_document, size: 80, color: colorGreyText);
              },
            ),
            const SizedBox(height: 16),

            // Judul
            Text(
              "Start Your Resume",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorPurpleText,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Masukkan detail Anda untuk memulai proses pembuatan resume.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: colorGreyText, height: 1.4),
            ),
            const SizedBox(height: 24),

            // --- FORM INPUT ---
            
            _buildFormLabel("Email", colorTitleText),
            _buildTextField("Type in your email", _emailController),
            const SizedBox(height: 16),

            _buildFormLabel("Your job title or qualification", colorTitleText),
            _buildTextField("Your job title or qualification", _jobTitleController),
            const SizedBox(height: 16),

            _buildFormLabel("Your location", colorTitleText),
            _buildTextField("Town, county or country", _locationController),
            const SizedBox(height: 32),

            // --- TOMBOL CREATE ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _handleCreate,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorPrimaryButton,
                  backgroundColor: theme.cardColor,
                  side: BorderSide(color: colorPrimaryButton, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _isLoading 
                    ? SizedBox(
                        height: 20, width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimaryButton)
                      )
                    : const Text(
                        "Create",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Cancel
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimaryButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label, Color colorTitleText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: TextStyle(
                color: colorTitleText,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
      ),
    );
  }
}