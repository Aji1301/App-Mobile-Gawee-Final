import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ Import Google Fonts
import '../../../services/api_service.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  // Controller untuk Input Teks
  final TextEditingController _skillController = TextEditingController();

  // Data Dummy untuk Dropdown Experience
  final List<String> _experiences = const [
    '0.5 year', '1 year', '2 years', '3 years', '4 years', '5 years', 
    '6 years', '7 years', '8 years', '9 years', '10 years', '11 years', 
    '12 years', '13 years', '14 years', '15+ years'
  ];

  // State untuk Dropdown
  String _selectedExperience = '1 year'; // Default Value

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  // 1. Load Data dari Database
  void _loadExistingData() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getResumeData();
    
    if (mounted && data != null) {
      // Kita simpan skills sebagai teks biasa, misalnya: "Flutter Developer (3 years)"
      // Atau Anda bisa menggunakan JSON jika ingin lebih kompleks. 
      // Di sini saya contohkan text sederhana.
      if (data['skills'] != null) {
        String skillText = data['skills'];
        
        // Coba parsing sederhana (Misal format: "SkillName | Experience")
        if (skillText.contains('|')) {
          final parts = skillText.split('|');
          _skillController.text = parts[0].trim();
          String exp = parts[1].trim();
          if (_experiences.contains(exp)) {
            _selectedExperience = exp;
          }
        } else {
          _skillController.text = skillText;
        }
      }
    }
    setState(() => _isLoading = false);
  }

  // 2. Simpan Data ke Database
  void _saveData() async {
    setState(() => _isLoading = true);

    // Format penyimpanan: "Nama Skill | Pengalaman"
    // Contoh: "Flutter Developer | 3 years"
    String dataToSave = "${_skillController.text} | $_selectedExperience";

    bool success = await ApiService.updateResumeDetail(
      'skills', 
      dataToSave
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Skill saved!")),
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
                      child: Icon(Icons.star_outline, color: primaryColor, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Skills",
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
                _buildFormLabel("Your skill", textColor),
                _buildTextField("e.g. Graphic Design", _skillController, cardColor, textColor, hintColor),
                const SizedBox(height: 16),

                _buildFormLabel("Experience", textColor),
                _buildExperienceDropdown(context, _selectedExperience, cardColor, textColor),
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

  Widget _buildExperienceDropdown(BuildContext context, String selectedValue, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _experiences.contains(selectedValue) ? selectedValue : _experiences.first,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor.withOpacity(0.6)),
          dropdownColor: bgColor,
          style: GoogleFonts.poppins(color: textColor, fontSize: 16),
          items: _experiences.map((String exp) {
            return DropdownMenuItem<String>(
              value: exp,
              child: Text(exp),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedExperience = newValue;
              });
            }
          },
        ),
      ),
    );
  }
}