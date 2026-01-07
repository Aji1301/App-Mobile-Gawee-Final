import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini

// --- IMPORT HALAMAN COMPONENT LAMA ---
import 'about_page.dart';
import 'accordion_page.dart';
import 'action_sheet_page.dart';
import 'badge_page.dart';
import 'buttons_page.dart';
import 'appbar_page.dart';
import 'cards_page.dart';
import 'cards_expandable_page.dart';
import 'checkbox_page.dart';
import 'chips_page.dart';
import 'contacts_list_page.dart';
import 'content_block_page.dart';
import 'data_table_page.dart';
import 'dialog_page.dart';
import 'fab_page.dart';
import 'fab_morph_page.dart';
import 'form_storage_page.dart';
import 'infinite_scroll_page.dart';
import 'form_inputs_page.dart';
import 'list_view_page.dart';
import 'timeline_page.dart';
import 'tabs_page.dart';
import 'treeview_page.dart';
import 'virtual_list_page.dart';
import 'elevation_page.dart';
import 'gauge_page.dart';
import 'grid_layout_page.dart';
import 'icons_page.dart';
import 'lazy_load_page.dart';
import 'list_index_page.dart';
import 'login_screen_page.dart';
import 'menu_page.dart';
import 'navbar_page.dart';
import 'notifications_page.dart';
import 'panel_page.dart';
import 'radio_page.dart';
import 'sortable_list_page.dart';
import 'text_editor_page.dart';
import 'toast_page.dart';
import 'tooltip_page.dart';
import 'toggle_page.dart';

// --- 🚀 IMPORT HALAMAN BARU ---
import 'popover_page.dart';
import 'skeleton_layout_page.dart';
import 'swipeout_page.dart';
import 'swiper_slider_page.dart';
import 'popup_page.dart';
import 'preloader_page.dart';
import 'progress_bar_page.dart';
import 'range_slider_page.dart';
import 'searchbar_page.dart';
import 'searchbar_expandable_page.dart';
import 'sheet_modal_page.dart';
import 'smart_select_page.dart';
import 'stepper_page.dart';
import 'subnavbar_page.dart';
import 'calendar_page.dart';
import 'photo_browser_page.dart';
import 'color_picker_page.dart';
import 'picker_page.dart';
import 'toolbar_tabbar_page.dart';
import 'autocomplete_page.dart';

// --- IMPORT UNTUK FITUR DRAWER ---
import '../../features/recent_job/screens/recent_job_page.dart';
import '../../features/find_job/screens/find_job_screen.dart';
import '../../features/notification/screens/notification_screen.dart';
import '../../features/profile/screens/profile_page.dart';
import '../../features/chat/screens/chat_list_screen.dart';
import '../../settings/setting_page.dart';
import '../../screens/login_screen.dart';
import '../../screens/dashboard_screen.dart';

// ==========================================
// 1. CLASS UTAMA: FRAMEWORK7 HOME PAGE
// ==========================================

// Data untuk item-item di bagian Components
final List<String> componentItems = [
  'Accordion',
  'Action Sheet',
  'Appbar',
  'Autocomplete',
  'Badge',
  'Buttons',
  'Calendar / Date Picker',
  'Cards',
  'Cards Expandable',
  'Checkbox',
  'Chips / Tags',
  'Color Picker',
  'Contacts List',
  'Content Block',
  'Data Table',
  'Dialog',
  'Elevation',
  'FAB',
  'FAB Morph',
  'Form Storage',
  'Gauge',
  'Grid / Layout Grid',
  'Icons',
  'Infinite Scroll',
  'Inputs',
  'Lazy Load',
  'List View',
  'List Index',
  'Login Screen',
  'Menu',
  'Messages',
  'Navbar',
  'Notifications',
  'Panel / Side Panels',
  'Photo Browser',
  'Picker',
  'Popover',
  'Popup',
  'Preloader',
  'Progress Bar',
  'Radio',
  'Range Slider',
  'Searchbar',
  'Searchbar Expandable',
  'Sheet Modal',
  'Skeleton (Ghost) Layouts',
  'Smart Select',
  'Sortable List',
  'Stepper',
  'Subnavbar',
  'Swipeout (Swipe To Delete)',
  'Swipe Slider',
  'Tabs',
  'Text Editor',
  'Timeline',
  'Toast',
  'Toggle',
  'Toolbar & Tabbar',
  'Tooltip',
  'Treeview',
  'Virtual List',
  'VI- Mobile Vidio SSP',
];

class Framework7HomePage extends StatelessWidget {
  const Framework7HomePage({super.key});

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
    final appBarBgColor = isDark ? themeProvider.cardColor : scaffoldBgColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final headerColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : Colors.grey.shade300;

    // Warna Khusus Item
    final itemIconBgColor = isDark ? Colors.grey[800]! : Colors.grey.shade100;
    final primaryItemBgColor = isDark
        ? themeProvider.cardColor
        : Color.lerp(Colors.white, primaryColor, 0.08) ?? Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // Drawer memanggil CustomDrawerBody yang ada DI BAWAH file ini
      drawer: Drawer(
        backgroundColor: cardColor, // Mengikuti tema
        child: const CustomDrawerBody(),
      ),

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
            // Tombol Menu Drawer
            leading: Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu, size: 28, color: textColor),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            title: Text(
              'Framework7',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: textColor),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.search, size: 28, color: textColor),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Framework7',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: headerColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Item "About Framework7"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildListItem(
                context,
                icon: Icons.work_outline,
                title: 'About Framework7',
                iconColor: primaryColor,
                backgroundColor: primaryItemBgColor, // Background dinamis
                isPrimaryButton: true,
                isCustomVI: false,
                textColor: textColor,
                blockBorderColor: dividerColor,
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Components',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Daftar Komponen
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor, // Mengikuti tema
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: dividerColor, width: 1.0),
                ),
                child: Column(
                  children: componentItems.map((title) {
                    bool isVIItem = title == 'VI- Mobile Vidio SSP';
                    return _buildListItem(
                      context,
                      icon:
                          isVIItem ? Icons.close : Icons.shopping_bag_outlined,
                      title: title,
                      iconColor: primaryColor,
                      backgroundColor:
                          itemIconBgColor, // Background icon dinamis
                      isPrimaryButton: false,
                      isCustomVI: isVIItem,
                      textColor: textColor,
                      blockBorderColor: dividerColor,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- FUNGSI PEMBANTU _buildListItem ---
  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color backgroundColor,
    required bool isPrimaryButton,
    required bool isCustomVI,
    required Color textColor,
    required Color blockBorderColor,
  }) {
    Widget iconWidget;

    if (isCustomVI) {
      iconWidget = Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(6)),
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.yellow[600],
              shape: BoxShape.circle,
              border: Border.all(color: blockBorderColor, width: 1.0),
            ),
            child: const Center(
                child: Text('vi',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))),
          ),
        ),
      );
    } else if (isPrimaryButton) {
      iconWidget = Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6)),
        child: Center(
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: iconColor.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 1))
              ],
            ),
            child: Center(
                child:
                    Icon(icon, color: Colors.white.withOpacity(0.9), size: 16)),
          ),
        ),
      );
    } else {
      iconWidget = Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(6)),
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 14),
          ),
        ),
      );
    }

    // --- LOGIKA NAVIGASI ---
    VoidCallback? onTapFunction;
    Widget? page;

    switch (title) {
      case 'About Framework7':
        page = const AboutPage();
        break;
      case 'Accordion':
        page = const AccordionPage();
        break;
      case 'Action Sheet':
        page = ActionSheetPage();
        break;
      case 'Badge':
        page = const BadgePage();
        break;
      case 'Buttons':
        page = const ButtonsPage();
        break;
      case 'Appbar':
        page = const AppbarPage();
        break;
      case 'Cards':
        page = const CardsPage();
        break;
      case 'Cards Expandable':
        page = const CardsExpandablePage();
        break;
      case 'Checkbox':
        page = const CheckboxPage();
        break;
      case 'Chips / Tags':
        page = ChipsPage();
        break;
      case 'Contacts List':
        page = const ContactListPage();
        break;
      case 'Content Block':
        page = const ContentBlockPage();
        break;
      case 'Data Table':
        page = const DataTablePage();
        break;
      case 'Dialog':
        page = const DialogPage();
        break;
      case 'FAB':
        page = const FabPage();
        break;
      case 'FAB Morph':
        page = const FabMorphPage();
        break;
      case 'Form Storage':
        page = const FormStoragePage();
        break;
      case 'Infinite Scroll':
        page = const InfiniteScrollPage();
        break;
      case 'Inputs':
        page = const FormInputsPage();
        break;
      case 'List View':
        page = const ListViewPage();
        break;
      case 'Timeline':
        page = const TimelinePage();
        break;
      case 'Tabs':
        page = const TabsPage();
        break;
      case 'Treeview':
        page = const TreeviewPage();
        break;
      case 'Virtual List':
        page = const HomePage();
        break;
      case 'Elevation':
        page = const ElevationPage();
        break;
      case 'Gauge':
        page = const GaugePage();
        break;
      case 'Grid / Layout Grid':
        page = const GridLayoutPage();
        break;
      case 'Icons':
        page = const IconsPage();
        break;
      case 'Lazy Load':
        page = const LazyLoadPage();
        break;
      case 'List Index':
        page = const ListIndexPage();
        break;
      case 'Login Screen':
        page = const LoginScreenLayout();
        break;
      case 'Menu':
        page = const MenuPage();
        break;
      case 'Messages':
        page = const ChatListScreen(); // Menggunakan import yang sudah ada
        break;
      case 'Navbar':
        page = const NavbarOptionsPage();
        break;
      case 'Notifications':
        page = const NotificationsPage();
        break;
      case 'Panel / Side Panels':
        page = const PanelPage();
        break;
      case 'Radio':
        page = const RadioPage();
        break;
      case 'Sortable List':
        page = const SortableListPage();
        break;
      case 'Text Editor':
        page = const TextEditorPage();
        break;
      case 'Toast':
        page = const ToastPage();
        break;
      case 'Toggle':
        page = const TogglePage();
        break;
      case 'Tooltip':
        page = const TooltipPage();
        break;
      case 'Popover':
        page = const PopoverPage();
        break;
      case 'Skeleton (Ghost) Layouts':
        page = const SkeletonLayoutPage();
        break;
      case 'Swipeout (Swipe To Delete)':
        page = const SwipeoutPage();
        break;
      case 'Swipe Slider':
        page = const SwiperSliderPage();
        break;
      case 'Popup':
        page = const PopupPage();
        break;
      case 'Preloader':
        page = const PreloaderPage();
        break;
      case 'Progress Bar':
        page = const ProgressBarPage();
        break;
      case 'Range Slider':
        page = const RangeSliderPage();
        break;
      case 'Searchbar':
        page = const SearchbarPage();
        break;
      case 'Searchbar Expandable':
        page = const SearchbarExpandablePage();
        break;
      case 'Sheet Modal':
        page = const SheetModalPage();
        break;
      case 'Smart Select':
        page = const SmartSelectPage();
        break;
      case 'Stepper':
        page = const StepperPage();
        break;
      case 'Subnavbar':
        page = const SubnavbarPage();
        break;
      case 'Calendar / Date Picker':
        page = const CalendarPage();
        break;
      case 'Photo Browser':
        page = const PhotoBrowserPage();
        break;
      case 'Color Picker':
        page = const ColorPickerPage();
        break;
      case 'Picker':
        page = const PickerPage();
        break;
      case 'Toolbar & Tabbar':
        page = const ToolbarTabbarPage();
        break;
      case 'Autocomplete':
        page = const AutocompletePage();
        break;
      default:
        onTapFunction = () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Navigasi untuk "$title" belum diimplementasikan.')),
            );
    }

    if (page != null) {
      onTapFunction = () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page!));
    }

    return InkWell(
      onTap: onTapFunction,
      child: Container(
        decoration: isPrimaryButton
            ? BoxDecoration(
                color: backgroundColor, borderRadius: BorderRadius.circular(10))
            : null,
        padding: isPrimaryButton
            ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0)
            : const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            iconWidget,
            const SizedBox(width: 12),
            Expanded(
                child: Text(title,
                    style: TextStyle(fontSize: 16, color: textColor))),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. CLASS DRAWER (DIPINDAHKAN KESINI)
// ==========================================
class CustomDrawerBody extends StatelessWidget {
  const CustomDrawerBody({super.key});

  // --- FUNGSI NAVIGASI ---
  void _pushPage(BuildContext context, Widget page) {
    Navigator.pop(context); // Tutup drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _pushReplacementPage(BuildContext context, Widget page) {
    Navigator.pop(context); // Tutup drawer
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  // FUNGSI LOGOUT
  void _logout(BuildContext context) {
    Navigator.pop(context); // Tutup drawer
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    final closeBtnColor = isDark ? Colors.grey[800] : Colors.black87;

    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Material(
      color: cardColor, // Mengikuti tema
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 18, 18),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === HEADER ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.work, color: primaryColor, size: 40),
                  const SizedBox(width: 12),
                  Text(
                    'Gawee',
                    style: GoogleFonts.poppins(
                      color: primaryColor, // Mengikuti tema
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: closeBtnColor, // Dinamis
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // === DAFTAR MENU ===
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // 1. HOME
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/dashboard') {
                          _pushReplacementPage(context, const DashboardPage());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        highlighted: currentRoute == '/dashboard',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 2. RECENT JOB
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/recent_job') {
                          _pushPage(context, const RecentJobScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.article_outlined,
                        label: 'Recent Job',
                        highlighted: currentRoute == '/recent_job',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 3. FIND JOB
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/find_job') {
                          _pushPage(context, const FindJobScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.desktop_windows,
                        label: 'Find Job',
                        highlighted: currentRoute == '/find_job',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 4. NOTIFICATIONS
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/notifications') {
                          _pushPage(context, const NotificationScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.notifications_none_outlined,
                        label: 'Notifications (2)',
                        highlighted: currentRoute == '/notifications',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 5. PROFILE
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/profile') {
                          _pushPage(context, const ProfilePage());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        highlighted: currentRoute == '/profile',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 6. MESSAGE
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/chat_list') {
                          _pushPage(context, const ChatListScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.mail_outline,
                        label: 'Message',
                        highlighted: currentRoute == '/chat_list',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 7. ELEMENTS (Halaman Ini)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: _DrawerItem(
                        icon: Icons.grid_view,
                        label: 'Elements',
                        highlighted: true, // Highlighted True
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 8. SETTING
                    GestureDetector(
                      onTap: () {
                        if (currentRoute != '/settings') {
                          _pushPage(context, const SettingPage());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: _DrawerItem(
                        icon: Icons.settings_outlined,
                        label: 'Setting',
                        highlighted: currentRoute == '/settings',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),

                    // 9. LOGOUT
                    GestureDetector(
                      onTap: () => _logout(context),
                      child: _DrawerItem(
                        icon: Icons.logout,
                        label: 'Logout',
                        primaryColor: primaryColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),
              ),

              // === FOOTER ===
              Text('Gawee Job Portal',
                  style: GoogleFonts.poppins(color: subTextColor)),
              const SizedBox(height: 4),
              Text('App Version 1.3',
                  style: GoogleFonts.poppins(
                      color: subTextColor.withOpacity(0.5), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Item Menu Drawer Helper (Dinamis)
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  final Color primaryColor;
  final Color textColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.highlighted = false,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color highlightBg = primaryColor.withOpacity(0.1);
    final Color itemColor = label == 'Logout'
        ? Colors.red.shade600
        : (highlighted ? primaryColor : textColor);

    return InkWell(
      onTap: null, // onTap ditangani parent
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: highlighted ? highlightBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: itemColor, size: 24),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: itemColor,
                  fontSize: 15,
                  fontWeight: highlighted ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
