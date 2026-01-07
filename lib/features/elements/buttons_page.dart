import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  // --- State untuk Preloader Buttons ---
  bool _isLoading1 = false;
  bool _isLoading2 = false;

  // --- FUNGSI KLIK & SIMULASI LOADING ---
  void _onLoadButtonPressed(int buttonIndex) async {
    if ((buttonIndex == 1 && _isLoading1) ||
        (buttonIndex == 2 && _isLoading2)) {
      return;
    }

    setState(() {
      if (buttonIndex == 1) {
        _isLoading1 = true;
      } else {
        _isLoading2 = true;
      }
    });

    // Simulasi proses asinkron selama 3 detik
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        if (buttonIndex == 1) {
          _isLoading1 = false;
        } else {
          _isLoading2 = false;
        }
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

    // Warna Latar Belakang
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final headerColor = isDark ? Colors.white : Colors.black;

    // Warna Konten & Border
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final contentBlockColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final contentBlockBorderColor =
        isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Tonal (Transparan dari primary)
    final tonalColor = primaryColor.withOpacity(0.15);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Header Halaman) ---
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
            foregroundColor: headerColor, // Warna teks/ikon dinamis
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Buttons',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ----------------------------------------------------
            // 1. Usual Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Usual Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [
                _buildButtonRow(
                  style: ButtonStyle.usual,
                  fillColor: Colors.transparent,
                  textColor: primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 2. Tonal Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Tonal Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [
                _buildButtonRow(
                  style: ButtonStyle.tonal,
                  fillColor: tonalColor, // Warna tonal dinamis
                  textColor: primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 3. Fill Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Fill Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [
                _buildButtonRow(
                  style: ButtonStyle.fill,
                  fillColor: primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 4. Outline Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Outline Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [
                _buildButtonRow(
                  style: ButtonStyle.outline,
                  fillColor: Colors.transparent,
                  textColor: primaryColor,
                  borderColor: primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 5. Raised Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Raised Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [_buildRaisedButtonSection(primaryColor, isDark)],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 6. Large Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Large Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [_buildLargeButtonSection(primaryColor)],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 7. Small Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Small Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [
                _buildSmallButtonSection(primaryColor,
                    overrideSmall: true, isDark: isDark),
              ],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 8. Color Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Color Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [_buildColorButtonSection()],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 9. Preloader Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Preloader Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [_buildPreloaderButtonSection(primaryColor)],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 10. Color Fill Buttons
            // ----------------------------------------------------
            _buildSectionTitle('Color Fill Buttons', primaryColor),
            _buildContentBlock(
              contentBlockColor,
              contentBlockBorderColor,
              children: [_buildColorFillButtonSection(isDark)],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PEMBANTU ---

  Widget _buildContentBlock(Color bgColor, Color borderColor,
      {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    );
  }

  // 5. Raised Buttons Section
  Widget _buildRaisedButtonSection(Color primaryColor, bool isDark) {
    // Warna tombol biasa: Putih di light, Abu gelap di dark
    final normalBtnColor = isDark ? Colors.grey[800]! : Colors.white;
    final normalTextColor = isDark ? Colors.white : Colors.black87;

    return Column(
      children: [
        Row(
          children: <Widget>[
            _buildButtonExpanded(
              'Button',
              ButtonStyle.raised,
              fillColor: normalBtnColor,
              textColor: normalTextColor,
              isRaised: true,
            ),
            _buildButtonExpanded(
              'Fill',
              ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              isRaised: true,
            ),
            _buildButtonExpanded(
              'Outline',
              ButtonStyle.outline,
              fillColor: normalBtnColor,
              textColor: primaryColor,
              borderColor: primaryColor,
              isRaised: true,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            _buildButtonExpanded(
              'Round',
              ButtonStyle.raised,
              fillColor: normalBtnColor,
              textColor: normalTextColor,
              isRound:
                  false, // isRound false di method ini tetap membuat round karena default border radius di method
              isRaised: true,
            ),
            _buildButtonExpanded(
              'Fill',
              ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              isRaised: true,
              isRound: false,
            ),
            _buildButtonExpanded(
              'Outline',
              ButtonStyle.outline,
              fillColor: normalBtnColor,
              textColor: primaryColor,
              borderColor: primaryColor,
              isRaised: true,
              isRound: false,
            ),
          ],
        ),
      ],
    );
  }

  // 6. Large Buttons Section
  Widget _buildLargeButtonSection(Color primaryColor) {
    return Column(
      children: [
        Row(
          children: [
            _buildButtonExpanded(
              'BUTTON',
              ButtonStyle.usual,
              textColor: primaryColor,
              height: 48,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
            _buildButtonExpanded(
              'FILL',
              ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              height: 48,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildButtonExpanded(
              'RAISED',
              ButtonStyle.raised,
              textColor: primaryColor,
              isRaised: true,
              height: 48,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
            _buildButtonExpanded(
              'RAISED FILL',
              ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              isRaised: true,
              height: 48,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildButtonExpanded(
              'ROUND',
              ButtonStyle.usual,
              textColor: primaryColor,
              isRound: false,
              height: 48,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
            _buildButtonExpanded(
              'ROUND FILL',
              ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              isRound: false,
              height: 48,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ],
        ),
      ],
    );
  }

  // Button Row Standard
  Widget _buildButtonRow({
    required ButtonStyle style,
    required Color fillColor,
    required Color textColor,
    Color borderColor = Colors.transparent,
    double height = 40.0,
  }) {
    final buttonLabels = ['Button', 'Button', 'Round'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: buttonLabels.map((label) {
          const bool isRoundShape = false;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildCustomButton(
                label,
                style: style,
                fillColor: fillColor,
                textColor: textColor,
                borderColor: borderColor,
                isRound: isRoundShape,
                height: height,
                onPressed: () {
                  print('$label (${style.name}) clicked!');
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 7. Small Buttons Section
  Widget _buildSmallButtonSection(Color primaryColor,
      {bool overrideSmall = false, bool isDark = false}) {
    final bool smallFlag = !overrideSmall;
    const double defaultHeight = 40.0;

    final normalTextColor = isDark ? Colors.white : Colors.black87;

    return Column(
      children: [
        Row(
          children: [
            _buildButtonExpanded(
              'Button',
              ButtonStyle.usual,
              textColor: normalTextColor,
              isSmall: smallFlag,
              height: defaultHeight,
            ),
            _buildButtonExpanded(
              'Outline',
              ButtonStyle.outline,
              textColor: primaryColor,
              borderColor: primaryColor,
              isSmall: smallFlag,
              height: defaultHeight,
            ),
            _buildButtonExpanded(
              'Fill',
              ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              isSmall: smallFlag,
              height: defaultHeight,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildButtonExpanded(
              'Button',
              ButtonStyle.usual,
              textColor: normalTextColor,
              isSmall: smallFlag,
              height: defaultHeight,
            ),
            _buildButtonExpanded(
              'Outline',
              ButtonStyle.outline,
              textColor: primaryColor,
              borderColor: primaryColor,
              isSmall: smallFlag,
              height: defaultHeight,
            ),
            _buildButtonExpanded(
              'Fill',
              ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              isSmall: smallFlag,
              height: defaultHeight,
            ),
          ],
        ),
      ],
    );
  }

  // 8. Color Buttons Section
  Widget _buildColorButtonSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: _buildColorButtonRow(['Red', 'Green', 'Blue']),
    );
  }

  Widget _buildColorButtonRow(List<String> colors) {
    final colorMap = {
      'Red': Colors.red,
      'Green': Colors.green[800]!,
      'Blue': Colors.blue,
    };

    return Row(
      children: colors.map((colorName) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildCustomButton(
              colorName,
              style: ButtonStyle.usual,
              fillColor: Colors.transparent,
              textColor: colorMap[colorName]!,
              onPressed: () {
                print('$colorName clicked!');
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  // 9. Preloader Buttons Section
  Widget _buildPreloaderButtonSection(Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 0),
            child: _buildCustomButton(
              'LOAD',
              style: ButtonStyle.usual,
              textColor: primaryColor,
              borderColor: Colors.transparent,
              height: 48.0,
              isPreloading: _isLoading1,
              onPressed: () => _onLoadButtonPressed(1),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 0),
            child: _buildCustomButton(
              'LOAD',
              style: ButtonStyle.fill,
              fillColor: primaryColor,
              textColor: Colors.white,
              isRaised: true,
              height: 48.0,
              isPreloading: _isLoading2,
              onPressed: () => _onLoadButtonPressed(2),
            ),
          ),
        ),
      ],
    );
  }

  // 10. Color Fill Buttons Section
  Widget _buildColorFillButtonSection(bool isDark) {
    final colorData = {
      'Red': Colors.red[800]!,
      'Green': Colors.green[700]!,
      'Blue': Colors.blue[800]!,
      'Pink': Colors.pink,
      'Yellow': Colors.yellow[800]!,
      'Orange': Colors.orange,
      'Black': Colors.black,
      'White': Colors.white,
    };
    final colorNames = colorData.keys.toList();

    return Column(
      children: [
        Row(
          children: colorNames
              .sublist(0, 3)
              .map((name) =>
                  _buildColorFillButtonExpanded(name, colorData[name]!, isDark))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: colorNames
              .sublist(3, 6)
              .map((name) =>
                  _buildColorFillButtonExpanded(name, colorData[name]!, isDark))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildColorFillButtonExpanded(
                colorNames[6], colorData[colorNames[6]]!, isDark), // Black
            _buildColorFillButtonExpanded(
                colorNames[7], colorData[colorNames[7]]!, isDark), // White
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildColorFillButtonExpanded(String text, Color color, bool isDark) {
    // Teks hitam jika tombol putih, sebaliknya putih.
    // Jika dark mode dan tombol putih, teks hitam.
    final textColor = color == Colors.white ? Colors.black87 : Colors.white;

    // Border hanya jika tombol putih agar terlihat di background putih
    final borderColor =
        color == Colors.white ? Colors.grey : Colors.transparent;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: _buildCustomButton(
          text,
          style: ButtonStyle.fill,
          fillColor: color,
          textColor: textColor,
          height: 40,
          borderColor: borderColor,
          onPressed: () {
            print('$text clicked!');
          },
        ),
      ),
    );
  }

  // Helper untuk Tombol yang Diperluas
  Widget _buildButtonExpanded(
    String text,
    ButtonStyle style, {
    Color fillColor = Colors.transparent,
    Color textColor = Colors.black87,
    Color borderColor = Colors.transparent,
    bool isRound = false,
    bool isRaised = false,
    double height = 40.0,
    FontWeight fontWeight = FontWeight.normal,
    bool isSmall = false,
    double fontSize = 16.0,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 0),
        child: _buildCustomButton(
          text,
          style: style,
          fillColor: fillColor,
          textColor: textColor,
          borderColor: borderColor,
          isRound: isRound,
          isRaised: isRaised,
          height: height,
          fontWeight: fontWeight,
          isSmall: isSmall,
          fontSize: fontSize,
          onPressed: () {
            print('$text (${style.name}) clicked!');
          },
        ),
      ),
    );
  }

  // --- Widget Pembantu: Pembuat Tombol Kustom Utama ---
  Widget _buildCustomButton(
    String text, {
    required ButtonStyle style,
    Color fillColor = Colors.transparent,
    Color textColor = Colors.black87,
    Color borderColor = Colors.transparent,
    bool isRound = false,
    bool isRaised = false,
    double height = 40.0,
    FontWeight fontWeight = FontWeight.normal,
    bool isSmall = false,
    double fontSize = 16.0,
    bool isPreloading = false,
    VoidCallback? onPressed,
  }) {
    double finalHeight = isSmall ? 30.0 : height;
    double borderRadius = isSmall ? 4.0 : 6.0;

    double finalElevation = 0.0;
    Color finalShadowColor = Colors.transparent;

    if (isRaised) {
      finalElevation = 2.0;
      finalShadowColor = Colors.black.withOpacity(0.1);
    }

    // Warna loader: putih jika fill/raised, jika outline/usual ikut warna teks
    Color indicatorColor =
        (style == ButtonStyle.fill || style == ButtonStyle.raised)
            ? Colors.white
            : textColor;

    Widget buttonChild;
    if (isPreloading) {
      buttonChild = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      );
    } else {
      buttonChild = Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      );
    }

    final buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: textColor,
      minimumSize: Size.fromHeight(finalHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: isSmall ? 4.0 : 10.0,
      ),
      elevation: 0,
    );

    return Material(
      // Jika Tonal, gunakan fillColor (yang sudah diset tonalColor di atas)
      color: fillColor,
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: finalElevation,
      shadowColor: finalShadowColor,
      type: MaterialType.button,

      child: InkWell(
        onTap: isPreloading ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: style == ButtonStyle.outline
                  ? borderColor
                  : (borderColor != Colors.transparent
                      ? borderColor
                      : Colors.transparent),
              width: (style == ButtonStyle.outline ||
                      borderColor != Colors.transparent)
                  ? 1.5
                  : 0,
            ),
          ),
          child: TextButton(
            onPressed: isPreloading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        ),
      ),
    );
  }
}

enum ButtonStyle { usual, tonal, fill, outline, raised }
