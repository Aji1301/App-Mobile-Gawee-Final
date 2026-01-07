import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  // --- State Warna untuk setiap Bagian ---
  Color _wheelColor = const Color(0xFF00FF00);
  Color _sbColor = const Color(0xFFFF0000);
  Color _hsColor = const Color(0xFFFF0000);
  Color _rgbColor = const Color(0xFF0000FF);
  Color _rgbaColor = const Color(0xFFFF00FF);
  // Color _hsbColor = const Color(0xFF00FF00); // Unused
  // Color _barColor = const Color(0xFF0000FF); // Unused
  Color _paletteColor = const Color(0xFFFFEBEE);
  Color _proColor = const Color(0xFF00FFFF);

  // State untuk Inline Picker
  Color _inlineColor = const Color(0xFF418A37);

  // --- Helper: Judul (Dinamis) ---
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

  // --- Helper: Deskripsi (Dinamis) ---
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

  // --- Helper: Input Field Warna (Dinamis) ---
  Widget _buildColorField({
    required Color color,
    required VoidCallback onTap,
    required Color fieldColor,
    required Color borderColor,
    required Color textColor,
    bool showAlpha = false,
  }) {
    String colorString;
    if (showAlpha) {
      colorString =
          'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.opacity.toStringAsFixed(1)})';
    } else {
      colorString =
          '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: fieldColor, // Mengikuti tema
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor), // Mengikuti tema
        ),
        child: Row(
          children: [
            // Kotak Warna Preview
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ]),
            ),
            const SizedBox(width: 12),
            // Teks Kode Warna
            Text(
              colorString,
              style: TextStyle(
                fontSize: 16,
                color: textColor, // Mengikuti tema
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Fungsi: Menampilkan Dialog Picker (Dinamis) ---
  void _showColorPickerDialog({
    required BuildContext context,
    required Color currentColor,
    required ValueChanged<Color> onColorChanged,
    required Widget pickerWidget,
  }) {
    // Ambil tema di dalam dialog context
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // Warna Dialog
    final dialogBg = isDark ? themeProvider.cardColor : Colors.white;
    // final textColor = isDark ? Colors.white : Colors.black87; // Unused

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBg, // Background dialog dinamis
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bungkus picker dengan Theme agar teks di dalamnya terlihat
                Theme(
                  data: isDark ? ThemeData.dark() : ThemeData.light(),
                  child: pickerWidget,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done',
                  style: TextStyle(color: primaryColor)), // Tombol done dinamis
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
    final subTextColor = isDark ? Colors.white60 : Colors.black54;

    // Warna Field & Divider
    final fieldColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBgColor,
        foregroundColor: textColor,
        title: const Text('Color Picker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: dividerColor, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Framework7 comes with ultimate modular Color Picker component that allows to create color picker with limitless combinations of color modules.',
              style: TextStyle(fontSize: 15, height: 1.4, color: textColor),
            ),

            // 1. Color Wheel
            _buildSectionTitle('Color Wheel', primaryColor),
            _buildDescription(
                'Minimal example with color wheel in Popover', subTextColor),
            _buildColorField(
              color: _wheelColor,
              fieldColor: fieldColor,
              borderColor: borderColor,
              textColor: textColor,
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: _wheelColor,
                onColorChanged: (c) => setState(() => _wheelColor = c),
                pickerWidget: HueRingPicker(
                  pickerColor: _wheelColor,
                  onColorChanged: (c) => setState(() => _wheelColor = c),
                  enableAlpha: false,
                  displayThumbColor: true,
                ),
              ),
            ),

            // 2. Saturation-Brightness Spectrum
            _buildSectionTitle('Saturation-Brightness Spectrum', primaryColor),
            _buildDescription(
                'SB Spectrum + Hue Slider in Popover', subTextColor),
            _buildColorField(
              color: _sbColor,
              fieldColor: fieldColor,
              borderColor: borderColor,
              textColor: textColor,
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: _sbColor,
                onColorChanged: (c) => setState(() => _sbColor = c),
                pickerWidget: ColorPicker(
                  pickerColor: _sbColor,
                  onColorChanged: (c) => setState(() => _sbColor = c),
                  enableAlpha: false,
                  labelTypes: const [],
                  pickerAreaHeightPercent: 0.7,
                ),
              ),
            ),

            // 3. Hue-Saturation Spectrum
            _buildSectionTitle('Hue-Saturation Spectrum', primaryColor),
            _buildDescription(
                'HS Spectrum + Brightness Slider in Popover', subTextColor),
            _buildColorField(
              color: _hsColor,
              fieldColor: fieldColor,
              borderColor: borderColor,
              textColor: textColor,
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: _hsColor,
                onColorChanged: (c) => setState(() => _hsColor = c),
                pickerWidget: ColorPicker(
                  pickerColor: _hsColor,
                  onColorChanged: (c) => setState(() => _hsColor = c),
                  enableAlpha: false,
                  labelTypes: const [],
                ),
              ),
            ),

            // 4. RGB Sliders
            _buildSectionTitle('RGB Sliders', primaryColor),
            _buildDescription(
                'RGB sliders with labels and values in Popover', subTextColor),
            _buildColorField(
              color: _rgbColor,
              fieldColor: fieldColor,
              borderColor: borderColor,
              textColor: textColor,
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: _rgbColor,
                onColorChanged: (c) => setState(() => _rgbColor = c),
                pickerWidget: SlidePicker(
                  pickerColor: _rgbColor,
                  onColorChanged: (c) => setState(() => _rgbColor = c),
                  enableAlpha: false,
                  displayThumbColor: true,
                  showParams: true,
                  showIndicator: false,
                  sliderSize: const Size(250, 40),
                ),
              ),
            ),

            // 5. RGBA Sliders
            _buildSectionTitle('RGBA Sliders', primaryColor),
            _buildDescription(
                'RGB sliders + Alpha Slider with labels and values',
                subTextColor),
            _buildColorField(
              color: _rgbaColor,
              fieldColor: fieldColor,
              borderColor: borderColor,
              textColor: textColor,
              showAlpha: true,
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: _rgbaColor,
                onColorChanged: (c) => setState(() => _rgbaColor = c),
                pickerWidget: SlidePicker(
                  pickerColor: _rgbaColor,
                  onColorChanged: (c) => setState(() => _rgbaColor = c),
                  enableAlpha: true,
                  displayThumbColor: true,
                  showParams: true,
                ),
              ),
            ),

            // 6. Palette
            _buildSectionTitle('Palette', primaryColor),
            _buildDescription(
                'Palette opened in Sheet modal on phone and Popover on larger screens',
                subTextColor),
            _buildColorField(
              color: _paletteColor,
              fieldColor: fieldColor,
              borderColor: borderColor,
              textColor: textColor,
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: _paletteColor,
                onColorChanged: (c) => setState(() => _paletteColor = c),
                pickerWidget: BlockPicker(
                  pickerColor: _paletteColor,
                  onColorChanged: (c) => setState(() => _paletteColor = c),
                ),
              ),
            ),

            // 7. Pro Mode
            _buildSectionTitle('Pro Mode', primaryColor),
            _buildDescription(
                'Current Color + HSB Sliders + RGB sliders + Alpha Slider + HEX + Palette',
                subTextColor),
            _buildColorField(
              color: _proColor,
              fieldColor: fieldColor,
              borderColor: borderColor,
              textColor: textColor,
              showAlpha: true,
              onTap: () => _showColorPickerDialog(
                context: context,
                currentColor: _proColor,
                onColorChanged: (c) => setState(() => _proColor = c),
                pickerWidget: ColorPicker(
                  pickerColor: _proColor,
                  onColorChanged: (c) => setState(() => _proColor = c),
                  enableAlpha: true,
                  displayThumbColor: true,
                  showLabel: true,
                  paletteType: PaletteType.hsv,
                  pickerAreaHeightPercent: 0.7,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Divider(thickness: 1, color: dividerColor),

            // 8. INLINE COLOR PICKER
            _buildSectionTitle('Inline Color Picker', primaryColor),
            _buildDescription('SB Spectrum + HSB Sliders', subTextColor),

            Container(
              decoration: BoxDecoration(
                color: fieldColor, // Background inline picker dinamis
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  // Header Info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            'HEX:',
                            '#${_inlineColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                            textColor),
                        _buildInfoRow('Alpha:',
                            _inlineColor.opacity.toStringAsFixed(2), textColor),
                        _buildInfoRow('Red:', '${_inlineColor.red}', textColor),
                        _buildInfoRow(
                            'Green:', '${_inlineColor.green}', textColor),
                        _buildInfoRow(
                            'Blue:', '${_inlineColor.blue}', textColor),
                      ],
                    ),
                  ),

                  // Picker Widget Inline
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      // Paksa tema agar teks di dalam picker terlihat
                      data: isDark ? ThemeData.dark() : ThemeData.light(),
                      child: ColorPicker(
                        pickerColor: _inlineColor,
                        onColorChanged: (c) => setState(() => _inlineColor = c),
                        colorPickerWidth: 300,
                        pickerAreaHeightPercent: 0.6,
                        enableAlpha: true,
                        displayThumbColor: true,
                        labelTypes: const [],
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

  // Helper kecil untuk baris info di Inline Picker (Dinamis)
  Widget _buildInfoRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
              width: 60,
              child: Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textColor))),
          Text(value,
              style: TextStyle(
                  fontSize: 13, fontFamily: 'monospace', color: textColor)),
        ],
      ),
    );
  }
}
