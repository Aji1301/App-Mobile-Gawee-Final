import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ Import Google Fonts
import '../../../services/api_service.dart'; 

class PersonalStatementScreen extends StatefulWidget {
  const PersonalStatementScreen({super.key});

  @override
  State<PersonalStatementScreen> createState() => _PersonalStatementScreenState();
}

class _PersonalStatementScreenState extends State<PersonalStatementScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  // 1. Load Data dari Database
  void _loadExistingData() async {
    final data = await ApiService.getResumeData();
    if (mounted && data != null && data['personal_statement'] != null) {
      setState(() {
        _controller.text = data['personal_statement'];
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 2. Simpan Data ke Database
  void _saveData() async {
    setState(() => _isLoading = true);
    
    // Update ke tabel profiles kolom 'personal_statement'
    bool success = await ApiService.updateResumeDetail(
      'personal_statement', 
      _controller.text
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context); // Tutup BottomSheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Personal statement saved!")),
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
    
    // Warna background ikon yang soft (mengikuti primary color)
    final Color iconBackground = primaryColor.withOpacity(0.1); 

    return Container(
      padding: EdgeInsets.only(
        left: 24.0, 
        right: 24.0, 
        top: 20.0,
        // Agar keyboard tidak menutupi input saat muncul
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle (Garis kecil)
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
    
              // Icon Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: iconBackground, // Warna soft ungu
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
                      ),
                      child: Icon(Icons.description, color: primaryColor, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Personal statement", 
                      style: GoogleFonts.poppins(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
    
              Text(
                "Description", 
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                  color: textColor,
                )
              ),
              const SizedBox(height: 8),
    
              // TEXT FIELD
              Container(
                decoration: BoxDecoration(
                  color: cardColor, // Mengikuti warna kartu (Putih/Gelap)
                  borderRadius: BorderRadius.circular(12.0),
                  // Border tipis transparan
                  border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  maxLines: null,
                  style: GoogleFonts.poppins(color: textColor), // Warna teks input
                  decoration: InputDecoration(
                    hintText: "Tell us about yourself...",
                    hintStyle: GoogleFonts.poppins(color: hintColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                ),
              ),
              const SizedBox(height: 32),
    
              // TOMBOL SAVE
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _saveData,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    backgroundColor: cardColor, // Background tombol mengikuti tema
                    side: BorderSide(color: primaryColor, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: _isLoading 
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor))
                    : Text("Save", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
    
              // TOMBOL CANCEL
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Warna Ungu Utama
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    "Cancel", 
                    style: GoogleFonts.poppins(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}