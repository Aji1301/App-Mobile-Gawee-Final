import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// ====================================================================
// TEMPLATE KONTEN DAN DATA
// ====================================================================

// Konten teks panjang untuk semua tab
const String contentForAllTabs = '''
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam enim quia molestiae facilis laudantium voluptates obcaecati officia cum, sit libero commodi. Ratione illo suscipit temporibus sequi iure ad laboriosam accusamus?

Saepe explicabo voluptas ducimus provident, doloremque quo totam molestias! Suscipit blanditiis eaque exercitationem praesentium reprehenderit, fuga accusamus possimus sed, sint facilis ratione quod, qui dignissimos voluptas! Aliquam rerum consequuntur deleniti.

Totam reprehenderit amet commodi ipsum nam provident doloremque possimus odio itaque, est animi culpa modi consequatur reiciendis corporis libero laudantium sed eveniet unde delectus a maiores nihil dolores? Natus, perferendis.
''';

// Daftar teks header yang dinamis
const List<String> tabHeaders = [
  'Tab 1 content',
  'Tab 2 content',
  'Tab 3 content',
];

// Widget pembangun konten tab (Diperbarui agar menerima warna teks)
Widget _buildTabContent(String content, Color textColor) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Text(
        content,
        style: TextStyle(fontSize: 14, height: 1.5, color: textColor),
      ),
    ),
  );
}

// ====================================================================
// 1. Halaman Utama: TabsPage (Menu Navigasi)
// ====================================================================

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Definisi Warna Dinamis
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white70 : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE0E0E0);
    final chevronColor = isDark ? Colors.white24 : Colors.grey.shade400;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: iconColor,
        ),
        title: Text('Tabs', style: TextStyle(color: textColor)),
        backgroundColor: cardColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: cardColor,
            child: Column(
              children: [
                _buildTabsItem(context, 'Static Tabs', const StaticTabsPage(),
                    textColor, chevronColor, dividerColor),
                _buildTabsItem(
                    context,
                    'Animated Tabs',
                    const AnimatedTabsPage(),
                    textColor,
                    chevronColor,
                    dividerColor),
                _buildTabsItem(
                    context,
                    'Swipeable Tabs',
                    const SwipeableTabsPage(),
                    textColor,
                    chevronColor,
                    dividerColor),
                _buildTabsItem(
                    context,
                    'Routable Tabs',
                    const RoutableTabsPage(),
                    textColor,
                    chevronColor,
                    dividerColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsItem(
    BuildContext context,
    String title,
    Widget? destinationPage,
    Color textColor,
    Color chevronColor,
    Color dividerColor,
  ) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          trailing: Icon(
            Icons.chevron_right,
            color: chevronColor,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          onTap: () {
            if (destinationPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destinationPage),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Navigasi ke: $title (Belum Diimplementasikan)',
                  ),
                ),
              );
            }
          },
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: dividerColor,
          indent: 16,
        ),
      ],
    );
  }
}

// ====================================================================
// 2. Halaman Target 1: StaticTabsPage (Transisi Instan, Non-Swipeable)
// ====================================================================

class StaticTabsPage extends StatefulWidget {
  const StaticTabsPage({super.key});

  @override
  State<StaticTabsPage> createState() => _StaticTabsPageState();
}

class _StaticTabsPageState extends State<StaticTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration.zero, // Transisi Instan
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_currentTabIndex != _tabController.index) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final unselectedColor = isDark ? Colors.white54 : Colors.black54;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: textColor,
        ),
        title: Text(
          'Static Tabs',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: cardColor,
        elevation: 0.5,
      ),
      body: Column(
        children: <Widget>[
          // Header Dinamis
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tabHeaders[_currentTabIndex],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          // Konten Tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Non-Swipeable
              children: <Widget>[
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1.0),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
          labelColor: primaryColor, // Mengikuti tema
          unselectedLabelColor: unselectedColor,
          indicatorColor: primaryColor,
          indicatorWeight: 2.0,
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
    );
  }
}

// ====================================================================
// 3. Halaman Target 2: AnimatedTabsPage (Transisi Slide, Non-Swipeable)
// ====================================================================

class AnimatedTabsPage extends StatefulWidget {
  const AnimatedTabsPage({super.key});

  @override
  State<AnimatedTabsPage> createState() => _AnimatedTabsPageState();
}

class _AnimatedTabsPageState extends State<AnimatedTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_currentTabIndex != _tabController.index) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final unselectedColor = isDark ? Colors.white54 : Colors.black54;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: textColor,
        ),
        title: Text(
          'Animated Tabs',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: cardColor,
        elevation: 0.5,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tabHeaders[_currentTabIndex],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1.0),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
          labelColor: primaryColor,
          unselectedLabelColor: unselectedColor,
          indicatorColor: primaryColor,
          indicatorWeight: 2.0,
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
    );
  }
}

// ====================================================================
// 4. Halaman Target 3: SwipeableTabsPage (Transisi Slide, Swipeable)
// ====================================================================

class SwipeableTabsPage extends StatefulWidget {
  const SwipeableTabsPage({super.key});

  @override
  State<SwipeableTabsPage> createState() => _SwipeableTabsPageState();
}

class _SwipeableTabsPageState extends State<SwipeableTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_currentTabIndex != _tabController.index) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final unselectedColor = isDark ? Colors.white54 : Colors.black54;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: textColor,
        ),
        title: Text(
          'Swipeable Tabs',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: cardColor,
        elevation: 0.5,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tabHeaders[_currentTabIndex],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              // Physics default: Mengizinkan swipe
              children: <Widget>[
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1.0),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
          labelColor: primaryColor,
          unselectedLabelColor: unselectedColor,
          indicatorColor: primaryColor,
          indicatorWeight: 2.0,
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
    );
  }
}

// ====================================================================
// 5. Halaman Target 4: RoutableTabsPage (Transisi Instan, Non-Swipeable)
// ====================================================================

class RoutableTabsPage extends StatefulWidget {
  const RoutableTabsPage({super.key});

  @override
  State<RoutableTabsPage> createState() => _RoutableTabsPageState();
}

class _RoutableTabsPageState extends State<RoutableTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration.zero,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_currentTabIndex != _tabController.index) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final unselectedColor = isDark ? Colors.white54 : Colors.black54;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: textColor,
        ),
        title: Text(
          'Tabs Routable',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: cardColor,
        elevation: 0.5,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tabHeaders[_currentTabIndex],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
                _buildTabContent(contentForAllTabs, textColor),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1.0),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
          labelColor: primaryColor,
          unselectedLabelColor: unselectedColor,
          indicatorColor: primaryColor,
          indicatorWeight: 2.0,
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
    );
  }
}
