import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// ----------------------------------------------------
// 1. Widget Text Editor NYATA (SUDAH DIPERBAIKI SEMUA)
// ----------------------------------------------------

class RealTextEditor extends StatefulWidget {
  final bool showPlaceholder;
  final bool hasDefaultValue;

  const RealTextEditor({
    super.key,
    this.showPlaceholder = false,
    this.hasDefaultValue = false,
  });

  @override
  State<RealTextEditor> createState() => _RealTextEditorState();
}

class _RealTextEditorState extends State<RealTextEditor> {
  late TextEditingController _controller;

  // simple formatting state (visual only)
  bool _bold = false;
  bool _italic = false;
  bool _underline = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.hasDefaultValue
            ? 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.\n\nProvident reiciendis exercitationem reprehenderit amet repellat.'
            : '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper untuk mendapatkan style saat ini (tanpa warna, warna dihandle di build)
  TextStyle _getStyle(Color textColor) => TextStyle(
        fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
        decoration: _underline ? TextDecoration.underline : TextDecoration.none,
        color: textColor,
        fontSize: 16,
      );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final borderColor = isDark ? Colors.white24 : const Color(0xFFDCDCDC);
    final textColor = isDark ? Colors.white : Colors.black87;
    final toolbarBg = isDark ? Colors.black12 : primaryColor.withOpacity(0.1);
    final iconColorInactive = isDark ? Colors.white54 : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        children: [
          // Minimal toolbar
          Container(
            color: toolbarBg,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold,
                      color: _bold ? primaryColor : iconColorInactive),
                  onPressed: () => setState(() => _bold = !_bold),
                ),
                IconButton(
                  icon: Icon(Icons.format_italic,
                      color: _italic ? primaryColor : iconColorInactive),
                  onPressed: () => setState(() => _italic = !_italic),
                ),
                IconButton(
                  icon: Icon(Icons.format_underline,
                      color: _underline ? primaryColor : iconColorInactive),
                  onPressed: () => setState(() => _underline = !_underline),
                ),
                const Spacer(),
                // simple placeholder action
                IconButton(
                  icon: Icon(Icons.clear, color: iconColorInactive),
                  onPressed: () => _controller.clear(),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: borderColor),

          // Editor area
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150, maxHeight: 400),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _controller,
                style: _getStyle(textColor),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: widget.showPlaceholder ? 'Enter text...' : null,
                  hintStyle:
                      TextStyle(color: isDark ? Colors.white30 : Colors.grey)
                          .merge(_getStyle(textColor)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 2. Widget Text Editor SIMULASI (Tidak Berubah)
// ----------------------------------------------------

class TextEditorSimulator extends StatefulWidget {
  final List<IconData> toolbarIcons;
  final String? placeholder;
  final double minHeight;
  final bool resizable;

  const TextEditorSimulator({
    super.key,
    required this.toolbarIcons,
    this.placeholder,
    this.minHeight = 150,
    this.resizable = false,
  });

  @override
  State<TextEditorSimulator> createState() => _TextEditorSimulatorState();
}

class _TextEditorSimulatorState extends State<TextEditorSimulator> {
  // State untuk pemformatan global
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle _getStyle(Color textColor) {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      color: textColor,
      fontSize: 16,
    );
  }

  Widget _buildToolbar(BuildContext context, Color primaryColor, Color bgColor,
      Color borderColor, Color iconColorInactive) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.toolbarIcons.map((icon) {
            bool isActive = false;
            if (icon == Icons.format_bold) isActive = isBold;
            if (icon == Icons.format_italic) isActive = isItalic;
            if (icon == Icons.format_underline) isActive = isUnderline;

            if (icon == Icons.horizontal_rule) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('<hr>',
                    style: TextStyle(color: iconColorInactive, fontSize: 14)),
              );
            }

            return IconButton(
              icon: Icon(icon,
                  size: 18, color: isActive ? primaryColor : iconColorInactive),
              onPressed: () {
                setState(() {
                  if (icon == Icons.format_bold)
                    isBold = !isBold;
                  else if (icon == Icons.format_italic)
                    isItalic = !isItalic;
                  else if (icon == Icons.format_underline)
                    isUnderline = !isUnderline;
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Clicked: ${icon.toString().split('.').last}'),
                      ),
                    );
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final borderColor = isDark ? Colors.white24 : const Color(0xFFDCDCDC);
    final textColor = isDark ? Colors.white : Colors.black87;
    final toolbarBg = isDark ? Colors.black12 : primaryColor.withOpacity(0.1);
    final iconColorInactive = isDark ? Colors.white54 : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        children: [
          _buildToolbar(
              context, primaryColor, toolbarBg, borderColor, iconColorInactive),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.minHeight,
              maxHeight: widget.resizable ? double.infinity : widget.minHeight,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TextField(
                controller: _controller,
                style: _getStyle(textColor),
                keyboardType: TextInputType.multiline,
                maxLines: widget.resizable ? null : (widget.minHeight ~/ 20),
                minLines: 1,
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle:
                      TextStyle(color: isDark ? Colors.white30 : Colors.grey)
                          .merge(_getStyle(textColor)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 3. Widget List Input Simulasikan (As List Input)
// ----------------------------------------------------
class ListInputSimulator extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isEditor; // true untuk About

  const ListInputSimulator({
    super.key,
    required this.label,
    required this.placeholder,
    this.isEditor = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final primaryColor = themeProvider.primaryColor;
    final borderColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    // Background list item: Dark mode = cardColor, Light mode = primaryColor pudar
    final bgColor =
        isDark ? themeProvider.cardColor : primaryColor.withOpacity(0.05);
    final textColor = isDark ? Colors.white : Colors.black87;
    final labelColor = isDark ? Colors.white60 : Colors.grey;

    return Container(
      height: isEditor ? 100 : 50,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            placeholder,
            style: TextStyle(
              fontSize: 16,
              color: labelColor.withOpacity(0.6),
            ),
            maxLines: isEditor ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 4. Text Editor Page Utama (Menggabungkan Semua)
// ----------------------------------------------------

class TextEditorPage extends StatelessWidget {
  const TextEditorPage({super.key});

  // Widget Pembantu: Judul Bagian Dinamis
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Warna Dinamis
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBg =
        isDark ? themeProvider.cardColor : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final primaryColor = themeProvider.primaryColor;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBg,
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
            title: const Text(
              'Text Editor',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Framework7 comes with a touch-friendly Rich Text Editor component. It is based on modern "contenteditable" API so it should work everywhere as is.\n\nIt comes with the basic set of formatting features. But its functionality can be easily extended and customized to fit any requirements.',
              style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
            ),

            // 1. Default Setup (Fungsional "Seperti Word")
            _buildSectionTitle('Default Setup', primaryColor),
            const RealTextEditor(
                showPlaceholder: false, hasDefaultValue: false),

            // 2. With Placeholder (Fungsional "Seperti Word")
            _buildSectionTitle('With Placeholder', primaryColor),
            const RealTextEditor(showPlaceholder: true, hasDefaultValue: false),

            // 3. With Default Value (Fungsional "Seperti Word")
            _buildSectionTitle('With Default Value', primaryColor),
            const RealTextEditor(showPlaceholder: false, hasDefaultValue: true),

            // 4. Specific Buttons (Simulasi Sederhana)
            _buildSectionTitle('Specific Buttons', primaryColor),
            Text(
              'It is possible to customize which buttons (commands) to show.',
              style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
            ),
            const SizedBox(height: 12),
            const TextEditorSimulator(
              toolbarIcons: [
                Icons.format_bold,
                Icons.format_italic,
                Icons.format_underline,
                Icons.format_align_left,
              ],
              placeholder: 'Enter text...',
              minHeight: 80,
            ),

            // 5. Custom Button (Simulasi Sederhana)
            _buildSectionTitle('Custom Button', primaryColor),
            Text(
              'It is possible to create custom editor buttons. Here is the custom "hr" button that adds horizontal rule:',
              style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
            ),
            const SizedBox(height: 12),
            const TextEditorSimulator(
              toolbarIcons: [
                Icons.format_bold,
                Icons.format_italic,
                Icons.horizontal_rule, // Ini adalah tombol custom 'hr'
                Icons.format_align_left,
              ],
              minHeight: 80,
            ),

            // 6. As List Input
            _buildSectionTitle('As List Input (Simulated)', primaryColor),
            const ListInputSimulator(
              label: 'Name',
              placeholder: 'Your name',
            ),
            const ListInputSimulator(
              label: 'About',
              placeholder: 'About yourself',
              isEditor: true, // Ini membuatnya lebih tinggi
            ),
          ],
        ),
      ),
    );
  }
}
