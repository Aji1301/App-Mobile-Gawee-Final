import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// =============================================================================
// KELAS 1: HALAMAN MENU UTAMA (Toolbar & Tabbar Options)
// =============================================================================
class ToolbarTabbarPage extends StatefulWidget {
  const ToolbarTabbarPage({super.key});

  @override
  State<ToolbarTabbarPage> createState() => _ToolbarTabbarPageState();
}

class _ToolbarTabbarPageState extends State<ToolbarTabbarPage> {
  bool _isToolbarBottom = true;

  // Helper untuk mendapatkan warna divider berdasarkan tema
  Color _getDividerColor(bool isDark) =>
      isDark ? Colors.white12 : const Color(0xFFEFEFF4);

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.0, height: 1.4, color: textColor),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title,
      {VoidCallback? onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Warna item list
    final itemColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      color: itemColor,
      child: Column(
        children: [
          ListTile(
            title:
                Text(title, style: TextStyle(fontSize: 16, color: textColor)),
            trailing:
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            onTap: onTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title belum diimplementasikan')),
                  );
                },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            visualDensity: VisualDensity.compact,
          ),
          Divider(
              height: 1,
              thickness: 1,
              color: isDark ? Colors.transparent : Colors.white,
              indent: 16),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Warna Toolbar
    final toolbarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final borderColor = _getDividerColor(isDark);
    final linkColor =
        themeProvider.primaryColor; // Menggunakan warna primary untuk link

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: toolbarBgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.5),
          bottom: BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text('Left Link',
                style: TextStyle(color: linkColor, fontSize: 16)),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text('Right Link',
                style: TextStyle(color: linkColor, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarColor = isDark ? Colors.transparent : Colors.white; // AppBar bg
    final primaryColor = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final dividerColor = _getDividerColor(isDark);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarColor,
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
            title: const Text('Toolbar & Tabbar'),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          if (!_isToolbarBottom) _buildToolbar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: dividerColor),
                        bottom: BorderSide(color: dividerColor),
                      ),
                    ),
                    child: Column(
                      children: [
                        // --- NAVIGASI HALAMAN ---
                        _buildListItem(context, 'Tabbar', onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TabbarPage()));
                        }),
                        _buildListItem(context, 'Tabbar With Icons', onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TabbarIconsPage()));
                        }),
                        _buildListItem(context, 'Tabbar Scrollable', onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TabbarScrollablePage()));
                        }),
                        _buildListItem(context, 'Hide Toolbar On Scroll',
                            onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HideToolbarOnScrollPage()));
                        }),
                      ],
                    ),
                  ),
                  _buildSectionTitle('Toolbar Position', primaryColor),
                  _buildDescription(
                      'Toolbar supports both top and bottom positions. Click the following button to change its position.',
                      secondaryTextColor),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _isToolbarBottom = !_isToolbarBottom;
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Toggle Toolbar Position',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isToolbarBottom ? _buildToolbar(context) : null,
    );
  }
}

// =============================================================================
// KELAS 2: TABBAR PAGE (Biasa)
// =============================================================================
class TabbarPage extends StatefulWidget {
  const TabbarPage({super.key});

  @override
  State<TabbarPage> createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  int _currentIndex = 0;

  final String _loremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam enim quia molestiae facilis laudantium voluptates obcaecati officia cum, sit libero commodi. Ratione illo suscipit temporibus sequi iure ad laboriosam accusamus?

Saepe explicabo voluptas ducimus provident, doloremque quo totam molestias! Suscipit blanditiis eaque exercitationem praesentium reprehenderit, fuga accusamus possimus sed, sint facilis ratione quod, qui dignissimos voluptas! Aliquam rerum consequuntur deleniti.

Totam reprehenderit amet commodi ipsum nam provident doloremque possimus odio itaque, est animi culpa modi consequatur reiciendis corporis libero laudantium sed eveniet unde delectus a maiores nihil dolores? Natus, perferendis.

Atque quis totam repellendus omnis alias magnam corrupti, possimus aspernatur perspiciatis quae provident consequatur minima doloremque blanditiis nihil maxime ducimus earum autem. Magni animi blanditiis similique iusto, repellat sed quisquam!

Suscipit, facere quasi atque totam. Repudiandae facilis at optio atque, rem nam, natus ratione cum enim voluptatem suscipit veniam! Repellat, est debitis. Modi nam mollitia explicabo, unde aliquid impedit! Adipisci!

Deserunt adipisci tempora asperiores, quo, nisi ex delectus vitae consectetur iste fugiat iusto dolorem autem. Itaque, ipsa voluptas, a assumenda rem, dolorum porro accusantium, officiis veniam nostrum cum cumque impedit.

Laborum illum ipsa voluptatibus possimus nesciunt ex consequatur rem, natus ad praesentium rerum libero consectetur temporibus cupiditate atque aspernatur, eaque provident eligendi quaerat ea soluta doloremque. Iure fugit, minima facere.
''';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final primaryColor = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final tabbarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tabbarBgColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Tabbar', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: () {},
          ),
        ],
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
              'Tab ${_currentIndex + 1} content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _loremIpsum,
              style: TextStyle(
                fontSize: 15.0,
                height: 1.4,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: tabbarBgColor,
          border: Border(top: BorderSide(color: dividerColor, width: 0.5)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                _buildTabItem(
                    index: 0,
                    label: 'Tab 1',
                    activeColor: primaryColor,
                    isDark: isDark),
                _buildTabItem(
                    index: 1,
                    label: 'Tab 2',
                    activeColor: primaryColor,
                    isDark: isDark),
                _buildTabItem(
                    index: 2,
                    label: 'Tab 3',
                    activeColor: primaryColor,
                    isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
      {required int index,
      required String label,
      required Color activeColor,
      required bool isDark}) {
    final bool isActive = _currentIndex == index;
    final inactiveColor = isDark ? Colors.white60 : Colors.grey;
    final textColor =
        isActive ? (isDark ? Colors.white : Colors.black) : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Stack(
          children: [
            Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (isActive)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 3, color: activeColor),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// KELAS 3: TABBAR WITH ICONS
// =============================================================================
class TabbarIconsPage extends StatefulWidget {
  const TabbarIconsPage({super.key});

  @override
  State<TabbarIconsPage> createState() => _TabbarIconsPageState();
}

class _TabbarIconsPageState extends State<TabbarIconsPage> {
  int _currentIndex = 0;
  final String _loremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam enim quia molestiae facilis laudantium voluptates obcaecati officia cum, sit libero commodi. Ratione illo suscipit temporibus sequi iure ad laboriosam accusamus?

Saepe explicabo voluptas ducimus provident, doloremque quo totam molestias! Suscipit blanditiis eaque exercitationem praesentium reprehenderit, fuga accusamus possimus sed, sint facilis ratione quod, qui dignissimos voluptas! Aliquam rerum consequuntur deleniti.

Totam reprehenderit amet commodi ipsum nam provident doloremque possimus odio itaque, est animi culpa modi consequatur reiciendis corporis libero laudantium sed eveniet unde delectus a maiores nihil dolores? Natus, perferendis.

Atque quis totam repellendus omnis alias magnam corrupti, possimus aspernatur perspiciatis quae provident consequatur minima doloremque blanditiis nihil maxime ducimus earum autem. Magni animi blanditiis similique iusto, repellat sed quisquam!

Suscipit, facere quasi atque totam. Repudiandae facilis at optio atque, rem nam, natus ratione cum enim voluptatem suscipit veniam! Repellat, est debitis. Modi nam mollitia explicabo, unde aliquid impedit! Adipisci!

Deserunt adipisci tempora asperiores, quo, nisi ex delectus vitae consectetur iste fugiat iusto dolorem autem. Itaque, ipsa voluptas, a assumenda rem, dolorum porro accusantium, officiis veniam nostrum cum cumque impedit.

Laborum illum ipsa voluptatibus possimus nesciunt ex consequatur rem, natus ad praesentium rerum libero consectetur temporibus cupiditate atque aspernatur, eaque provident eligendi quaerat ea soluta doloremque. Iure fugit, minima facere.
''';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final primaryColor = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final tabbarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tabbarBgColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tabbar Icons',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.compare_arrows), onPressed: () {}),
        ],
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
              'Tab ${_currentIndex + 1} content',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Text(_loremIpsum,
                style:
                    TextStyle(fontSize: 15.0, height: 1.4, color: textColor)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: tabbarBgColor,
          border: Border(top: BorderSide(color: dividerColor, width: 0.5)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                _buildIconTabItem(
                    index: 0,
                    label: 'Inbox',
                    icon: Icons.mail,
                    activeColor: primaryColor,
                    isDark: isDark),
                _buildIconTabItem(
                    index: 1,
                    label: 'Calendar',
                    icon: Icons.calendar_today,
                    badge: '5',
                    activeColor: primaryColor,
                    isDark: isDark),
                _buildIconTabItem(
                    index: 2,
                    label: 'Upload',
                    icon: Icons.upload,
                    activeColor: primaryColor,
                    isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconTabItem(
      {required int index,
      required String label,
      required IconData icon,
      required Color activeColor,
      required bool isDark,
      String? badge}) {
    final bool isActive = _currentIndex == index;
    // Warna icon: Jika aktif = primary, jika tidak = grey (atau white60 di dark mode)
    final Color color =
        isActive ? activeColor : (isDark ? Colors.white60 : Colors.grey);

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 28),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// KELAS 4: TABBAR SCROLLABLE
// =============================================================================
class TabbarScrollablePage extends StatefulWidget {
  const TabbarScrollablePage({super.key});

  @override
  State<TabbarScrollablePage> createState() => _TabbarScrollablePageState();
}

class _TabbarScrollablePageState extends State<TabbarScrollablePage> {
  int _currentIndex = 0;
  final String _loremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam enim quia molestiae facilis laudantium voluptates obcaecati officia cum, sit libero commodi. Ratione illo suscipit temporibus sequi iure ad laboriosam accusamus?

Saepe explicabo voluptas ducimus provident, doloremque quo totam molestias! Suscipit blanditiis eaque exercitationem praesentium reprehenderit, fuga accusamus possimus sed, sint facilis ratione quod, qui dignissimos voluptas! Aliquam rerum consequuntur deleniti.

Totam reprehenderit amet commodi ipsum nam provident doloremque possimus odio itaque, est animi culpa modi consequatur reiciendis corporis libero laudantium sed eveniet unde delectus a maiores nihil dolores? Natus, perferendis.

Atque quis totam repellendus omnis alias magnam corrupti, possimus aspernatur perspiciatis quae provident consequatur minima doloremque blanditiis nihil maxime ducimus earum autem. Magni animi blanditiis similique iusto, repellat sed quisquam!

Suscipit, facere quasi atque totam. Repudiandae facilis at optio atque, rem nam, natus ratione cum enim voluptatem suscipit veniam! Repellat, est debitis. Modi nam mollitia explicabo, unde aliquid impedit! Adipisci!

Deserunt adipisci tempora asperiores, quo, nisi ex delectus vitae consectetur iste fugiat iusto dolorem autem. Itaque, ipsa voluptas, a assumenda rem, dolorum porro accusantium, officiis veniam nostrum cum cumque impedit.

Laborum illum ipsa voluptatibus possimus nesciunt ex consequatur rem, natus ad praesentium rerum libero consectetur temporibus cupiditate atque aspernatur, eaque provident eligendi quaerat ea soluta doloremque. Iure fugit, minima facere.
''';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final primaryColor = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final tabbarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tabbarBgColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tabbar Scrollable',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.compare_arrows), onPressed: () {}),
        ],
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
              'Tab ${_currentIndex + 1} content',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Text(_loremIpsum,
                style:
                    TextStyle(fontSize: 15.0, height: 1.4, color: textColor)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: tabbarBgColor,
          border: Border(top: BorderSide(color: dividerColor, width: 0.5)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildScrollableTabItem(
                    index: index,
                    label: 'Tab ${index + 1}',
                    activeColor: primaryColor,
                    isDark: isDark);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableTabItem(
      {required int index,
      required String label,
      required Color activeColor,
      required bool isDark}) {
    final bool isActive = _currentIndex == index;
    final inactiveColor = isDark ? Colors.white60 : Colors.grey;
    final textColor =
        isActive ? (isDark ? Colors.white : Colors.black) : inactiveColor;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 100, // Lebar tetap agar bisa discroll
        alignment: Alignment.center,
        child: Stack(
          children: [
            Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (isActive)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 3, color: activeColor),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// KELAS 5: HIDE TOOLBAR ON SCROLL (Baru)
// =============================================================================
class HideToolbarOnScrollPage extends StatefulWidget {
  const HideToolbarOnScrollPage({super.key});

  @override
  State<HideToolbarOnScrollPage> createState() =>
      _HideToolbarOnScrollPageState();
}

class _HideToolbarOnScrollPageState extends State<HideToolbarOnScrollPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isToolbarVisible = true;
  final String _longLoremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quos maxime incidunt id ab culpa ipsa omnis eos, vel excepturi officiis neque illum perferendis dolorum magnam rerum natus dolore nulla ex.

Eum dolore, amet enim quaerat omnis. Modi minus voluptatum quam veritatis assumenda, eligendi minima dolore in autem delectus sequi accusantium? Cupiditate praesentium autem eius, esse ratione consequuntur dolor minus error.

Repellendus ipsa sint quisquam delectus dolore quidem odio, praesentium, sequi temporibus amet architecto? Commodi molestiae, in repellat fugit! Laudantium, fuga quia officiis error. Provident inventore iusto quas iure, expedita optio.

Eligendi recusandae eos sed alias delectus reprehenderit quaerat modi dolor commodi beatae temporibus nisi ullam ut, quae, animi esse in officia nesciunt sequi amet repellendus? Maiores quos provident nisi expedita.

Dolorem aspernatur repudiandae aperiam autem excepturi inventore explicabo molestiae atque, architecto consequatur ab quia quaerat deleniti quis ipsum alias itaque veritatis maiores consectetur minima facilis amet. Maiores impedit ipsum sint.

Consequuntur minus fugit vitae magnam illo quibusdam. Minima rerum, magnam nostrum id error temporibus odio molestias tempore vero, voluptas quam iusto. In laboriosam blanditiis, ratione consequuntur similique, quos repellendus ex!

Error suscipit odio modi blanditiis voluptatibus tempore minima ipsam accusantium id! Minus, ea totam veniam dolorem aspernatur repudiandae quae similique odio dolor, voluptate quis aut tenetur porro culpa odit aliquid.

Aperiam velit sed sit quaerat, expedita tempore aspernatur iusto nobis ipsam error ut sapiente delectus in minima recusandae dolore alias, cumque labore. Doloribus veritatis magni nisi odio voluptatum perferendis placeat!

Eaque laboriosam iusto corporis iure nemo ab deleniti ut facere laborum, blanditiis neque nihil dignissimos fuga praesentium illo facilis eos beatae accusamus cumque molestiae asperiores cupiditate? Provident laborum officiis suscipit!

Exercitationem odio nulla rerum soluta aspernatur fugit, illo iusto ullam similique. Recusandae consectetur rem, odio autem voluptate similique atque, alias possimus quis vitae in, officiis labore deserunt aspernatur rerum sunt?

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quos maxime incidunt id ab culpa ipsa omnis eos, vel excepturi officiis neque illum perferendis dolorum magnam rerum natus dolore nulla ex.

Eum dolore, amet enim quaerat omnis. Modi minus voluptatum quam veritatis assumenda, eligendi minima dolore in autem delectus sequi accusantium? Cupiditate praesentium autem eius, esse ratione consequuntur dolor minus error.

Repellendus ipsa sint quisquam delectus dolore quidem odio, praesentium, sequi temporibus amet architecto? Commodi molestiae, in repellat fugit! Laudantium, fuga quia officiis error. Provident inventore iusto quas iure, expedita optio.

Eligendi recusandae eos sed alias delectus reprehenderit quaerat modi dolor commodi beatae temporibus nisi ullam ut, quae, animi esse in officia nesciunt sequi amet repellendus? Maiores quos provident nisi expedita.

Dolorem aspernatur repudiandae aperiam autem excepturi inventore explicabo molestiae atque, architecto consequatur ab quia quaerat deleniti quis ipsum alias itaque veritatis maiores consectetur minima facilis amet. Maiores impedit ipsum sint.

Consequuntur minus fugit vitae magnam illo quibusdam. Minima rerum, magnam nostrum id error temporibus odio molestias tempore vero, voluptas quam iusto. In laboriosam blanditiis, ratione consequuntur similique, quos repellendus ex!

Error suscipit odio modi blanditiis voluptatibus tempore minima ipsam accusantium id! Minus, ea totam veniam dolorem aspernatur repudiandae quae similique odio dolor, voluptate quis aut tenetur porro culpa odit aliquid.

Aperiam velit sed sit quaerat, expedita tempore aspernatur iusto nobis ipsam error ut sapiente delectus in minima recusandae dolore alias, cumque labore. Doloribus veritatis magni nisi odio voluptatum perferendis placeat!

Eaque laboriosam iusto corporis iure nemo ab deleniti ut facere laborum, blanditiis neque nihil dignissimos fuga praesentium illo facilis eos beatae accusamus cumque molestiae asperiores cupiditate? Provident laborum officiis suscipit!

Exercitationem odio nulla rerum soluta aspernatur fugit, illo iusto ullam similique. Recusandae consectetur rem, odio autem voluptate similique atque, alias possimus quis vitae in, officiis labore deserunt aspernatur rerum sunt?

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quos maxime incidunt id ab culpa ipsa omnis eos, vel excepturi officiis neque illum perferendis dolorum magnam rerum natus dolore nulla ex.

Eum dolore, amet enim quaerat omnis. Modi minus voluptatum quam veritatis assumenda, eligendi minima dolore in autem delectus sequi accusantium? Cupiditate praesentium autem eius, esse ratione consequuntur dolor minus error.

Repellendus ipsa sint quisquam delectus dolore quidem odio, praesentium, sequi temporibus amet architecto? Commodi molestiae, in repellat fugit! Laudantium, fuga quia officiis error. Provident inventore iusto quas iure, expedita optio.

Eligendi recusandae eos sed alias delectus reprehenderit quaerat modi dolor commodi beatae temporibus nisi ullam ut, quae, animi esse in officia nesciunt sequi amet repellendus? Maiores quos provident nisi expedita.

Dolorem aspernatur repudiandae aperiam autem excepturi inventore explicabo molestiae atque, architecto consequatur ab quia quaerat deleniti quis ipsum alias itaque veritatis maiores consectetur minima facilis amet. Maiores impedit ipsum sint.

Consequuntur minus fugit vitae magnam illo quibusdam. Minima rerum, magnam nostrum id error temporibus odio molestias tempore vero, voluptas quam iusto. In laboriosam blanditiis, ratione consequuntur similique, quos repellendus ex!

Error suscipit odio modi blanditiis voluptatibus tempore minima ipsam accusantium id! Minus, ea totam veniam dolorem aspernatur repudiandae quae similique odio dolor, voluptate quis aut tenetur porro culpa odit aliquid.

Aperiam velit sed sit quaerat, expedita tempore aspernatur iusto nobis ipsam error ut sapiente delectus in minima recusandae dolore alias, cumque labore. Doloribus veritatis magni nisi odio voluptatum perferendis placeat!

Eaque laboriosam iusto corporis iure nemo ab deleniti ut facere laborum, blanditiis neque nihil dignissimos fuga praesentium illo facilis eos beatae accusamus cumque molestiae asperiores cupiditate? Provident laborum officiis suscipit!

Exercitationem odio nulla rerum soluta aspernatur fugit, illo iusto ullam similique. Recusandae consectetur rem, odio autem voluptate similique atque, alias possimus quis vitae in, officiis labore deserunt aspernatur rerum sunt?
''';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // Scroll ke bawah -> Sembunyikan
        if (_isToolbarVisible) {
          setState(() => _isToolbarVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // Scroll ke atas -> Tampilkan
        if (!_isToolbarVisible) {
          setState(() => _isToolbarVisible = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final primaryColor = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna Banner Info
    final bannerColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF2F3F8);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Hide Toolbar On Scroll',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: dividerColor, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          // Banner Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: bannerColor,
            child: Text(
              'Toolbar will be hidden if you scroll bottom',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _longLoremIpsum * 10, // Diperbanyak agar bisa scroll
                style: TextStyle(
                  fontSize: 15.0,
                  height: 1.4,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
      // Animated Toolbar Bawah
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _isToolbarVisible ? 48 : 0,
        child: Wrap(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: appBarColor, // Menggunakan warna toolbar/appbar
                border:
                    Border(top: BorderSide(color: dividerColor, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Left Link',
                        style: TextStyle(color: primaryColor, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Right Link',
                        style: TextStyle(color: primaryColor, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
