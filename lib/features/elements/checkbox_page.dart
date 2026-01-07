import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  // --- 1. State untuk Inline Checkboxes ---
  bool isInlineCheckbox1Checked = false;
  bool isInlineCheckbox2Checked = true;

  // --- 2. State untuk Checkbox Group (Standard) ---
  Map<String, bool> checkboxGroup = {
    'Books': true,
    'Movies': true,
    'Food': false,
    'Drinks': false,
  };

  // --- 3. State untuk Indeterminate State ---
  bool? moviesParentChecked = false;
  bool movie1Checked = false;
  bool movie2Checked = false;

  // Data untuk Media List
  final List<Map<String, dynamic>> mediaListItems = [
    {
      'title': 'Facebook',
      'via': '',
      'time': '17:14',
      'subtitle': 'New messages from John Doe',
      'checked': false,
    },
    {
      'title': 'John Doe',
      'via': ' (via Twitter)',
      'time': '17:11',
      'subtitle': 'John Doe (@_johndoe) mentioned you on Twitter!',
      'checked': false,
    },
    {
      'title': 'Facebook',
      'via': '',
      'time': '16:48',
      'subtitle': 'New messages from John Doe',
      'checked': false,
    },
    {
      'title': 'John Doe',
      'via': ' (via Twitter)',
      'time': '15:32',
      'subtitle': 'John Doe (@_johndoe) mentioned you on Twitter!',
      'checked': false,
    },
  ];

  // =========================================================
  // LOGIC
  // =========================================================

  void _updateMoviesParent() {
    int checkedCount = 0;
    if (movie1Checked) checkedCount++;
    if (movie2Checked) checkedCount++;

    if (checkedCount == 2) {
      moviesParentChecked = true;
    } else if (checkedCount == 1) {
      moviesParentChecked = null;
    } else {
      moviesParentChecked = false;
    }
  }

  void _onMovieParentChange(bool? newValue) {
    final bool isChecking = newValue ?? false;
    setState(() {
      moviesParentChecked = isChecking;
      movie1Checked = isChecking;
      movie2Checked = isChecking;
    });
  }

  void _onMovieChildChange(int movieNumber, bool newValue) {
    setState(() {
      if (movieNumber == 1) {
        movie1Checked = newValue;
      } else {
        movie2Checked = newValue;
      }
      _updateMoviesParent();
    });
  }

  // =========================================================
  // WIDGET PEMBANTU (Diupdate untuk menerima Warna Dinamis)
  // =========================================================

  /// Judul Bagian
  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  /// Checkbox yang dikustomisasi untuk penggunaan inline
  Widget _buildInlineCheckbox({
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
    required Color activeColor,
  }) {
    return Transform.scale(
      scale: 0.9,
      child: Checkbox(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: isChecked,
        onChanged: onChanged,
        activeColor: activeColor,
      ),
    );
  }

  /// Item daftar dengan checkbox (Media List)
  Widget _buildMediaListItem(
      int index,
      Map<String, dynamic> item,
      Color primaryColor,
      Color textColor,
      Color subTextColor,
      Color dividerColor) {
    final String longSubtitleText = item['subtitle'] +
        '\n' +
        'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nulla sagittis tellus ut turpis condimentum, ut dignissim lacus...';

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Checkbox(
            value: mediaListItems[index]['checked'],
            onChanged: (newValue) {
              setState(() {
                mediaListItems[index]['checked'] = newValue!;
              });
            },
            activeColor: primaryColor,
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: textColor,
                    ),
                    children: [
                      TextSpan(
                        text: item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: item['via'],
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Text(
                  item['time'],
                  style: TextStyle(fontSize: 14, color: subTextColor),
                ),
              ],
            ),
          ),
          subtitle: Text(
            longSubtitleText,
            style: TextStyle(
              fontSize: 14,
              color: subTextColor,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (index < mediaListItems.length - 1)
          Divider(
            height: 1,
            thickness: 1,
            indent: 16.0,
            endIndent: 0,
            color: dividerColor,
          ),
      ],
    );
  }

  // =========================================================
  // BUILD METHOD
  // =========================================================

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

    // Warna Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Header Halaman) ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBgColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Checkbox',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ----------------------------------------------------
            // 1. Inline (Dua Checkbox Interaktif)
            // ----------------------------------------------------
            _buildSectionTitle('Inline', primaryColor),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: textColor,
                  ),
                  children: [
                    const TextSpan(text: 'Lorem '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: _buildInlineCheckbox(
                        isChecked: isInlineCheckbox1Checked,
                        activeColor: primaryColor,
                        onChanged: (newValue) {
                          setState(() {
                            isInlineCheckbox1Checked = newValue ?? false;
                          });
                        },
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' ipsum dolor sit amet, consectetur adipisicing elit. Alias beatae illo nihil aut eius commodi sint eveniet aliquid eligendi',
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: _buildInlineCheckbox(
                        isChecked: isInlineCheckbox2Checked,
                        activeColor: primaryColor,
                        onChanged: (newValue) {
                          setState(() {
                            isInlineCheckbox2Checked = newValue ?? false;
                          });
                        },
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' ad delectus impedit tempore nemo, enim vel praesentium consequatur nulla mollitia!',
                    ),
                  ],
                ),
              ),
            ),

            // ----------------------------------------------------
            // 2. Checkbox Group (Checkbox di Kiri)
            // ----------------------------------------------------
            _buildSectionTitle('Checkbox Group 1', primaryColor),
            Column(
              children: checkboxGroup.keys.map((key) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: checkboxGroup[key],
                    onChanged: (newValue) {
                      setState(() {
                        checkboxGroup[key] = newValue!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  title: Text(
                    key,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 3. Checkbox Group (Checkbox di Kanan)
            // ----------------------------------------------------
            _buildSectionTitle('Checkbox Group 2', primaryColor),
            Column(
              children: checkboxGroup.keys.map((key) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    key,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  trailing: Checkbox(
                    value: checkboxGroup[key],
                    onChanged: (newValue) {
                      setState(() {
                        checkboxGroup[key] = newValue!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                );
              }).toList(),
            ),

            // ----------------------------------------------------
            // 4. Indeterminate State
            // ----------------------------------------------------
            _buildSectionTitle('Indeterminate State', primaryColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Movies',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  leading: Checkbox(
                    tristate: true,
                    value: moviesParentChecked,
                    onChanged: _onMovieParentChange,
                    activeColor: primaryColor,
                  ),
                ),
                Divider(height: 1, thickness: 1, color: dividerColor),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Movie 1',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    leading: Checkbox(
                      value: movie1Checked,
                      onChanged: (newValue) =>
                          _onMovieChildChange(1, newValue ?? false),
                      activeColor: primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Movie 2',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    leading: Checkbox(
                      value: movie2Checked,
                      onChanged: (newValue) =>
                          _onMovieChildChange(2, newValue ?? false),
                      activeColor: primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // ----------------------------------------------------
            // 5. With Media Lists
            // ----------------------------------------------------
            _buildSectionTitle('With Media Lists', primaryColor),
            Column(
              children: mediaListItems.asMap().entries.map((entry) {
                return _buildMediaListItem(entry.key, entry.value, primaryColor,
                    textColor, subTextColor, dividerColor);
              }).toList(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
