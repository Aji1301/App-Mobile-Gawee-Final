import 'dart:convert'; // Untuk encode/decode JSON
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ Import Google Fonts
import '../../../services/api_service.dart';

class ReferencesScreen extends StatefulWidget {
  const ReferencesScreen({super.key});

  @override
  State<ReferencesScreen> createState() => _ReferencesScreenState();
}

class _ReferencesScreenState extends State<ReferencesScreen> {
  // Controller untuk Input Teks
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 1. Load Data dari Database
  void _loadExistingData() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getResumeData();
    
    if (mounted && data != null) {
      // Mengambil data dari kolom 'references'
      if (data['references'] != null) {
        try {
          final refData = data['references'] is String 
              ? jsonDecode(data['references']) 
              : data['references'];

          setState(() {
            _nameController.text = refData['name'] ?? '';
            _positionController.text = refData['position'] ?? '';
            _companyController.text = refData['company'] ?? '';
            _phoneController.text = refData['phone'] ?? '';
            _emailController.text = refData['email'] ?? '';
          });
        } catch (e) {
          print("Error parsing references: $e");
        }
      }
    }
    setState(() => _isLoading = false);
  }

  // 2. Simpan Data ke Database
  void _saveData() async {
    setState(() => _isLoading = true);

    // Bungkus data menjadi JSON Object
    Map<String, dynamic> refData = {
      'name': _nameController.text,
      'position': _positionController.text,
      'company': _companyController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
    };

    // Simpan ke kolom 'references'
    bool success = await ApiService.updateResumeDetail(
      'references', 
      jsonEncode(refData)
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("References saved!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // === AMBIL TEMA APLIKASI ===
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final hintColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.5) ?? Colors.grey;
    final iconBackground = primaryColor.withOpacity(0.1);

    return Container(
      padding: EdgeInsets.only(
        left: 24.0, 
        right: 24.0, 
        top: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], 
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // HEADER
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: iconBackground,
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
                      ),
                      child: Icon(Icons.thumb_up_outlined, color: primaryColor, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "References",
                      style: GoogleFonts.poppins(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        color: textColor
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              if (_isLoading)
                Center(child: CircularProgressIndicator(color: primaryColor))
              else ...[
                // FORM INPUTS
                _buildFormLabel("Name", textColor),
                _buildTextField("Full Name", _nameController, cardColor, textColor, hintColor),
                const SizedBox(height: 16),

                _buildFormLabel("Resume Title / Job position", textColor),
                _buildTextField("e.g. Senior Manager", _positionController, cardColor, textColor, hintColor),
                const SizedBox(height: 16),

                _buildFormLabel("Company", textColor),
                _buildTextField("Company Name", _companyController, cardColor, textColor, hintColor),
                const SizedBox(height: 16),

                _buildFormLabel("Phone Number (optional)", textColor),
                _buildTextField("+62 xxx xxxx xxxx", _phoneController, cardColor, textColor, hintColor, isNumber: true),
                const SizedBox(height: 16),

                _buildFormLabel("Email", textColor),
                _buildTextField("email@example.com", _emailController, cardColor, textColor, hintColor),
                const SizedBox(height: 32),

                // TOMBOL SAVE (Upload)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _saveData,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: cardColor,
                      side: BorderSide(color: primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text("Save", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                
                // TOMBOL CANCEL
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildFormLabel(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, Color bgColor, Color textColor, Color hintColor, {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        style: GoogleFonts.poppins(color: textColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
      ),
    );
  }
}