// lib/range_slider_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class RangeSliderPage extends StatefulWidget {
  const RangeSliderPage({super.key});

  @override
  State<RangeSliderPage> createState() => _RangeSliderPageState();
}

class _RangeSliderPageState extends State<RangeSliderPage> {
  // --- State untuk setiap slider ---
  double _volumeValue = 50.0;
  double _brightnessValue = 50.0;
  RangeValues _priceRangeValues =
      const RangeValues(200, 400); // Untuk "Price Filter"
  double _scaleValue = 20.0;

  // State untuk slider vertikal
  double _verticalVal1 = 20.0;
  double _verticalVal2 = 40.0;
  double _verticalVal3 = 60.0;
  double _verticalVal4 = 80.0;

  // State untuk slider vertikal terbalik
  double _verticalReversedVal1 = 80.0;
  double _verticalReversedVal2 = 60.0;
  double _verticalReversedVal3 = 40.0;
  double _verticalReversedVal4 = 20.0;

  // --- Helper: Judul Bagian (Dinamis) ---
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

  // --- Helper: Slider Vertikal (Dinamis) ---
  Widget _buildVerticalSlider(double value, Color activeColor,
      Color inactiveColor, ValueChanged<double> onChanged) {
    return SizedBox(
      height: 150, // Tentukan tinggi untuk slider vertikal
      child: RotatedBox(
        quarterTurns: 3, // Putar 270 derajat (ke kiri)
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            thumbColor: activeColor,
            inactiveTrackColor: inactiveColor, // Warna track non-aktif dinamis
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: onChanged,
          ),
        ),
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

    // Warna Teks & Icon
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white54 : Colors.grey;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Slider Inactive
    final inactiveSliderColor = isDark ? Colors.white24 : Colors.grey.shade300;

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
            title: const Text('Range Slider'),
            centerTitle: true,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Volume ---
            _buildSectionTitle('Volume', primaryColor),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.volume_down, color: iconColor),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: primaryColor,
                      thumbColor: primaryColor,
                      inactiveTrackColor: inactiveSliderColor,
                    ),
                    child: Slider(
                      value: _volumeValue,
                      min: 0,
                      max: 100,
                      onChanged: (newValue) {
                        setState(() => _volumeValue = newValue);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.volume_up, color: iconColor),
                ),
              ],
            ),

            // --- Brightness ---
            _buildSectionTitle('Brightness', primaryColor),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.settings, color: iconColor),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor:
                          Colors.orange, // Brightness biasanya orange/kuning
                      thumbColor: Colors.orange,
                      inactiveTrackColor:
                          isDark ? Colors.white12 : Colors.orange.shade100,
                    ),
                    child: Slider(
                      value: _brightnessValue,
                      min: 0,
                      max: 100,
                      onChanged: (newValue) {
                        setState(() => _brightnessValue = newValue);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.settings, color: iconColor),
                ),
              ],
            ),

            // --- Price Filter ---
            _buildSectionTitle('Price Filter', primaryColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${_priceRangeValues.start.round()} - ${_priceRangeValues.end.round()}',
                    style: TextStyle(
                        fontSize: 16, color: textColor.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.attach_money, color: iconColor),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.green, // Uang biasanya hijau
                      thumbColor: Colors.green,
                      inactiveTrackColor:
                          isDark ? Colors.white12 : Colors.green.shade100,
                    ),
                    child: RangeSlider(
                      values: _priceRangeValues,
                      min: 0,
                      max: 1000,
                      divisions: 100,
                      labels: RangeLabels(
                        _priceRangeValues.start.round().toString(),
                        _priceRangeValues.end.round().toString(),
                      ),
                      onChanged: (newValues) {
                        setState(() => _priceRangeValues = newValues);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.attach_money, color: iconColor),
                ),
              ],
            ),

            // --- With Scale ---
            _buildSectionTitle('With Scale', primaryColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: primaryColor,
                  thumbColor: primaryColor,
                  inactiveTrackColor: inactiveSliderColor,
                  valueIndicatorColor: primaryColor, // Warna label saat digeser
                ),
                child: Slider(
                  value: _scaleValue,
                  min: 0,
                  max: 100,
                  divisions: 5,
                  label: _scaleValue.round().toString(),
                  onChanged: (newValue) {
                    setState(() => _scaleValue = newValue);
                  },
                ),
              ),
            ),

            // --- Vertical ---
            _buildSectionTitle('Vertical', primaryColor),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVerticalSlider(
                      _verticalVal1,
                      primaryColor,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalVal1 = val)),
                  _buildVerticalSlider(
                      _verticalVal2,
                      primaryColor,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalVal2 = val)),
                  _buildVerticalSlider(
                      _verticalVal3,
                      primaryColor,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalVal3 = val)),
                  _buildVerticalSlider(
                      _verticalVal4,
                      primaryColor,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalVal4 = val)),
                ],
              ),
            ),

            // --- Vertical Reversed ---
            _buildSectionTitle('Vertical Reversed', primaryColor),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVerticalSlider(
                      _verticalReversedVal1,
                      Colors.red,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalReversedVal1 = val)),
                  _buildVerticalSlider(
                      _verticalReversedVal2,
                      Colors.red,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalReversedVal2 = val)),
                  _buildVerticalSlider(
                      _verticalReversedVal3,
                      Colors.red,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalReversedVal3 = val)),
                  _buildVerticalSlider(
                      _verticalReversedVal4,
                      Colors.red,
                      inactiveSliderColor,
                      (val) => setState(() => _verticalReversedVal4 = val)),
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
