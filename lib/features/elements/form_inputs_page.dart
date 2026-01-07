import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class FormInputsPage extends StatefulWidget {
  const FormInputsPage({super.key});

  @override
  State<FormInputsPage> createState() => _FormInputsPageState();
}

class _FormInputsPageState extends State<FormInputsPage> {
  // Key untuk mengelola state Form (diperlukan untuk trigger validasi)
  final GlobalKey<FormState> _validationFormKey = GlobalKey<FormState>();

  // Controller untuk Date/Time Pickers
  final TextEditingController _birthdayController = TextEditingController(
    text: '30/04/2014',
  );
  final TextEditingController _dateTimeController = TextEditingController(
    text: 'dd/mm/yyyy --:--',
  );

  @override
  void dispose() {
    _birthdayController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan DatePicker (Dinamis)
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller, {
    bool includeTime = false,
  }) async {
    // Ambil warna primary dari tema
    final primaryColor =
        Provider.of<ThemeProvider>(context, listen: false).primaryColor;
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
            ThemeMode.dark;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        // Tema Date Picker mengikuti Primary Color
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  primaryColor: primaryColor,
                  colorScheme: ColorScheme.dark(
                      primary: primaryColor, onPrimary: Colors.white),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                )
              : ThemeData.light().copyWith(
                  primaryColor: primaryColor,
                  colorScheme: ColorScheme.light(primary: primaryColor),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (includeTime) {
        // Jika perlu input waktu juga (untuk Date time)
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: isDark
                  ? ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                          primary: primaryColor, onPrimary: Colors.white),
                    )
                  : ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(primary: primaryColor),
                    ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          final DateTime finalDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          // Format output dd/mm/yyyy hh:mm
          controller.text =
              '${finalDateTime.day.toString().padLeft(2, '0')}/${finalDateTime.month.toString().padLeft(2, '0')}/${finalDateTime.year} ${finalDateTime.hour.toString().padLeft(2, '0')}:${finalDateTime.minute.toString().padLeft(2, '0')}';
        }
      } else {
        // Hanya input tanggal (untuk Birthday)
        // Format output dd/mm/yyyy
        controller.text =
            '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          'Form Inputs',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 1. Full Layout / Stacked Labels ---
            _buildSectionTitle('Full Layout / Stacked Labels', primaryColor),
            _buildStackedInputs(),

            // --- 2. Outline Inputs (Original) ---
            _buildSectionTitle('Outline Inputs', primaryColor),
            _buildOriginalOutlineInputs(floating: false),

            // --- 3. Floating Labels + Outline Inputs (Original) ---
            _buildSectionTitle(
                'Floating Labels + Outline Inputs', primaryColor),
            _buildOriginalOutlineInputs(floating: true),

            // --- 4. Label + Input ---
            _buildSectionTitle('Label + Input', primaryColor),
            _buildLabelInput(),

            // --- 5. Only Inputs ---
            _buildSectionTitle('Only Inputs', primaryColor),
            _buildOnlyInputs(),

            // --- 6. Inputs + Additional Info ---
            _buildSectionTitle('Inputs + Additional Info', primaryColor),
            _buildInputsWithInfo(),

            // --- 7. Validation + Additional Info ---
            _buildSectionTitle('Validation + Additional Info', primaryColor),
            // Membungkus bagian validation dengan Form
            Form(key: _validationFormKey, child: _buildValidationInputs()),

            // Tombol untuk mencoba validasi (opsional)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_validationFormKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Validation Passed!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Validation Failed!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Mengikuti tema
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Check Validation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // --- 8. Icon + Input ---
            _buildSectionTitle('Icon + Input', primaryColor),
            _buildIconInputs(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // --- WIDGET BUILDER ---
  // -------------------------------------------------------------------

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  // Bagian 1: Full Layout / Stacked Labels
  Widget _buildStackedInputs() {
    return Column(
      children: [
        _buildInputTemplate(
          label: 'Name',
          hintText: 'Your name',
          stacked: true,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'Password',
          hintText: 'Your password',
          stacked: true,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'E-mail',
          hintText: 'Your e-mail',
          stacked: true,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'URL',
          hintText: 'URL',
          stacked: true,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'Phone',
          hintText: 'Your phone number',
          stacked: true,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'Gender',
          hintText: 'Select Gender',
          stacked: true,
          isDropdown: true,
        ),
        const SizedBox(height: 8),
        // Input Birthday dengan DatePicker
        _buildInputTemplate(
          label: 'Birthday',
          hintText: '30/04/2014',
          stacked: true,
          readOnly: true,
          suffixIcon: Icons.calendar_today,
          controller: _birthdayController,
          onSuffixIconTap: () => _selectDate(context, _birthdayController),
        ),
        const SizedBox(height: 8),
        // Input Date time dengan DatePicker & TimePicker
        _buildInputTemplate(
          label: 'Date time',
          hintText: 'dd/mm/yyyy --:--',
          stacked: true,
          readOnly: true,
          suffixIcon: Icons.calendar_today,
          controller: _dateTimeController,
          onSuffixIconTap: () =>
              _selectDate(context, _dateTimeController, includeTime: true),
        ),
        const SizedBox(height: 8),
        _buildRangeSlider(label: 'Range'),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'Textarea',
          hintText: 'Bio',
          stacked: true,
          maxLines: 4,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'Resizable',
          hintText: 'Bio',
          stacked: true,
          maxLines: null,
          minLines: 2,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Bagian 2/3: Outline Inputs & Floating Labels
  Widget _buildOriginalOutlineInputs({required bool floating}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildOutlineInputTemplate(
            label: 'Name',
            hintText: 'Your name',
            floating: floating,
          ),
          _buildOutlineInputTemplate(
            label: 'Password',
            hintText: 'Your password',
            floating: floating,
            obscureText: true,
          ),
          _buildOutlineInputTemplate(
            label: 'E-mail',
            hintText: 'Your e-mail',
            floating: floating,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildOutlineInputTemplate(
            label: 'URL',
            hintText: 'URL',
            floating: floating,
            keyboardType: TextInputType.url,
          ),
          _buildOutlineInputTemplate(
            label: 'Phone',
            hintText: 'Your phone number',
            floating: floating,
            keyboardType: TextInputType.phone,
          ),
          _buildOutlineInputTemplate(
            label: 'Bio',
            hintText: 'Bio',
            floating: floating,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // Bagian 4: Label + Input
  Widget _buildLabelInput() {
    return Column(
      children: [
        _buildInputTemplate(
          label: 'Name',
          hintText: 'Your name',
          stacked: false,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'Password',
          hintText: 'Your password',
          stacked: false,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'E-mail',
          hintText: 'Your e-mail',
          stacked: false,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: 'URL',
          hintText: 'URL',
          stacked: false,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Bagian 5: Only Inputs
  Widget _buildOnlyInputs() {
    return Column(
      children: [
        _buildInputTemplate(
          label: '',
          hintText: 'Your name',
          stacked: false,
          onlyInput: true,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'Your password',
          stacked: false,
          obscureText: true,
          onlyInput: true,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'Your e-mail',
          stacked: false,
          keyboardType: TextInputType.emailAddress,
          onlyInput: true,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'URL',
          stacked: false,
          keyboardType: TextInputType.url,
          onlyInput: true,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Bagian 6: Inputs + Additional Info
  Widget _buildInputsWithInfo() {
    // Ambil tema untuk custom background di mode gelap
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
            ThemeMode.dark;
    final infoBgColor = isDark ? Colors.grey[800] : Colors.grey.shade200;

    return Column(
      children: [
        _buildInputTemplate(
          label: '',
          hintText: 'Your name',
          infoText: 'Full name please',
          onlyInput: true,
          background: infoBgColor, // Warna dinamis
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'Your password',
          infoText: '8 characters minimum',
          obscureText: true,
          onlyInput: true,
          background: infoBgColor,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'Your e-mail',
          infoText: 'Your work e-mail address',
          onlyInput: true,
          background: infoBgColor,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'URL',
          infoText: 'Your website URL',
          onlyInput: true,
          background: infoBgColor,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Bagian 7: Validation + Additional Info
  Widget _buildValidationInputs() {
    return Column(
      children: [
        _buildValidationInput(
          label: 'Name',
          hintText: 'Your name',
          infoText: 'Default "required" validation',
          initialValue: '',
        ),
        const SizedBox(height: 8),
        _buildValidationInput(
          label: 'Fruit',
          hintText: 'Type \'apple\' or \'banana\'',
          infoText: 'Pattern validation (apple|banana)',
          initialValue: 'banana',
        ),
        const SizedBox(height: 8),
        _buildValidationInput(
          label: 'E-mail',
          hintText: 'Your e-mail',
          infoText: 'Default e-mail validation',
          initialValue: 'test@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 8),
        _buildValidationInput(
          label: 'URL',
          hintText: 'Your URL',
          infoText: 'Default URL validation',
          initialValue: 'https://framework7.io',
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 8),
        _buildValidationInput(
          label: 'Number',
          hintText: 'Enter number',
          infoText: 'With custom error message',
          initialValue: '12345',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Bagian 8: Icon + Input
  Widget _buildIconInputs() {
    return Column(
      children: [
        _buildInputTemplate(
          label: '',
          hintText: 'Your name',
          onlyInput: true,
          leadingIcon: Icons.square,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'Your password',
          onlyInput: true,
          obscureText: true,
          leadingIcon: Icons.square,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'Your e-mail',
          onlyInput: true,
          keyboardType: TextInputType.emailAddress,
          leadingIcon: Icons.square,
        ),
        const SizedBox(height: 8),
        _buildInputTemplate(
          label: '',
          hintText: 'URL',
          onlyInput: true,
          keyboardType: TextInputType.url,
          leadingIcon: Icons.square,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // -------------------------------------------------------------------
  // --- TEMPLATE UTAMA UNTUK INPUT STACKED/LABEL (DINAMIS) ---
  // -------------------------------------------------------------------
  Widget _buildInputTemplate({
    required String label,
    required String hintText,
    bool stacked = false,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    IconData? suffixIcon,
    int? maxLines = 1,
    int? minLines,
    bool isDropdown = false,
    bool onlyInput = false,
    String? infoText,
    IconData? leadingIcon,
    Color? background,
    String? initialValue,
    TextEditingController? controller,
    VoidCallback? onSuffixIconTap,
  }) {
    // Ambil Data Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // Warna Dinamis
    final formFieldBackground =
        isDark ? themeProvider.cardColor : Colors.grey.shade100;
    final formSeparatorColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final inputBorderColor = isDark ? Colors.white24 : Colors.grey.shade400;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade500;

    final Color bgColor = background ?? formFieldBackground;

    // Dummy Checkbox/Icon
    final Widget dummyLeading = Padding(
      padding: const EdgeInsets.only(top: 12, left: 16),
      child: leadingIcon != null
          ? Icon(leadingIcon,
              color: isDark ? Colors.white60 : Colors.grey.shade600)
          : Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: inputBorderColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
    );

    Widget inputField;

    if (isDropdown) {
      inputField = DropdownButtonFormField<String>(
        dropdownColor: isDark ? themeProvider.cardColor : Colors.white,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          labelText: stacked ? label : null,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: bgColor,
          border: InputBorder.none,
          isDense: true,
          labelStyle: TextStyle(
            color: textColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(color: hintColor),
        ),
        value: null,
        items: const ['Female', 'Male']
            .map(
              (String item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: (String? newValue) {
          if (kDebugMode) {
            print('Dropdown selected: $newValue');
          }
        },
      );
    } else {
      inputField = TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        obscureText: obscureText,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        minLines: minLines,
        style: TextStyle(fontSize: 16, color: textColor),
        decoration: InputDecoration(
          labelText: stacked ? label : null,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            color: textColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(color: hintColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: bgColor,
          border: InputBorder.none,
          suffixIcon: suffixIcon != null
              ? InkWell(
                  onTap: onSuffixIconTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(suffixIcon,
                        color: isDark ? Colors.white60 : Colors.grey.shade600),
                  ),
                )
              : null,
        ),
      );
    }

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dummy Checkbox/Icon di kiri
        dummyLeading,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label di luar input field (untuk Label + Input)
              if (!stacked && !onlyInput)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4, right: 16),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              Padding(
                padding: EdgeInsets.only(right: 16, top: stacked ? 0 : 0),
                child: inputField,
              ),

              // Info text (untuk Inputs + Additional Info)
              if (infoText != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 4,
                    bottom: 8,
                    right: 16,
                  ),
                  child: Text(
                    infoText,
                    style: TextStyle(fontSize: 12, color: primaryColor),
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    // Final Container
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(color: formSeparatorColor, width: 0.0),
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      child: content,
    );
  }

  // -------------------------------------------------------------------
  // --- TEMPLATE KHUSUS UNTUK OUTLINE INPUTS (DINAMIS) ---
  // -------------------------------------------------------------------
  Widget _buildOutlineInputTemplate({
    required String label,
    required String hintText,
    required bool floating,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
  }) {
    // Ambil Data Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // Warna Dinamis
    final inputBorderColor = isDark ? Colors.white24 : Colors.grey.shade400;
    final textColor = isDark ? Colors.white : Colors.black87;
    final labelColor =
        isDark ? Colors.white70 : Colors.black87.withOpacity(0.8);
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade500;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(fontSize: 16, color: textColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          // Ini yang membuat floating label dan outline border
          floatingLabelBehavior: floating
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: labelColor),
          hintStyle: TextStyle(color: hintColor),
          contentPadding: const EdgeInsets.all(16),

          // Outline appearance
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: inputBorderColor, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),

          // Menambahkan Checkbox Dummy di kiri luar
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: inputBorderColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 20,
          ),
        ),
      ),
    );
  }

  // TEMPLATE KHUSUS UNTUK VALIDATION INPUT (DINAMIS)
  Widget _buildValidationInput({
    required String label,
    required String hintText,
    required String infoText,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Ambil Data Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // Warna Dinamis
    final formFieldBackground =
        isDark ? themeProvider.cardColor : Colors.grey.shade100;
    final formSeparatorColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final inputBorderColor = isDark ? Colors.white24 : Colors.grey.shade400;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade500;

    final Widget dummyCheckbox = Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: inputBorderColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    // LOGIKA VALIDATOR (Sama seperti sebelumnya)
    String? Function(String?)? validator;
    if (label == 'Fruit') {
      validator = (String? value) {
        if (value == null || value.isEmpty) return 'This field is required';
        if (value.toLowerCase() != 'apple' && value.toLowerCase() != 'banana') {
          return 'Value must be \'apple\' or \'banana\'';
        }
        return null;
      };
    } else if (label == 'Number') {
      validator = (String? value) {
        if (value == null || value.isEmpty) return 'This field is required';
        if (double.tryParse(value) == null) return 'You must enter a number!';
        return null;
      };
    } else if (label == 'Name') {
      validator = (String? value) {
        if (value == null || value.isEmpty) return 'Name is required';
        return null;
      };
    } else if (label == 'E-mail') {
      validator = (String? value) {
        if (value == null || value.isEmpty) return 'E-mail is required';
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) return 'Invalid e-mail format';
        return null;
      };
    } else if (label == 'URL') {
      validator = (String? value) {
        if (value == null || value.isEmpty) return 'URL is required';
        final urlRegex = RegExp(r'^(http|https):\/\/[^ "]+$');
        if (!urlRegex.hasMatch(value)) return 'Invalid URL format';
        return null;
      };
    }

    return Container(
      decoration: BoxDecoration(
        color: formFieldBackground,
        border: Border(
          bottom: BorderSide(color: formSeparatorColor, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox (Kotak abu-abu)
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: dummyCheckbox,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: initialValue,
                  style: TextStyle(fontSize: 16, color: textColor),
                  keyboardType: keyboardType,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hintText,
                    labelStyle: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                    hintStyle: TextStyle(color: hintColor),
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    filled: true,
                    fillColor: formFieldBackground,
                    border: InputBorder.none,
                    // Style Error
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                      height: 0.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    infoText,
                    style: TextStyle(fontSize: 12, color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Dummy untuk Range Slider (DINAMIS)
  Widget _buildRangeSlider({required String label}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    final formFieldBackground =
        isDark ? themeProvider.cardColor : Colors.grey.shade100;
    final formSeparatorColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: formFieldBackground,
        border: Border(
          bottom: BorderSide(color: formSeparatorColor, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Slider(
            value: 50,
            min: 0,
            max: 100,
            activeColor: primaryColor,
            onChanged: (double value) {},
          ),
        ],
      ),
    );
  }
}
