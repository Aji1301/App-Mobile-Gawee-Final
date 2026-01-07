// lib/stepper_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  // --- State Management ---
  final Map<String, double> _values = {
    'default': 0,
    'round': 0,
    'fill': 0,
    'roundFill': 0,
    'small': 0,
    'smallRound': 0,
    'smallFill': 0,
    'smallRoundFill': 0,
    'large': 0,
    'largeRound': 0,
    'largeFill': 0,
    'largeRoundFill': 0,
    'raisedDefault': 0,
    'raisedRound': 0,
    'raisedFill': 0,
    'raisedRoundFill': 0,
    'red': 0,
    'green': 0,
    'blue': 0,
    'pink': 0,
    'yellow': 0,
    'orange': 0,
    'purple': 0,
    'black': 0,
    'noInput': 0,
    'noInputRound': 0,
    'minMax': 100,
    'step': 5,
    'autoDefault': 0,
    'autoDynamic': 0,
    'wraps': 0,
    'apples': 0,
    'oranges': 0,
    'meeting': 15,
    'manual': 0,
  };

  // --- Helper: Memperbarui Nilai ---
  void _updateValue(String key, double newValue) {
    setState(() {
      _values[key] = newValue;
    });
  }

  // --- Helper: Judul Bagian (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor,
      {bool addTopPadding = true}) {
    return Padding(
      padding: EdgeInsets.only(
          top: addTopPadding ? 24.0 : 0.0,
          bottom: 8.0,
          left: 16.0,
          right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Helper: Deskripsi (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.4,
          color: textColor,
        ),
      ),
    );
  }

  // --- Helper: Baris Stepper (Dinamis) ---
  Widget _buildStepperRow({
    required String titleLeft,
    required String keyLeft,
    required Widget stepperLeft,
    required String titleRight,
    required String keyRight,
    required Widget stepperRight,
    required Color textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolom Kiri
        Expanded(
          child: Column(
            children: [
              Text(titleLeft,
                  style: TextStyle(color: textColor.withOpacity(0.7))),
              const SizedBox(height: 8),
              stepperLeft,
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Kolom Kanan
        Expanded(
          child: Column(
            children: [
              Text(titleRight,
                  style: TextStyle(color: textColor.withOpacity(0.7))),
              const SizedBox(height: 8),
              stepperRight,
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper: Baris Kustom (Dinamis) ---
  Widget _buildCustomValueRow({
    required String title,
    required String key,
    required Color textColor,
    required Color primaryColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title: ${_values[key]!.toInt()}',
              style: TextStyle(fontSize: 16, color: textColor)),
          _CustomStepper(
            value: _values[key]!,
            onChanged: (val) => _updateValue(key, val),
            showInput: false,
            color: primaryColor, // Mengikuti tema
            isDark: isDark,
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

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
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
            title: const Text('Stepper'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Shape and size ---
            _buildSectionTitle('Shape and size', primaryColor,
                addTopPadding: false),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Default',
              keyLeft: 'default',
              stepperLeft: _CustomStepper(
                value: _values['default']!,
                onChanged: (val) => _updateValue('default', val),
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Round',
              keyRight: 'round',
              stepperRight: _CustomStepper(
                value: _values['round']!,
                onChanged: (val) => _updateValue('round', val),
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Fill',
              keyLeft: 'fill',
              stepperLeft: _CustomStepper(
                value: _values['fill']!,
                onChanged: (val) => _updateValue('fill', val),
                isFill: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Round Fill',
              keyRight: 'roundFill',
              stepperRight: _CustomStepper(
                value: _values['roundFill']!,
                onChanged: (val) => _updateValue('roundFill', val),
                isFill: true,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Small',
              keyLeft: 'small',
              stepperLeft: _CustomStepper(
                value: _values['small']!,
                onChanged: (val) => _updateValue('small', val),
                isSmall: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Small Round',
              keyRight: 'smallRound',
              stepperRight: _CustomStepper(
                value: _values['smallRound']!,
                onChanged: (val) => _updateValue('smallRound', val),
                isSmall: true,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Small Fill',
              keyLeft: 'smallFill',
              stepperLeft: _CustomStepper(
                value: _values['smallFill']!,
                onChanged: (val) => _updateValue('smallFill', val),
                isSmall: true,
                isFill: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Small Round Fill',
              keyRight: 'smallRoundFill',
              stepperRight: _CustomStepper(
                value: _values['smallRoundFill']!,
                onChanged: (val) => _updateValue('smallRoundFill', val),
                isSmall: true,
                isFill: true,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Large',
              keyLeft: 'large',
              stepperLeft: _CustomStepper(
                value: _values['large']!,
                onChanged: (val) => _updateValue('large', val),
                isLarge: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Large Round',
              keyRight: 'largeRound',
              stepperRight: _CustomStepper(
                value: _values['largeRound']!,
                onChanged: (val) => _updateValue('largeRound', val),
                isLarge: true,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Large Fill',
              keyLeft: 'largeFill',
              stepperLeft: _CustomStepper(
                value: _values['largeFill']!,
                onChanged: (val) => _updateValue('largeFill', val),
                isLarge: true,
                isFill: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Large Round Fill',
              keyRight: 'largeRoundFill',
              stepperRight: _CustomStepper(
                value: _values['largeRoundFill']!,
                onChanged: (val) => _updateValue('largeRoundFill', val),
                isLarge: true,
                isFill: true,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),

            // --- Raised ---
            _buildSectionTitle('Raised', primaryColor),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Default',
              keyLeft: 'raisedDefault',
              stepperLeft: _CustomStepper(
                value: _values['raisedDefault']!,
                onChanged: (val) => _updateValue('raisedDefault', val),
                isRaised: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Round',
              keyRight: 'raisedRound',
              stepperRight: _CustomStepper(
                value: _values['raisedRound']!,
                onChanged: (val) => _updateValue('raisedRound', val),
                isRaised: true,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Fill',
              keyLeft: 'raisedFill',
              stepperLeft: _CustomStepper(
                value: _values['raisedFill']!,
                onChanged: (val) => _updateValue('raisedFill', val),
                isRaised: true,
                isFill: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Round Fill',
              keyRight: 'raisedRoundFill',
              stepperRight: _CustomStepper(
                value: _values['raisedRoundFill']!,
                onChanged: (val) => _updateValue('raisedRoundFill', val),
                isRaised: true,
                isFill: true,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),

            // --- Colors ---
            _buildSectionTitle('Colors', primaryColor),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: '',
              keyLeft: 'red',
              stepperLeft: _CustomStepper(
                value: _values['red']!,
                onChanged: (val) => _updateValue('red', val),
                isFill: true,
                color: Colors.red,
                isDark: isDark,
              ),
              titleRight: '',
              keyRight: 'green',
              stepperRight: _CustomStepper(
                value: _values['green']!,
                onChanged: (val) => _updateValue('green', val),
                isFill: true,
                color: Colors.green,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: '',
              keyLeft: 'blue',
              stepperLeft: _CustomStepper(
                value: _values['blue']!,
                onChanged: (val) => _updateValue('blue', val),
                isFill: true,
                color: Colors.blue,
                isDark: isDark,
              ),
              titleRight: '',
              keyRight: 'pink',
              stepperRight: _CustomStepper(
                value: _values['pink']!,
                onChanged: (val) => _updateValue('pink', val),
                isFill: true,
                color: Colors.pink.shade300,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: '',
              keyLeft: 'yellow',
              stepperLeft: _CustomStepper(
                value: _values['yellow']!,
                onChanged: (val) => _updateValue('yellow', val),
                isFill: true,
                color: Colors.amber.shade700,
                isDark: isDark,
              ),
              titleRight: '',
              keyRight: 'orange',
              stepperRight: _CustomStepper(
                value: _values['orange']!,
                onChanged: (val) => _updateValue('orange', val),
                isFill: true,
                color: Colors.deepOrange,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: '',
              keyLeft: 'purple',
              stepperLeft: _CustomStepper(
                value: _values['purple']!,
                onChanged: (val) => _updateValue('purple', val),
                isFill: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: '',
              keyRight: 'black',
              stepperRight: _CustomStepper(
                value: _values['black']!,
                onChanged: (val) => _updateValue('black', val),
                isFill: true,
                color: Colors.black87,
                isDark: isDark,
              ),
            ),

            // --- Without input ---
            _buildSectionTitle('Without input element', primaryColor),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: '',
              keyLeft: 'noInput',
              stepperLeft: _CustomStepper(
                value: _values['noInput']!,
                onChanged: (val) => _updateValue('noInput', val),
                showInput: false,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: '',
              keyRight: 'noInputRound',
              stepperRight: _CustomStepper(
                value: _values['noInputRound']!,
                onChanged: (val) => _updateValue('noInputRound', val),
                showInput: false,
                isRound: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),

            // --- Min, max, step ---
            _buildSectionTitle('Min, max, step', primaryColor),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: '',
              keyLeft: 'minMax',
              stepperLeft: _CustomStepper(
                value: _values['minMax']!,
                onChanged: (val) => _updateValue('minMax', val),
                isFill: true,
                min: 0,
                max: 100,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: '',
              keyRight: 'step',
              stepperRight: _CustomStepper(
                value: _values['step']!,
                onChanged: (val) => _updateValue('step', val),
                isFill: true,
                step: 5,
                color: primaryColor,
                isDark: isDark,
              ),
            ),

            // --- Autorepeat ---
            _buildSectionTitle('Autorepeat (Tap & hold)', primaryColor),
            _buildDescription(
                'Pressing and holding one of its buttons increments or decrements the stepper\'s value repeatedly. With dynamic autorepeat, the rate of change depends on how long the user continues pressing the control.',
                textColor),
            _buildStepperRow(
              textColor: textColor,
              titleLeft: 'Default',
              keyLeft: 'autoDefault',
              stepperLeft: _CustomStepper(
                value: _values['autoDefault']!,
                onChanged: (val) => _updateValue('autoDefault', val),
                isFill: true,
                autorepeat: true,
                color: primaryColor,
                isDark: isDark,
              ),
              titleRight: 'Dynamic',
              keyRight: 'autoDynamic',
              stepperRight: _CustomStepper(
                value: _values['autoDynamic']!,
                onChanged: (val) => _updateValue('autoDynamic', val),
                isFill: true,
                autorepeat: true,
                color: primaryColor,
                isDark: isDark,
              ),
            ),

            // --- Wraps ---
            _buildSectionTitle('Wraps', primaryColor),
            _buildDescription(
                'In wraps mode incrementing beyond maximum value sets value to minimum value, likewise, decrementing below minimum value sets value to maximum value',
                textColor),
            _CustomStepper(
              value: _values['wraps']!,
              onChanged: (val) => _updateValue('wraps', val),
              isFill: true,
              min: 0,
              max: 10,
              wraps: true,
              color: primaryColor,
              isDark: isDark,
            ),

            // --- Custom value element ---
            _buildSectionTitle('Custom value element', primaryColor),
            _buildCustomValueRow(
                title: 'Apples',
                key: 'apples',
                textColor: textColor,
                primaryColor: primaryColor,
                isDark: isDark),
            _buildCustomValueRow(
                title: 'Oranges',
                key: 'oranges',
                textColor: textColor,
                primaryColor: primaryColor,
                isDark: isDark),

            // --- Custom value format ---
            _buildSectionTitle('Custom value format', primaryColor),
            Text('Meeting starts in ${_values['meeting']!.toInt()} minutes',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            _CustomStepper(
              value: _values['meeting']!,
              onChanged: (val) => _updateValue('meeting', val),
              isFill: true,
              min: 0,
              max: 60,
              step: 15,
              color: primaryColor,
              isDark: isDark,
            ),

            // --- Manual input ---
            _buildSectionTitle('Manual input', primaryColor),
            _buildDescription(
                'It is possible to enter value manually from keyboard or mobile keypad. When click on input field, stepper enter into manual input mode, which allow type value from keyboard and check fractional part with defined accurancy. Click outside or enter Return key, ending manual mode.',
                textColor),
            _CustomStepper(
              value: _values['manual']!,
              onChanged: (val) => _updateValue('manual', val),
              isFill: true,
              color: primaryColor,
              isDark: isDark,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 🔽 WIDGET STEPPER KUSTOM 🔽 ---
// -----------------------------------------------------------------
class _CustomStepper extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final Function(double) onChanged;

  // Styling
  final Color? color;
  final bool isFill;
  final bool isRound;
  final bool isSmall;
  final bool isLarge;
  final bool isRaised;
  final bool showInput;
  final bool wraps;
  final bool autorepeat;
  final bool isDark; // Tambahan untuk deteksi mode gelap

  const _CustomStepper({
    Key? key,
    required this.value,
    required this.onChanged,
    this.min = -double.infinity,
    this.max = double.infinity,
    this.step = 1,
    this.color, // Color bisa null
    this.isFill = false,
    this.isRound = false,
    this.isSmall = false,
    this.isLarge = false,
    this.isRaised = false,
    this.showInput = true,
    this.wraps = false,
    this.autorepeat = false,
    required this.isDark, // Wajib di-pass
  }) : super(key: key);

  @override
  State<_CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<_CustomStepper> {
  Timer? _timer;

  // --- Logika Perubahan Nilai ---
  void _updateValue(bool increment) {
    double newValue = widget.value;

    if (increment) {
      newValue += widget.step;
    } else {
      newValue -= widget.step;
    }

    // Cek Batas
    if (newValue > widget.max) {
      newValue = widget.wraps ? widget.min : widget.max;
    }
    if (newValue < widget.min) {
      newValue = widget.wraps ? widget.max : widget.min;
    }

    widget.onChanged(newValue);
  }

  // --- Logika Autorepeat ---
  void _onLongPressStart(bool increment) {
    if (!widget.autorepeat) return;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateValue(increment);
    });
  }

  void _onLongPressEnd() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan warna utama (jika null, default ke ungu)
    final mainColor = widget.color ?? const Color(0xFF9147FF);

    // --- Menentukan Ukuran ---
    double height = 32;
    double iconSize = 20;
    double fontSize = 16;
    if (widget.isSmall) {
      height = 28;
      iconSize = 18;
    }
    if (widget.isLarge) {
      height = 44;
      iconSize = 24;
      fontSize = 20;
    }

    // --- Menentukan Warna ---
    // Background tombol
    Color buttonColor;
    if (widget.isFill) {
      buttonColor = mainColor;
    } else {
      // Jika mode gelap dan tidak fill, button transparan atau mengikuti card color
      buttonColor = widget.isDark ? Colors.transparent : Colors.white;
    }

    // Icon Color
    Color iconColor;
    if (widget.isFill) {
      iconColor = Colors.white;
    } else {
      iconColor = mainColor; // Icon mengikuti warna tema
    }

    // Text Color (PERBAIKAN DI SINI)
    Color textColor;
    if (widget.isFill) {
      // Jika tombol solid, background biasanya terang (putih), jadi angka harus hitam agar kontras
      textColor = Colors.black87;
    } else {
      // Jika tombol outline, teks mengikuti tema (putih di dark, hitam di light)
      textColor = widget.isDark ? Colors.white : Colors.black87;
    }

    // Border Color
    Color borderColor = widget.isDark ? Colors.white24 : Colors.grey.shade300;

    // --- Menentukan Bentuk ---
    double buttonRadius = widget.isRound ? height / 2 : 6.0;
    BorderRadiusGeometry outerRadius = widget.isRound
        ? BorderRadius.circular(height / 2)
        : BorderRadius.circular(6.0);

    Widget stepperBody = Container(
      height: height,
      decoration: BoxDecoration(
        color: widget.isFill
            ? Colors.transparent
            : (widget.isDark ? Colors.transparent : Colors.white),
        borderRadius: outerRadius,
        border: widget.isFill ? null : Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Tombol Kurang ---
          GestureDetector(
            onTap: () => _updateValue(false),
            onLongPressStart: (_) => _onLongPressStart(false),
            onLongPressEnd: (_) => _onLongPressEnd(),
            child: Container(
              width: height * 1.2,
              height: height,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(buttonRadius),
                  bottomLeft: Radius.circular(buttonRadius),
                ),
              ),
              child: Icon(Icons.remove, color: iconColor, size: iconSize),
            ),
          ),

          // --- Input Value ---
          if (widget.showInput)
            Container(
              height: height,
              constraints: const BoxConstraints(minWidth: 40),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: widget.isFill
                  ? Colors.white
                  : Colors.transparent, // Background angka putih jika fill
              alignment: Alignment.center,
              child: Text(
                widget.value.toInt().toString(),
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color:
                        textColor // Menggunakan logika textColor yang sudah diperbaiki
                    ),
              ),
            ),

          // --- Tombol Tambah ---
          GestureDetector(
            onTap: () => _updateValue(true),
            onLongPressStart: (_) => _onLongPressStart(true),
            onLongPressEnd: (_) => _onLongPressEnd(),
            child: Container(
              width: height * 1.2,
              height: height,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(buttonRadius),
                  bottomRight: Radius.circular(buttonRadius),
                ),
              ),
              child: Icon(Icons.add, color: iconColor, size: iconSize),
            ),
          ),
        ],
      ),
    );

    // --- Efek Raised (Shadow) ---
    if (widget.isRaised) {
      return Material(
        elevation: 2.0,
        color: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.3),
        borderRadius: outerRadius,
        child: stepperBody,
      );
    }

    return stepperBody;
  }
}
