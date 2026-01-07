// lib/picker_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  // --- Data ---
  final List<String> _phones = [
    'iPhone 4',
    'iPhone 4S',
    'iPhone 5',
    'iPhone 5S',
    'iPhone 6',
    'iPhone 6 Plus',
    'iPad 2',
    'iPad Retina',
    'iPad Air',
    'iPad mini',
    'iPad mini 2',
    'iPad mini 3'
  ];

  final List<String> _words1 = [
    'Super',
    'Amazing',
    'Mega',
    'Awesome',
    'Hot',
    'Iron'
  ];
  final List<String> _words2 = ['Banana', 'Orange', 'Cake', 'Raccoon', 'Pizza'];

  final Map<String, List<String>> _cars = {
    'American': ['Cadillac', 'Chevrolet', 'Chrysler', 'Dodge', 'Ford'],
    'German': ['Audi', 'BMW', 'Mercedes', 'Volkswagen', 'Porsche'],
    'Japanese': ['Honda', 'Lexus', 'Mazda', 'Nissan', 'Toyota'],
  };

  // --- State Variables ---
  String _singleValue = 'iPad Air';
  String _twoValues = 'Iron Raccoon';
  String _dependentValue = 'American Ford';
  String _customToolbarValue = 'Mr Hot Raccoon';

  // State untuk Inline Picker
  DateTime _inlineDateTime = DateTime(1993, 1, 28, 14, 17);

  int _selectedCarTypeIndex = 0;
  int _selectedCarModelIndex = 4;

  // --- Helper Widgets (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor, // Mengikuti tema
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.0,
          height: 1.4,
          color: textColor, // Mengikuti tema
        ),
      ),
    );
  }

  Widget _buildPickerField({
    required String text,
    required VoidCallback onTap,
    required Color fieldColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: fieldColor, // Mengikuti tema
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor), // Mengikuti tema
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor), // Mengikuti tema
        ),
      ),
    );
  }

  // --- FUNGSI UTAMA: Tampilkan Modal Picker (Dinamis) ---
  void _showPicker({
    required BuildContext context,
    required Widget child,
    String? title,
    VoidCallback? onDone,
  }) {
    // Ambil tema di dalam dialog
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // Warna Dialog
    final dialogBg = isDark ? themeProvider.cardColor : const Color(0xFFF2F2F7);
    final toolbarBg = isDark ? Colors.grey[900] : const Color(0xFFF9F9F9);
    final textColor = isDark ? Colors.white : Colors.black54;
    final contentBg =
        isDark ? Colors.black12 : Colors.white; // Background area picker

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: 320,
              height: 280,
              decoration: BoxDecoration(
                color: dialogBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // --- Toolbar ---
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: toolbarBg,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(14)),
                      border: Border(
                        bottom: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : const Color(0xFFC7C7C7),
                            width: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (title != null)
                          Text(title,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500))
                        else
                          const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (onDone != null) onDone();
                          },
                          child: Text('Done',
                              style: TextStyle(
                                  color: primaryColor, // Tombol Done ikut tema
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),

                  // --- Content ---
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14)),
                      child: Container(
                        color: contentBg, // Background area putar
                        child: DefaultTextStyle(
                            // Pastikan teks dalam picker mengikuti tema
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 20),
                            child: child),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 1. Single Picker
  void _openSinglePicker() {
    // Ambil warna teks untuk item picker
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
            ThemeMode.dark;
    final itemColor = isDark ? Colors.white : Colors.black;

    int selectedIndex = _phones.indexOf(_singleValue);
    if (selectedIndex == -1) selectedIndex = 0;

    _showPicker(
      context: context,
      child: CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32,
        scrollController:
            FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: (int index) {
          setState(() {
            _singleValue = _phones[index];
          });
        },
        children: List<Widget>.generate(_phones.length, (int index) {
          return Center(
              child: Text(_phones[index], style: TextStyle(color: itemColor)));
        }),
      ),
    );
  }

  // 2. Two Values Picker
  void _openTwoValuesPicker() {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
            ThemeMode.dark;
    final itemColor = isDark ? Colors.white : Colors.black;

    List<String> parts = _twoValues.split(' ');
    int index1 = _words1.indexOf(parts[0]);
    int index2 = _words2.indexOf(parts.length > 1 ? parts[1] : _words2[0]);
    if (index1 == -1) index1 = 0;
    if (index2 == -1) index2 = 0;

    _showPicker(
      context: context,
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              scrollController:
                  FixedExtentScrollController(initialItem: index1),
              onSelectedItemChanged: (int index) {
                setState(() {
                  List<String> currentParts = _twoValues.split(' ');
                  String secondPart =
                      currentParts.length > 1 ? currentParts[1] : "";
                  _twoValues = '${_words1[index]} $secondPart';
                });
              },
              children: _words1
                  .map((e) => Center(
                      child: Text(e, style: TextStyle(color: itemColor))))
                  .toList(),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              scrollController:
                  FixedExtentScrollController(initialItem: index2),
              onSelectedItemChanged: (int index) {
                setState(() {
                  List<String> currentParts = _twoValues.split(' ');
                  String firstPart = currentParts[0];
                  _twoValues = '$firstPart ${_words2[index]}';
                });
              },
              children: _words2
                  .map((e) => Center(
                      child: Text(e, style: TextStyle(color: itemColor))))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Dependent Picker
  void _openDependentPicker() {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
            ThemeMode.dark;
    final itemColor = isDark ? Colors.white : Colors.black;

    List<String> carTypes = _cars.keys.toList();
    FixedExtentScrollController modelController =
        FixedExtentScrollController(initialItem: _selectedCarModelIndex);

    // Reuse _showPicker logic but manual call because dependent needs stateful logic inside dialog
    // We'll simplify by using setState of page but calling _showPicker

    // NOTE: Dependent picker logic is complex with _showPicker helper.
    // To keep simple and consistent with ThemeProvider, we pass the child.
    // The state update happens in parent (this page), which rebuilds the child passed to _showPicker?
    // Actually no, Dialog content needs StatefulBuilder to update itself.
    // So we use the StatefulBuilder approach inside _showPicker directly here.

    // Ambil warna untuk dialog manual
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final primaryColor = themeProvider.primaryColor;
    final dialogBg = isDark ? themeProvider.cardColor : const Color(0xFFF2F2F7);
    final toolbarBg = isDark ? Colors.grey[900] : const Color(0xFFF9F9F9);
    final contentBg = isDark ? Colors.black12 : Colors.white;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: 320,
              height: 280,
              decoration: BoxDecoration(
                color: dialogBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Toolbar
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: toolbarBg,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(14)),
                      border: Border(
                          bottom: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : const Color(0xFFC7C7C7),
                              width: 0.5)),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text('Done',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14)),
                      child: Container(
                        color: contentBg,
                        child: StatefulBuilder(
                          builder: (context, setModalState) {
                            List<String> currentModels =
                                _cars[carTypes[_selectedCarTypeIndex]]!;

                            return Row(
                              children: [
                                Expanded(
                                  child: CupertinoPicker(
                                    itemExtent: 32,
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: _selectedCarTypeIndex),
                                    onSelectedItemChanged: (int index) {
                                      setModalState(() {
                                        _selectedCarTypeIndex = index;
                                        _selectedCarModelIndex = 0;
                                        modelController.jumpToItem(0);
                                      });
                                      setState(() {
                                        _dependentValue =
                                            "${carTypes[_selectedCarTypeIndex]} ${_cars[carTypes[_selectedCarTypeIndex]]![0]}";
                                      });
                                    },
                                    children: carTypes
                                        .map((e) => Center(
                                            child: Text(e,
                                                style: TextStyle(
                                                    color: itemColor))))
                                        .toList(),
                                  ),
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                    key: ValueKey(_selectedCarTypeIndex),
                                    itemExtent: 32,
                                    scrollController: modelController,
                                    onSelectedItemChanged: (int index) {
                                      _selectedCarModelIndex = index;
                                      setState(() {
                                        _dependentValue =
                                            "${carTypes[_selectedCarTypeIndex]} ${currentModels[index]}";
                                      });
                                    },
                                    children: currentModels
                                        .map((e) => Center(
                                            child: Text(e,
                                                style: TextStyle(
                                                    color: itemColor))))
                                        .toList(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 4. Custom Toolbar Picker
  void _openCustomToolbarPicker() {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).themeMode ==
            ThemeMode.dark;
    final itemColor = isDark ? Colors.white : Colors.black;

    _showPicker(
      context: context,
      title: 'Custom Toolbar',
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              children: [
                Center(child: Text('Mr', style: TextStyle(color: itemColor))),
                Center(child: Text('Mrs', style: TextStyle(color: itemColor)))
              ],
              onSelectedItemChanged: (_) {},
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(initialItem: 4),
              children: _words1
                  .map((e) => Center(
                      child: Text(e, style: TextStyle(color: itemColor))))
                  .toList(),
              onSelectedItemChanged: (_) {},
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              scrollController: FixedExtentScrollController(initialItem: 3),
              children: _words2
                  .map((e) => Center(
                      child: Text(e, style: TextStyle(color: itemColor))))
                  .toList(),
              onSelectedItemChanged: (_) {},
            ),
          ),
        ],
      ),
    );
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
    final subtitleColor = isDark ? Colors.white60 : Colors.black54;

    // Warna Field & Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final fieldColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final fieldBorderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    // Warna Inline Date Picker
    // Header abu-abu di kiri atas container date picker
    final dateHeaderColor = isDark ? Colors.grey[800] : const Color(0xFFE9E9EB);
    final datePickerBg = isDark ? Colors.black12 : const Color(0xFFF2F2F7);
    final dateTextColor =
        isDark ? Colors.white : Colors.black; // Untuk teks tanggal

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
            title: const Text('Picker'),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescription(
                'Picker is a powerful component that allows you to create custom overlay pickers which looks like native picker.',
                subtitleColor),
            _buildDescription(
                'Picker could be used as inline component or as overlay. Overlay Picker will be automatically converted to Popover on tablets (iPad).',
                subtitleColor),

            // --- 1. Single Value ---
            _buildSectionTitle('Picker with single value', primaryColor),
            _buildPickerField(
                text: _singleValue,
                onTap: _openSinglePicker,
                fieldColor: fieldColor,
                borderColor: fieldBorderColor,
                textColor: textColor),

            // --- 2. Two Values ---
            _buildSectionTitle('2 values and 3d-rotate effect', primaryColor),
            _buildPickerField(
                text: _twoValues,
                onTap: _openTwoValuesPicker,
                fieldColor: fieldColor,
                borderColor: fieldBorderColor,
                textColor: textColor),

            // --- 3. Dependent ---
            _buildSectionTitle('Dependent values', primaryColor),
            _buildPickerField(
                text: _dependentValue,
                onTap: _openDependentPicker,
                fieldColor: fieldColor,
                borderColor: fieldBorderColor,
                textColor: textColor),

            // --- 4. Custom Toolbar ---
            _buildSectionTitle('Custom toolbar', primaryColor),
            _buildPickerField(
                text: _customToolbarValue,
                onTap: _openCustomToolbarPicker,
                fieldColor: fieldColor,
                borderColor: fieldBorderColor,
                textColor: textColor),

            // --- 5. Inline Picker / Date-time (UPDATED) ---
            _buildSectionTitle('Inline Picker / Date-time', primaryColor),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  // Header Abu-abu (Di KIRI)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: dateHeaderColor, // Mengikuti tema
                    child: Text(
                      DateFormat('MMMM dd, yyyy HH:mm').format(_inlineDateTime),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: dateTextColor, // Mengikuti tema
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Body Picker
                  Container(
                    height: 200,
                    color: datePickerBg, // Mengikuti tema
                    child: CupertinoTheme(
                      // Paksa tema Cupertino untuk picker agar teksnya benar
                      data: CupertinoThemeData(
                        brightness: isDark ? Brightness.dark : Brightness.light,
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: dateTextColor, // Warna teks di dalam roda
                            fontSize: 20,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        backgroundColor: Colors.transparent,
                        use24hFormat: true,
                        initialDateTime: _inlineDateTime,
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            _inlineDateTime = newDateTime;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
