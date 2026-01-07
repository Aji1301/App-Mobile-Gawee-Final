import 'package:flutter/material.dart';

// Halaman ini tetap StatefulWidget untuk melacak bahasa yang dipilih
class EditResumeLanguageScreen extends StatefulWidget {
  // Kita terima bahasa saat ini dari halaman sebelumnya
  final String currentLanguage;

  const EditResumeLanguageScreen({
    Key? key,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  State<EditResumeLanguageScreen> createState() =>
      _EditResumeLanguageScreenState();
}

class _EditResumeLanguageScreenState extends State<EditResumeLanguageScreen> {
  // Daftar semua bahasa
  final List<String> languages = const [
    'Arabic', 'Chinese', 'Bosnian', 'Czech', 'Danish', 
    'German', 'Greek', 'English', 'Hindi', 'Indonesian', // Tambahkan bahasa umum
  ];

  // Variabel untuk menyimpan bahasa yang sedang dipilih
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    // --- AMBIL SEMUA WARNA DARI TEMA (Adaptif) ---
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final Color colorPrimary = colorScheme.primary;
    final Color colorScaffoldBackground = colorScheme.background; // Latar belakang utama BottomSheet
    final Color colorCardBackground = theme.cardColor; // Latar belakang Dropdown/Input
    final Color colorText = colorScheme.onBackground; // Warna teks utama
    final Color colorSubtitle = colorScheme.onSurfaceVariant; // Warna teks sekunder/hint
    
    // Warna Netral
    final Color colorBorder = colorScheme.outline;
    // ---

    // Kita return Container sebagai konten Bottom Sheet
    return Container(
      color: colorScaffoldBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      // SafeArea agar tidak terpotong 'home bar' di iOS
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Agar tinggi sheet pas dgn konten
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HANDLE (garis abu-abu di atas)
              _buildHandle(colorBorder),
              const SizedBox(height: 24),

              // 2. HEADER (IKON DAN JUDUL)
              _buildHeader(colorPrimary, colorText),
              const SizedBox(height: 32),

              // 3. LABEL DAN DROPDOWN
              _buildFormLabel("Resume Language", colorText), // Typo diperbaiki
              const SizedBox(height: 8),

              _buildLanguageDropdown(colorCardBackground, colorBorder, colorSubtitle, colorText),
              const SizedBox(height: 24),

              // 4. TOMBOL SAVE DAN CANCEL (Tombol Save utama, Cancel sekunder)
              _buildSaveButton(colorPrimary, colorText),
              const SizedBox(height: 12),
              _buildCancelButton(context, colorPrimary),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // --- WIDGET BANTUAN (ADAPTIF TEMA) ---
  // -------------------------------------------------------------------

  Widget _buildHandle(Color colorBorder) {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: colorBorder,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader(Color colorPrimary, Color colorText) {
    return Center(
      child: Column(
        children: [
          // Gunakan container dengan dekorasi yang adaptif
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Icon(Icons.language, size: 40, color: colorPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            "Resume Language", // Typo diperbaiki
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorPrimary, // Menggunakan warna primer untuk judul utama
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormLabel(String label, Color colorText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          color: colorText, // Gunakan warna teks utama tema
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(
    Color backgroundColor, 
    Color borderColor, 
    Color iconColor, 
    Color textColor
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          isExpanded: true,
          // Ikon berwarna teks utama
          icon: Icon(Icons.arrow_drop_down, color: textColor), 
          style: TextStyle(
            color: textColor, // Warna teks di dalam Dropdown
            fontSize: 16,
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
          ),
          dropdownColor: backgroundColor, // Warna latar belakang item dropdown
          
          items: languages.map((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Text(language),
            );
          }).toList(),
          
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
              });
            }
          },
          
          // Builder untuk item yang dipilih (Menghilangkan logika ModalRoute yang kompleks)
          selectedItemBuilder: (BuildContext context) {
            return languages.map((String value) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value, 
                  style: TextStyle(
                    color: textColor, 
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
  
  Widget _buildSaveButton(Color colorPrimary, Color colorText) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, _selectedLanguage); // Kirim bahasa baru kembali
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "SAVE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, Color colorPrimary) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context); // Kembali tanpa mengirim data
        },
        style: OutlinedButton.styleFrom(
          // Menggunakan warna primer untuk teks dan outline
          foregroundColor: colorPrimary,
          side: BorderSide(color: colorPrimary, width: 1.5), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text(
          "CANCEL",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}