// lib/progress_bar_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Ensure this path matches your project structure

class ProgressBarPage extends StatefulWidget {
  const ProgressBarPage({super.key});

  @override
  State<ProgressBarPage> createState() => _ProgressBarPageState();
}

class _ProgressBarPageState extends State<ProgressBarPage> {
  // State for Determinate Progress Bar
  double _progressValue = 0.0; // Value 0.0 to 1.0 (0% to 100%)

  // State for 'Inline determinate load & hide' button
  bool _isInlineLoading = false;

  // State for Overlay Progress Bar
  bool _isOverlayLoading = false;

  // State for Infinite Overlay Progress Bar (Multi-color)
  bool _isInfiniteMultiColorOverlayLoading = false;

  // Percentage values for buttons
  final List<double> _percentageValues = [
    0.1,
    0.3,
    0.5,
    1.0
  ]; // 10%, 30%, 50%, 100%

  // --- Helper: Dynamic Section Title ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor, // Follows theme
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Helper: Dynamic Description ---
  Widget _buildDescription(String text, Color textColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        height: 1.4,
        color: textColor, // Follows theme
      ),
    );
  }

  // --- Helper: Dynamic Button ---
  Widget _buildDynamicButton({
    required String text,
    required VoidCallback onPressed,
    required Color buttonColor,
    bool isFullWidth = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor, // Follows theme
          minimumSize: Size(isFullWidth ? double.infinity : 0, 48),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- Loading Logic (Determinate) ---
  void _startDeterminateLoading({VoidCallback? stopCallback}) async {
    for (int i = 0; i <= 100; i += 10) {
      if (!mounted) return;

      if (stopCallback != null && !_isInlineLoading && i > 0) return;

      setState(() {
        _progressValue = i / 100;
      });
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (stopCallback != null) {
      stopCallback();
    }
  }

  // --- Loading Logic (Determinate Overlay) ---
  void _showDeterminateOverlay(BuildContext context, Color primaryColor) {
    if (_isOverlayLoading) return;

    setState(() {
      _isOverlayLoading = true;
      _progressValue = 0.0;
    });

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: LinearProgressIndicator(
          value: _progressValue,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    _startDeterminateLoading(stopCallback: () {
      overlayEntry.remove();
      setState(() {
        _isOverlayLoading = false;
      });
    });
  }

  // --- Loading Logic (Infinite Multi-color Overlay) ---
  void _showInfiniteMultiColorOverlay(BuildContext context) {
    if (_isInfiniteMultiColorOverlayLoading) return;

    setState(() {
      _isInfiniteMultiColorOverlayLoading = true;
    });

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: LinearProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Simulation
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
      setState(() {
        _isInfiniteMultiColorOverlayLoading = false;
      });
    });
  }

  // --- Widget: Inline Determinate Progress Bar (Dynamic) ---
  Widget _buildInlineDeterminateProgressBar(Color primaryColor,
      Color dividerColor, Color cardColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar Line
        SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            value: _progressValue,
            backgroundColor: dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
        const SizedBox(height: 16),

        // Percentage Buttons
        Container(
          decoration: BoxDecoration(
            color: cardColor, // Dynamic card color
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: dividerColor, width: 1.0),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_percentageValues.length, (index) {
                final double value = _percentageValues[index];
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _progressValue = value;
                        _isInlineLoading = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        border: index < _percentageValues.length - 1
                            ? Border(
                                right:
                                    BorderSide(color: dividerColor, width: 1.0))
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${(value * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 16,
                            // Selected text color follows primary theme
                            color: value <= _progressValue
                                ? primaryColor
                                : textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget: Inline Load & Hide (Dynamic) ---
  Widget _buildInlineLoadAndHide(Color primaryColor, Color dividerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isInlineLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        _buildDynamicButton(
          text: 'Start Loading',
          buttonColor: primaryColor,
          onPressed: _isInlineLoading
              ? () {}
              : () {
                  setState(() {
                    _isInlineLoading = true;
                    _progressValue = 0.0;
                  });
                  _startDeterminateLoading(stopCallback: () {
                    setState(() {
                      _isInlineLoading = false;
                    });
                  });
                },
        ),
      ],
    );
  }

  // --- Widget: Color Progress Bar (Dynamic) ---
  Widget _buildColorProgressBar(Color color, Color dividerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            value: 0.8, // Dummy value 80%
            backgroundColor: dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch Theme Data
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Define Dynamic Colors
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;

    // Text, Icon & Divider Colors
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
            border: Border(
              bottom: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Progress Bar'),
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
            // --- Intro Description ---
            _buildDescription(
              'In addition to Preloader, Framework7 also comes with fancy animated determinate and infinite/indeterminate progress bars to indicate some activity.',
              textColor,
            ),

            // --- Section 1: Determinate Progress Bar ---
            _buildSectionTitle('Determinate Progress Bar', primaryColor),
            _buildDescription(
              'When progress bar is determinate it indicates how long an operation will take when the percentage complete is detectable.',
              textColor,
            ),

            _buildSectionTitle(
                'Inline determinate progress bar:', primaryColor),
            _buildInlineDeterminateProgressBar(
                primaryColor, dividerColor, cardColor, textColor),

            _buildSectionTitle('Inline determinate load & hide:', primaryColor),
            _buildInlineLoadAndHide(primaryColor, dividerColor),

            _buildSectionTitle(
                'Overlay with determinate progress bar on top of the app:',
                primaryColor),
            _buildDynamicButton(
              text: 'Start Loading',
              buttonColor: primaryColor,
              onPressed: _isOverlayLoading
                  ? () {}
                  : () => _showDeterminateOverlay(context, primaryColor),
            ),

            // --- Section 2: Infinite Progress Bar ---
            _buildSectionTitle('Infinite Progress Bar', primaryColor),
            _buildDescription(
              'When progress bar is infinite/indeterminate it requests that the user wait while something finishes when it\'s not necessary to indicate how long it will take.',
              textColor,
            ),

            _buildSectionTitle('Inline infinite progress bar', primaryColor),
            // Progress Bar Infinite (Primary Color)
            SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                backgroundColor: dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),

            _buildSectionTitle(
                'Multi-color infinite progress bar', primaryColor),
            // Progress Bar Infinite Multi-color (Red Simulation)
            SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                backgroundColor: dividerColor,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),

            _buildSectionTitle(
                'Overlay with infinite progress bar on top of the app:',
                primaryColor),
            _buildDynamicButton(
              text: 'Start Loading',
              buttonColor: primaryColor,
              onPressed: () {
                // Reusing determinate overlay logic for dismissible example
                _showDeterminateOverlay(context, primaryColor);
              },
            ),

            _buildSectionTitle(
                'Overlay with infinite multi-color progress bar on top of the app:',
                primaryColor),
            _buildDynamicButton(
              text: 'Start Loading',
              buttonColor: primaryColor,
              onPressed: _isInfiniteMultiColorOverlayLoading
                  ? () {}
                  : () => _showInfiniteMultiColorOverlay(context),
            ),

            // --- Section 3: Colors ---
            _buildSectionTitle('Colors', primaryColor),
            _buildColorProgressBar(Colors.blue, dividerColor),
            _buildColorProgressBar(Colors.red, dividerColor),
            _buildColorProgressBar(Colors.pink.shade300, dividerColor),
            _buildColorProgressBar(Colors.green, dividerColor),
            _buildColorProgressBar(Colors.deepOrange, dividerColor),
            _buildColorProgressBar(Colors.brown, dividerColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
