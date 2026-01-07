import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Controller untuk setiap text field
  final TextEditingController _defaultSetupController = TextEditingController();
  final TextEditingController _customFormatController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _multipleValuesController =
      TextEditingController();
  final TextEditingController _rangePickerController = TextEditingController();
  final TextEditingController _modalController = TextEditingController();

  // State untuk kalender inline
  DateTime selectedDate = DateTime(2025, 12);

  @override
  void dispose() {
    _defaultSetupController.dispose();
    _customFormatController.dispose();
    _dateTimeController.dispose();
    _multipleValuesController.dispose();
    _rangePickerController.dispose();
    _modalController.dispose();
    super.dispose();
  }

  // --- Helper: Judul (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor, // Mengikuti tema
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Helper: Deskripsi (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.4,
          color: textColor, // Mengikuti tema
        ),
      ),
    );
  }

  // --- Helper: Text Field untuk Picker (Dinamis) ---
  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
    required Color fieldColor,
    required Color hintColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        style: TextStyle(color: textColor), // Warna teks input dinamis
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor), // Warna hint dinamis
          filled: true,
          fillColor: fieldColor, // Background field dinamis
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        ),
      ),
    );
  }

  // --- Fungsi Aksi untuk Picker (Dinamis Tema) ---

  Future<void> _selectDate(
      TextEditingController controller, String format) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final primaryColor = themeProvider.primaryColor;
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
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
    if (picked != null) {
      setState(() {
        controller.text = DateFormat(format).format(picked);
      });
    }
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final primaryColor = themeProvider.primaryColor;
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  primaryColor: primaryColor,
                  colorScheme: ColorScheme.dark(
                      primary: primaryColor, onPrimary: Colors.white),
                )
              : ThemeData.light().copyWith(
                  primaryColor: primaryColor,
                  colorScheme: ColorScheme.light(primary: primaryColor),
                ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
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

    if (pickedTime == null) return;

    final DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      controller.text = DateFormat("yyyy-MM-dd HH:mm").format(combined);
    });
  }

  Future<void> _selectDateRange(TextEditingController controller) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final primaryColor = themeProvider.primaryColor;
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  primaryColor: primaryColor,
                  colorScheme: ColorScheme.dark(
                      primary: primaryColor, onPrimary: Colors.white),
                )
              : ThemeData.light().copyWith(
                  primaryColor: primaryColor,
                  colorScheme: ColorScheme.light(primary: primaryColor),
                ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final String start = DateFormat.yMd().format(picked.start);
        final String end = DateFormat.yMd().format(picked.end);
        controller.text = '$start - $end';
      });
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
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade600;

    // Warna Field & Divider
    final textFieldBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Calendar'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildDescription(
                'Calendar is a touch optimized component that provides an easy way to handle dates.',
                textColor),
            const SizedBox(height: 16),
            _buildDescription(
                'Calendar could be used as inline component or as overlay. Overlay Calendar will be automatically converted to Popover on tablets (iPad).',
                textColor),

            // --- Default setup ---
            _buildSectionTitle('Default setup', primaryColor),
            _buildDatePickerField(
              controller: _defaultSetupController,
              hintText: 'Your birth date',
              onTap: () => _selectDate(_defaultSetupController, 'yyyy-MM-dd'),
              fieldColor: textFieldBgColor,
              hintColor: hintColor,
              textColor: textColor,
            ),

            // --- Custom date format ---
            _buildSectionTitle('Custom date format', primaryColor),
            _buildDatePickerField(
              controller: _customFormatController,
              hintText: 'Select date',
              onTap: () =>
                  _selectDate(_customFormatController, 'MMMM dd, yyyy'),
              fieldColor: textFieldBgColor,
              hintColor: hintColor,
              textColor: textColor,
            ),

            // --- Date + Time ---
            _buildSectionTitle('Date + Time', primaryColor),
            _buildDatePickerField(
              controller: _dateTimeController,
              hintText: 'Select date and time',
              onTap: () => _selectDateTime(_dateTimeController),
              fieldColor: textFieldBgColor,
              hintColor: hintColor,
              textColor: textColor,
            ),

            // --- Multiple Values ---
            _buildSectionTitle('Multiple Values', primaryColor),
            _buildDatePickerField(
              controller: _multipleValuesController,
              hintText: 'Select multiple dates',
              onTap: () => _selectDate(_multipleValuesController, 'yyyy-MM-dd'),
              fieldColor: textFieldBgColor,
              hintColor: hintColor,
              textColor: textColor,
            ),

            // --- Range Picker ---
            _buildSectionTitle('Range Picker', primaryColor),
            _buildDatePickerField(
              controller: _rangePickerController,
              hintText: 'Select date range',
              onTap: () => _selectDateRange(_rangePickerController),
              fieldColor: textFieldBgColor,
              hintColor: hintColor,
              textColor: textColor,
            ),

            // --- Open in Modal ---
            _buildSectionTitle('Open in Modal', primaryColor),
            _buildDatePickerField(
              controller: _modalController,
              hintText: 'Select date',
              onTap: () => _selectDate(_modalController, 'yyyy-MM-dd'),
              fieldColor: textFieldBgColor,
              hintColor: hintColor,
              textColor: textColor,
            ),

            // --- Calendar Page ---
            _buildSectionTitle('Calendar Page', primaryColor),
            ListTile(
              title: Text('Open Calendar Page',
                  style: TextStyle(fontSize: 16, color: textColor)),
              trailing: Icon(Icons.chevron_right,
                  color: isDark ? Colors.white54 : Colors.grey.shade400,
                  size: 20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const _FullCalendarPage()),
                );
              },
            ),
            Divider(height: 1, thickness: 1, color: dividerColor, indent: 16),

            // --- Inline with custom toolbar ---
            _buildSectionTitle('Inline with custom toolbar', primaryColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Theme(
                // Theme khusus untuk kalender inline agar sesuai background
                data: isDark
                    ? ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
                            primary: primaryColor, onPrimary: Colors.white),
                      )
                    : ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(primary: primaryColor),
                      ),
                child: CalendarDatePicker(
                  initialDate: DateTime(2025, 12),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- Helper: Halaman Kalender Penuh (Dinamis) ---
class _FullCalendarPage extends StatelessWidget {
  const _FullCalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Full Calendar'),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                      primary: primaryColor, onPrimary: Colors.white),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(primary: primaryColor),
                ),
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            onDateChanged: (newDate) {},
          ),
        ),
      ),
    );
  }
}
