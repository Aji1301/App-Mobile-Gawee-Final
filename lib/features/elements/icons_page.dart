import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Adjust path to your ThemeProvider

// Data Dummy for F7 Icons
final List<Map<String, dynamic>> f7IconsData = [
  {'name': 'cursor_rays', 'icon': Icons.mouse_outlined},
  {'name': 'wand_stars', 'icon': Icons.auto_awesome_outlined},
  {'name': 'bed_double_fill', 'icon': Icons.bed},
  {'name': 'arrow_down_do', 'icon': Icons.file_download_outlined},
  {'name': 'chat_bubble_text', 'icon': Icons.chat_bubble_outline},
  {'name': 'exclamationmark', 'icon': Icons.warning_amber_outlined},
  {'name': 'xmark', 'icon': Icons.close_outlined},
  {'name': 'sort_down', 'icon': Icons.arrow_downward_outlined},
  {'name': 'cloud_sun', 'icon': Icons.cloud_outlined},
  {'name': 'money_sign', 'icon': Icons.attach_money},
  {'name': 'lock_shield', 'icon': Icons.lock_outline},
  {'name': 'bell_fill', 'icon': Icons.notifications},
  {'name': 'camera_fill', 'icon': Icons.camera_alt},
  {'name': 'settings', 'icon': Icons.settings_outlined},
  {'name': 'person_fill', 'icon': Icons.person_outline},
  {'name': 'house_fill', 'icon': Icons.home_outlined},
  {'name': 'chart_bar', 'icon': Icons.bar_chart_outlined},
  {'name': 'trash_fill', 'icon': Icons.delete_outline},
];

// Data Dummy for Material Icons
final List<Map<String, dynamic>> materialIconsData = [
  {'name': 'translate', 'icon': Icons.translate},
  {'name': 'child_friendly', 'icon': Icons.child_friendly},
  {'name': 'movie', 'icon': Icons.movie},
  {'name': 'screen_lock_landscape', 'icon': Icons.screen_lock_landscape},
  {'name': 'switch_camera', 'icon': Icons.switch_camera},
  {'name': 'link_off', 'icon': Icons.link_off},
  {'name': 'cast_connected', 'icon': Icons.cast_connected},
  {'name': 'network_cell', 'icon': Icons.network_cell},
  {'name': 'access_alarms', 'icon': Icons.access_alarms},
  {'name': 'bubble_chart', 'icon': Icons.bubble_chart},
  {
    'name': 'airline_seat_legroom_reduced',
    'icon': Icons.airline_seat_legroom_reduced,
  },
  {'name': 'format_align_center', 'icon': Icons.format_align_center},
  {'name': 'cloud_download', 'icon': Icons.cloud_download},
  {'name': 'edit_location', 'icon': Icons.edit_location},
  {'name': 'repeat_30', 'icon': Icons.repeat_one},
  {'name': 'add_shopping_cart', 'icon': Icons.add_shopping_cart},
  {'name': 'kitchen', 'icon': Icons.kitchen},
  {'name': 'weekend', 'icon': Icons.weekend},
  {'name': 'search_off', 'icon': Icons.search_off},
  {'name': 'check_box', 'icon': Icons.check_box},
  {'name': 'navigation', 'icon': Icons.navigation},
];

// ----------------------------------------------------
// Kelas Utama (DefaultTabController)
// ----------------------------------------------------

class IconsPage extends StatelessWidget {
  const IconsPage({super.key});

  // [Widget Pembantu: Teks Pengantar Lengkap - Dinamis]
  Widget _buildIntroContent(
      Color textColor, Color codeBgColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Framework7 comes with the premium and free Framework7 Icons iOS-icons font developed specially to be used with iOS theme of Framework7. As for Material theme we recommend to use great-designed Material Icons font. Both of these fonts use a typographic feature called ligatures. It\'s easy to incorporate icons into your app. Here\'s a small example:',
          style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
        ),
        const SizedBox(height: 16),
        // Simulasi kode contoh
        _buildCodeExample(
            'house', 'home', textColor, codeBgColor, primaryColor),
        const SizedBox(height: 16),
        Text(
          'Ligatures allow rendering of an icon glyph simply by using its textual name. The replacement is done automatically by the web browser and provides more readable code than the equivalent numeric character reference.',
          style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // --- Widget Pembantu: Contoh Kode - Dinamis ---
  Widget _buildCodeExample(String f7IconName, String materialIconName,
      Color textColor, Color codeBgColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // F7 Icon Example
        Container(
          padding: const EdgeInsets.all(8),
          color: codeBgColor,
          child: Row(
            children: [
              Text(
                '<i class="f7-icons">$f7IconName</i>',
                style: TextStyle(fontFamily: 'monospace', color: textColor),
              ),
              const SizedBox(width: 20),
              Icon(Icons.home, size: 20, color: primaryColor),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Material Icon Example
        Container(
          padding: const EdgeInsets.all(8),
          color: codeBgColor,
          child: Row(
            children: [
              Text(
                '<i class="material-icons">$materialIconName</i>',
                style: TextStyle(fontFamily: 'monospace', color: textColor),
              ),
              const SizedBox(width: 20),
              Icon(Icons.home_outlined, size: 20, color: textColor),
            ],
          ),
        ),
      ],
    );
  }

  // --- Widget Pembantu: Grid Ikon - Dinamis ---
  Widget _buildIconGrid(
      List<Map<String, dynamic>> iconData, Color iconColor, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: iconData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final item = iconData[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item['icon'] as IconData, size: 28, color: iconColor),
              const SizedBox(height: 4),
              Text(
                item['name'] as String,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 10, color: textColor.withOpacity(0.6)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
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
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks, Icon, & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna khusus untuk Code Block
    final codeBgColor = isDark ? Colors.grey[800]! : Colors.grey.shade100;

    // Warna TabBar Background
    final tabBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: scaffoldBgColor,

        // 1. AppBar Sederhana
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
              title: const Text(
                'Icons',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: false,
            ),
          ),
        ),

        // 2. Body Halaman: Teks + TabBar + TabBarView
        body: Column(
          children: [
            // A. Teks Pengantar
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: _buildIntroContent(textColor, codeBgColor, primaryColor),
            ),

            // B. TabBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: dividerColor, width: 1),
                  ),
                  color: tabBarBgColor,
                ),
                child: TabBar(
                  indicatorColor: primaryColor,
                  labelColor: primaryColor,
                  unselectedLabelColor: textColor,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  tabs: const [
                    Tab(child: Text('F7 Icons')),
                    Tab(child: Text('Material Icons')),
                  ],
                ),
              ),
            ),

            // C. TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: F7 Icons Grid
                  _buildIconGrid(f7IconsData, textColor, textColor),
                  // Tab 2: Material Icons Grid
                  _buildIconGrid(materialIconsData, textColor, textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
