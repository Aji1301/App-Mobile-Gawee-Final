// lib/popover_page.dart
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class PopoverPage extends StatefulWidget {
  const PopoverPage({super.key});

  @override
  State<PopoverPage> createState() => _PopoverPageState();
}

class _PopoverPageState extends State<PopoverPage> {
  // --- FUNGSI UNTUK MENAMPILKAN POPOVER KUSTOM ---
  void _showCustomPopover(BuildContext context) {
    // Ambil tema dari context saat ini (tombol yang diklik)
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // Warna Popover
    final popoverBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showPopover(
      context: context,
      backgroundColor: popoverBgColor, // Warna background dinamis
      arrowHeight: 15.0,
      arrowWidth: 20.0,
      arrowDxOffset: 0,
      barrierColor: Colors.transparent,
      radius: 12.0,
      shadow: [
        BoxShadow(
          color: Colors.black.withAlpha(26),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
      bodyBuilder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPopoverItem('Dialog', textColor, primaryColor),
            _buildPopoverItem('Tabs', textColor, primaryColor),
            _buildPopoverItem('Side Panels', textColor, primaryColor),
            _buildPopoverItem('List View', textColor, primaryColor),
            _buildPopoverItem('Form Inputs', textColor, primaryColor),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk item di dalam popover (Dinamis)
  Widget _buildPopoverItem(String text, Color textColor, Color primaryColor) {
    return InkWell(
      onTap: () {
        debugPrint('Tapped: $text');
        Navigator.pop(context); // Tutup popover
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          text,
          style: TextStyle(
            color: primaryColor, // Mengikuti warna tema
            fontSize: 17,
            fontWeight: FontWeight.w500,
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
    final iconColor = isDark ? Colors.white70 : Colors.black54;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna BottomAppBar
    final bottomBarColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);

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
            title: const Text('Popover'),
            centerTitle: true,
            actions: [
              Builder(
                builder: (buttonContext) {
                  return TextButton(
                    onPressed: () => _showCustomPopover(buttonContext),
                    child: Text(
                      'Popover',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tombol Ungu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (buttonContext) {
                  return FilledButton(
                    onPressed: () => _showCustomPopover(buttonContext),
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor, // Mengikuti tema
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Open popover on me',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            // Konten Teks
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: RichText(
                text: TextSpan(
                  // Default style untuk semua teks di dalam RichText
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                    color: textColor, // Mengikuti tema
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Mauris fermentum neque et luctus venenatis. Vivamus a sem rhoncus, ornare tellus eu, euismod mauris. In porta turpis at semper convallis. Duis adipiscing leo eu nulla lacinia, quis rhoncus metus condimentum. Etiam nec malesuada nibh. Maecenas quis lacinia nisl, vel posuere dolor. Vestibulum condimentum, nisl ac vulputate egestas, neque enim dignissim elit, rhoncus volutpat magna enim a est. Aenean sit amet ligula neque. Cras suscipit rutrum enim. Nam a odio facilisis, elementum tellus non, ',
                    ),
                    TextSpan(
                      text: 'popover',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text:
                          ' tortor. Pellentesque felis eros, dictum vitae lacinia quis, lobortis vitae ipsum. Cras vehicula bibendum lorem quis imperdiet.\n\nIn hac habitasse platea dictumst. Etiam varius, ante vel ornare facilisis, velit massa rutrum dolor, ac porta magna magna lacinia nunc. Curabitur ',
                    ),
                    TextSpan(
                      text: 'popover!',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text:
                          ' cursus laoreet. Aenean vel tempus augue. Pellentesque in imperdiet nibh. Mauris rhoncus nulla id sem suscipit volutpat. Pellentesque ac arcu in nisi viverra pulvinar. Nullam nulla orci, bibendum sed ligula non, ullamcorper iaculis mi. In hac habitasse platea dictumst. Praesent varius at nisl eu luctus. Cras aliquet porta est. Quisque elementum quis dui et consectetur. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed sed laoreet purus.\n\nDuis et ultricies nibh. Sed facilisis turpis urna, ac imperdiet erat venenatis eu. Proin sit amet faucibus tortor, et varius sem. Etiam vitae lacinia neque. Aliquam nisi purus, interdum in arcu sed, ultrices rutrum arcu. Nulla mi turpis, consectetur vel enim quis, facilisis viverra dui. Aliquam quis convallis tortor, quis semper ligula. Morbi ullamcorper ',
                    ),
                    TextSpan(
                      text: 'one more popover',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text:
                          ' massa at accumsan. Etiam purus odio, posuere in ligula vitae, viverra ultricies justo. Vestibulum nec interdum nisl. Aenean ac consectetur velit, non malesuada magna. Sed pharetra vehicula augue, vel venenatis lectus gravida eget. Curabitur lacus tellus, venenatis eu arcu in, interdum auctor nunc. Nunc non metus neque. Suspendisse viverra lectus sed risus aliquet, vel accumsan dolor feugiat.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // --- BottomAppBar ---
      bottomNavigationBar: BottomAppBar(
        color: bottomBarColor, // Mengikuti tema
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dummy Link Tapped!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  'Dummy Link',
                  style: TextStyle(fontSize: 16, color: iconColor),
                ),
              ),

              // Pemicu Popover #3 (Footer)
              Builder(
                builder: (buttonContext) {
                  return InkWell(
                    onTap: () => _showCustomPopover(buttonContext),
                    child: Text(
                      'Open Popover',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
