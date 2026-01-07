import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers Dasar
  final _titleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // ✅ 1. CONTROLLER BARU UNTUK REQUIREMENTS
  final _requirementsController = TextEditingController();

  // Controllers Gaji
  final _minSalaryController = TextEditingController();
  final _maxSalaryController = TextEditingController();

  bool _isLoading = false;

  // --- OPSI DROPDOWN ---
  final List<String> _categoryOptions = [
    'Programmer',
    'Designer',
    'Manager',
    'Marketing',
    'Finance',
    'UX/UI Designer',
    'Photographer'
  ];
  String? _selectedCategory; 

  // Mata Uang
  final List<String> _currencyOptions = ['US Dollar', 'IDR (Rupiah)', 'EUR (Euro)', 'SGD'];
  String _selectedCurrency = 'US Dollar'; 

  @override
  void dispose() {
    _titleController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose(); // ✅ Dispose controller baru
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    super.dispose();
  }

  void _submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a job category.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Format Gaji
    String salaryString = "Negotiable";
    if (_minSalaryController.text.isNotEmpty && _maxSalaryController.text.isNotEmpty) {
       String currencySymbol = _getCurrencySymbol(_selectedCurrency);
       salaryString = "$currencySymbol${_minSalaryController.text} - $currencySymbol${_maxSalaryController.text}";
    }

    // ✅ PERBAIKAN: Kirim Data Lengkap (termasuk Requirements)
    bool success = await ApiService.postJob(
      title: _titleController.text,
      companyName: _companyNameController.text,
      location: _locationController.text,
      salaryRange: salaryString,
      description: _descriptionController.text,
      category: _selectedCategory!, 
      requirements: _requirementsController.text, // ✅ Kirim Requirements ke API
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job posted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to post job.")),
        );
      }
    }
  }

  String _getCurrencySymbol(String currencyName) {
    switch (currencyName) {
      case 'IDR (Rupiah)': return 'Rp ';
      case 'EUR (Euro)': return '€';
      case 'SGD': return 'S\$';
      default: return '\$'; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Post a New Job", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyMedium?.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. JOB TITLE ---
              _buildLabel("Job Title"),
              _buildTextField(_titleController, "e.g. Senior Flutter Developer"),
              const SizedBox(height: 20),

              // --- 2. CATEGORY (DROPDOWN) ---
              _buildLabel("Job Category"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: Text("Select Category", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: _categoryOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 3. COMPANY & LOCATION ---
              _buildLabel("Company Name"),
              _buildTextField(_companyNameController, "e.g. Google Inc."),
              const SizedBox(height: 20),

              _buildLabel("Location"),
              _buildTextField(_locationController, "e.g. Jakarta, Indonesia (Remote)"),
              const SizedBox(height: 24),

              // --- 4. SALARY RANGE (EXPANSION TILE) ---
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      "Set Salary Range", 
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)
                    ),
                    childrenPadding: const EdgeInsets.all(16),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Currency Dropdown
                          _buildLabel("Currency"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCurrency,
                                isExpanded: true,
                                items: _currencyOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCurrency = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Min Amount
                          _buildLabel("Min Amount"),
                          _buildTextField(_minSalaryController, "120000", isNumber: true, isInsideCard: true),
                          const SizedBox(height: 16),

                          // Max Amount
                          _buildLabel("Max Amount"),
                          _buildTextField(_maxSalaryController, "240000", isNumber: true, isInsideCard: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- 5. DESCRIPTION ---
              _buildLabel("Description"),
              _buildTextField(_descriptionController, "Describe the role...", maxLines: 5),
              
              const SizedBox(height: 24),

              // --- ✅ 6. REQUIREMENTS (INPUT BARU) ---
              _buildLabel("Requirements (Press Enter for new point)"),
              _buildTextField(
                _requirementsController, 
                "e.g. \n• Must speak English\n• 3 years experience\n• Good team player", 
                maxLines: 5
              ),

              const SizedBox(height: 30),
              
              // --- BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text("PUBLISH JOB", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text, 
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500, 
          fontSize: 14,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)
        )
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, bool isNumber = false, bool isInsideCard = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.multiline, // Support multiline untuk reqs
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      validator: (value) {
        // Jika input gaji kosong diabaikan, tapi text field lain wajib
        if (!isNumber && (value == null || value.isEmpty)) return "Field cannot be empty";
        return null;
      },
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
        filled: true,
        fillColor: isInsideCard ? theme.scaffoldBackgroundColor : theme.cardColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}