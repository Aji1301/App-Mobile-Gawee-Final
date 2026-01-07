import 'dart:convert'; // Untuk encode/decode JSON
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ Import Google Fonts
import '../../../services/api_service.dart';

class CertificationsScreen extends StatefulWidget {
  const CertificationsScreen({super.key});

  @override
  State<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends State<CertificationsScreen> {
  // Controller untuk Input Teks
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Data Dropdown
  final List<String> _months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<String> _years = List.generate(30, (index) => (2030 - index).toString());

  // State untuk Dropdown (Default Value)
  String _startMonth = 'January';
  String _startYear = '2023';
  String _endMonth = 'January';
  String _endYear = '2024';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 1. Load Data dari Database
  void _loadExistingData() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getResumeData();
    
    if (mounted && data != null) {
      // Mengambil data dari kolom 'certifications'
      if (data['certifications'] != null) {
        try {
          final certData = data['certifications'] is String 
              ? jsonDecode(data['certifications']) 
              : data['certifications'];

          setState(() {
            _titleController.text = certData['title'] ?? '';
            _descriptionController.text = certData['description'] ?? '';
            
            if (_months.contains(certData['start_month'])) _startMonth = certData['start_month'];
            if (_years.contains(certData['start_year'])) _startYear = certData['start_year'];
            if (_months.contains(certData['end_month'])) _endMonth = certData['end_month'];
            if (_years.contains(certData['end_year'])) _endYear = certData['end_year'];
          });
        } catch (e) {
          print("Error parsing certifications: $e");
        }
      }
    }
    setState(() => _isLoading = false);
  }

  // 2. Simpan Data ke Database
  void _saveData() async {
    setState(() => _isLoading = true);

    // Bungkus data menjadi JSON Object
    Map<String, dynamic> certData = {
      'title': _titleController.text,
      'start_month': _startMonth,
      'start_year': _startYear,
      'end_month': _endMonth,
      'end_year': _endYear,
      'description': _descriptionController.text,
    };

    // Simpan ke kolom 'certifications'
    bool success = await ApiService.updateResumeDetail(
      'certifications', 
      jsonEncode(certData)
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Certification saved!")),
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
                      child: Icon(Icons.article_outlined, color: primaryColor, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Certifications",
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
                _buildFormLabel("Title", textColor),
                _buildTextField("e.g. AWS Certified Solutions Architect", _titleController, cardColor, textColor, hintColor),
                const SizedBox(height: 16),

                // Start Date
                _buildFormLabel("Start", textColor),
                Row(
                  children: [
                    Expanded(child: _buildDropdown(_months, _startMonth, (val) => setState(() => _startMonth = val!), cardColor, textColor)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDropdown(_years, _startYear, (val) => setState(() => _startYear = val!), cardColor, textColor)),
                  ],
                ),
                const SizedBox(height: 16),

                // End Date
                _buildFormLabel("End", textColor),
                Row(
                  children: [
                    Expanded(child: _buildDropdown(_months, _endMonth, (val) => setState(() => _endMonth = val!), cardColor, textColor)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDropdown(_years, _endYear, (val) => setState(() => _endYear = val!), cardColor, textColor)),
                  ],
                ),
                const SizedBox(height: 16),

                _buildFormLabel("Description", textColor),
                _buildDescriptionTextField(cardColor, textColor, hintColor),
                const SizedBox(height: 32),

                // TOMBOL SAVE
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

  Widget _buildTextField(String hintText, TextEditingController controller, Color bgColor, Color textColor, Color hintColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: TextField(
        controller: controller,
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

  Widget _buildDescriptionTextField(Color bgColor, Color textColor, Color hintColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: TextField(
        controller: _descriptionController,
        keyboardType: TextInputType.multiline,
        minLines: 8,
        maxLines: null,
        style: GoogleFonts.poppins(color: textColor),
        decoration: InputDecoration(
          hintText: "Description about certification...",
          hintStyle: GoogleFonts.poppins(color: hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, Function(String?) onChanged, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor.withOpacity(0.6)),
          dropdownColor: bgColor,
          style: GoogleFonts.poppins(color: textColor, fontSize: 16),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}