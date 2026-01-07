import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Pastikan path ini sesuai dengan lokasi file ThemeProvider Anda

// =======================================================
// BAGIAN 1: MODEL DATA (Tetap Sama)
// =======================================================

class TreeItemData {
  final String title;
  final IconData icon;
  final List<TreeItemData> children;
  final bool hasCheckbox;
  final bool isLink;
  final bool isSelectable;

  TreeItemData({
    required this.title,
    required this.icon,
    this.children = const [],
    this.hasCheckbox = false,
    this.isLink = false,
    this.isSelectable = false,
  });
}

class TreeGroup {
  final String title;
  final List<TreeItemData> data;

  TreeGroup({required this.title, required this.data});
}

// Data Sampel (Tetap Sama)
final List<TreeGroup> groupedTreeData = [
  TreeGroup(
    title: "Basic tree view",
    data: [
      TreeItemData(
        title: "Item 1",
        icon: Icons.folder_open,
        children: [
          TreeItemData(
            title: "Sub Item 1",
            icon: Icons.folder,
            children: [
              TreeItemData(title: "Sub Sub Item 1", icon: Icons.description),
              TreeItemData(title: "Sub Sub Item 2", icon: Icons.description),
            ],
          ),
          TreeItemData(
            title: "Sub Item 2",
            icon: Icons.folder,
            children: [
              TreeItemData(title: "Sub Sub Item 1", icon: Icons.description),
              TreeItemData(title: "Sub Sub Item 2", icon: Icons.description),
            ],
          ),
        ],
      ),
      TreeItemData(
        title: "Item 2",
        icon: Icons.folder_open,
        children: [
          TreeItemData(
            title: "Sub Item 1",
            icon: Icons.folder,
            children: [
              TreeItemData(title: "Sub Sub Item 1", icon: Icons.description),
              TreeItemData(title: "Sub Sub Item 2", icon: Icons.description),
            ],
          ),
          TreeItemData(
            title: "Sub Item 2",
            icon: Icons.folder,
            children: [
              TreeItemData(title: "Sub Sub Item 1", icon: Icons.description),
              TreeItemData(title: "Sub Sub Item 2", icon: Icons.description),
            ],
          ),
        ],
      ),
      TreeItemData(title: "Item 3", icon: Icons.description),
    ],
  ),
  TreeGroup(
    title: "With icons",
    data: [
      TreeItemData(
        title: "images",
        icon: Icons.folder,
        children: [
          TreeItemData(title: "avatar.png", icon: Icons.image),
          TreeItemData(title: "background.jpg", icon: Icons.image),
        ],
      ),
      TreeItemData(
        title: "documents",
        icon: Icons.folder,
        children: [
          TreeItemData(title: "cv.docx", icon: Icons.description),
          TreeItemData(title: "info.docx", icon: Icons.description),
        ],
      ),
      TreeItemData(title: ".gitignore", icon: Icons.code),
      TreeItemData(title: "index.html", icon: Icons.description),
    ],
  ),
  TreeGroup(
    title: "With checkboxes",
    data: [
      TreeItemData(
        title: "images",
        icon: Icons.folder,
        hasCheckbox: true,
        children: [
          TreeItemData(
            title: "avatar.png",
            icon: Icons.image,
            hasCheckbox: true,
          ),
          TreeItemData(
            title: "background.jpg",
            icon: Icons.image,
            hasCheckbox: true,
          ),
        ],
      ),
      TreeItemData(
        title: "documents",
        icon: Icons.folder,
        hasCheckbox: true,
        children: [
          TreeItemData(
            title: "cv.docx",
            icon: Icons.description,
            hasCheckbox: true,
          ),
          TreeItemData(
            title: "info.docx",
            icon: Icons.description,
            hasCheckbox: true,
          ),
        ],
      ),
      TreeItemData(title: ".gitignore", icon: Icons.code, hasCheckbox: true),
      TreeItemData(
        title: "index.html",
        icon: Icons.description,
        hasCheckbox: true,
      ),
    ],
  ),
  TreeGroup(
    title: "Whole item as toggle",
    data: [
      TreeItemData(
        title: "images",
        icon: Icons.folder,
        children: [
          TreeItemData(title: "avatar.png", icon: Icons.image),
          TreeItemData(title: "background.jpg", icon: Icons.image),
        ],
      ),
      TreeItemData(
        title: "documents",
        icon: Icons.folder,
        children: [
          TreeItemData(title: "cv.docx", icon: Icons.description),
          TreeItemData(title: "info.docx", icon: Icons.description),
        ],
      ),
      TreeItemData(title: ".gitignore", icon: Icons.code),
      TreeItemData(title: "index.html", icon: Icons.description),
    ],
  ),
  TreeGroup(
    title: "Selectable",
    data: [
      TreeItemData(
        title: "images",
        icon: Icons.folder,
        children: [
          TreeItemData(
            title: "avatar.png",
            icon: Icons.image,
            isSelectable: true,
          ),
          TreeItemData(
            title: "background.jpg",
            icon: Icons.image,
            isSelectable: true,
          ),
        ],
      ),
      TreeItemData(
        title: "documents",
        icon: Icons.folder,
        children: [
          TreeItemData(
            title: "cv.docx",
            icon: Icons.description,
            isSelectable: true,
          ),
          TreeItemData(
            title: "info.docx",
            icon: Icons.description,
            isSelectable: true,
          ),
        ],
      ),
      TreeItemData(title: ".gitignore", icon: Icons.code, isSelectable: true),
      TreeItemData(
        title: "index.html",
        icon: Icons.description,
        isSelectable: true,
      ),
    ],
  ),
  TreeGroup(
    title: "Preload children",
    data: [
      TreeItemData(
        title: "Users",
        icon: Icons.people,
        children: [
          TreeItemData(title: "John Doe", icon: Icons.person),
          TreeItemData(title: "Jane Doe", icon: Icons.person),
          TreeItemData(title: "Calvin Johnson", icon: Icons.person),
        ],
      ),
    ],
  ),
  TreeGroup(
    title: "With links",
    data: [
      TreeItemData(
        title: "Modals",
        icon: Icons.dashboard,
        children: [
          TreeItemData(title: "Popup", icon: Icons.link, isLink: true),
          TreeItemData(title: "Dialog", icon: Icons.link, isLink: true),
          TreeItemData(title: "Action Sheet", icon: Icons.link, isLink: true),
        ],
      ),
      TreeItemData(
        title: "Navigation Bars",
        icon: Icons.dashboard,
        children: [
          TreeItemData(title: "Navbar", icon: Icons.link, isLink: true),
          TreeItemData(
            title: "Toolbar & Tabbar",
            icon: Icons.link,
            isLink: true,
          ),
        ],
      ),
    ],
  ),
];

// =======================================================
// BAGIAN 2: UI SCREEN (TreeviewPage)
// =======================================================

class TreeviewPage extends StatelessWidget {
  const TreeviewPage({super.key});

  // Helper untuk judul bagian (Dinamis)
  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Treeview', style: TextStyle(color: textColor)),
        backgroundColor: appBarBgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (groupedTreeData.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Data TreeView kosong.',
                  style: TextStyle(color: textColor),
                ),
              )
            else
              ...groupedTreeData.expand((group) {
                return [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 0.0,
                      bottom: 8.0,
                    ),
                    // Gunakan primaryColor untuk header section
                    child: _buildSectionHeader(group.title, primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: group.data.map((item) {
                        return CustomTreeNode(item: item, level: 0);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ];
              }).toList(),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// BAGIAN 3: WIDGET NODE (CustomTreeNode)
// =======================================================

class CustomTreeNode extends StatefulWidget {
  final TreeItemData item;
  final int level;

  const CustomTreeNode({super.key, required this.item, required this.level});

  @override
  State<CustomTreeNode> createState() => _CustomTreeNodeState();
}

class _CustomTreeNodeState extends State<CustomTreeNode>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  bool _isChecked = false;
  bool _isSelected = false;
  Color _hoverColor = Colors.transparent;

  late AnimationController _rotationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: widget.item.children.isNotEmpty ? 1.0 : 0.0,
    );
    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(_rotationController);

    _isExpanded = widget.item.children.isNotEmpty;
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  // Menampilkan Modal (Push View) dengan Tema Dinamis
  void _showModal6(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final scaffoldBg = isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: scaffoldBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (modalContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: Scaffold(
            backgroundColor: scaffoldBg,
            appBar: AppBar(
              backgroundColor: primaryColor,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(modalContext),
              ),
              title: const Text(
                'New View (Push View)',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popup is a modal window with any HTML content that pops up over App\'s main content. Popup as all other overlays is part of so called "Temporary Views".',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    const SizedBox(height: 16),
                    _buildDynamicButton(context, 'Open Popup', _showModal2),
                    const SizedBox(height: 8),
                    _buildDynamicButton(
                        context, 'Create Dynamic Popup', _showModal3),
                    const SizedBox(height: 16),
                    Text(
                      'Swipe To Close',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor),
                    ),
                    Text(
                      'Popup can be closed with swipe to top or bottom:',
                      style: TextStyle(color: textColor),
                    ),
                    const SizedBox(height: 8),
                    _buildDynamicButton(context, 'Swipe To Close', _showModal4),
                    const SizedBox(height: 16),
                    Text(
                      'Or it can be closed with swipe on special swipe handler and, for example, only to bottom:',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    const SizedBox(height: 8),
                    _buildDynamicButton(
                        context, 'With Swipe Handler', _showModal5),
                    const SizedBox(height: 16),
                    Text(
                      'Push View',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor),
                    ),
                    Text(
                      'Popup can push view behind. By default it has effect only when "safe-area-inset-top" is more than zero (iOS fullscreen webapp or iOS cordova app)',
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                    const SizedBox(height: 8),
                    _buildDynamicButton(
                        context, 'Popup Push (Recursive)', _showModal6),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper untuk Tombol di Modal (Agar tidak berulang)
  Widget _buildDynamicButton(
      BuildContext context, String text, Function(BuildContext) onPressed) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ElevatedButton(
      onPressed: () => onPressed(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: themeProvider.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 40),
      ),
      child: Text(text),
    );
  }

  // --- Fungsi Modal Lainnya (Diteruskan ke DialogScreen di bawah tapi dipanggil dari sini) ---
  // Karena struktur kode asli menyatukan fungsi ini di widget berbeda, kita buat helper bridging
  // atau kita duplikasi logika theming sederhana di sini.
  // Untuk efisiensi, saya akan memanggil widget DialogScreen yang sudah di-theme.

  // NOTE: Fungsi _showModal2 dst di bawah ini adalah placeholder lokal agar _showModal6 bekerja.
  // Logika UI sebenarnya ada di DialogScreen, tapi di sini kita buat versi simple yang *Theme Aware*
  void _showModal2(BuildContext context) {
    // Implementasi sederhana untuk demo recursive
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Demo Popup opened")));
  }

  void _showModal3(BuildContext context) {}
  void _showModal4(BuildContext context) {}
  void _showModal5(BuildContext context) {}

  void _handleTap(BuildContext context) {
    setState(() {
      if (widget.item.isLink) {
        if (widget.item.title == 'Popup') {
          // Panggil modal dari DialogScreen (tapi karena state terpisah, kita push page baru atau panggil method static jika ada)
          // Di sini kita push ke DialogScreen agar konsisten
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DialogScreen()));
        } else if (widget.item.title == 'Dialog') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DialogScreen()),
          );
        } else {
          debugPrint('Link diklik: ${widget.item.title}');
        }
        return;
      }

      if (widget.item.hasCheckbox) {
        _isChecked = !_isChecked;
      }

      if (widget.item.isSelectable) {
        _isSelected = !_isSelected;
      }

      if (widget.item.children.isNotEmpty) {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _rotationController.forward();
        } else {
          _rotationController.reverse();
        }
      }
    });
  }

  void _handleCheckboxChange(bool? newValue) {
    if (newValue != null) {
      setState(() {
        _isChecked = newValue;
      });
    }
  }

  // Warna Background Baris (Dinamis)
  Color _getRowBackgroundColor(
      bool isDark, Color primaryColor, Color cardColor) {
    if (_hoverColor != Colors.transparent) {
      return isDark ? Colors.white10 : Colors.grey.shade100;
    }
    if (widget.item.isSelectable && _isSelected) {
      return primaryColor.withOpacity(isDark ? 0.2 : 0.1);
    }
    return Colors
        .transparent; // Default transparan agar warna scaffold terlihat
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    final double indent = widget.level * 20.0;

    final Widget verticalLine = Container(
      width: 4.0,
      height: 28.0,
      color: (widget.item.children.isNotEmpty && _isExpanded) ||
              (widget.item.isSelectable && _isSelected)
          ? primaryColor.withOpacity(0.8)
          : Colors.transparent,
    );

    final Widget arrowIcon = widget.item.children.isNotEmpty
        ? RotationTransition(
            turns: _iconAnimation,
            child: Icon(
              Icons.arrow_right,
              size: 24,
              color: iconColor,
            ),
          )
        : const SizedBox(width: 24);

    final content = MouseRegion(
      cursor: widget.item.isLink ||
              widget.item.hasCheckbox ||
              widget.item.isSelectable ||
              widget.item.children.isNotEmpty
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _hoverColor = Colors.grey.shade100);
      },
      onExit: (_) {
        setState(() => _hoverColor = Colors.transparent);
      },
      child: Container(
        color: _getRowBackgroundColor(
            isDark, primaryColor, themeProvider.cardColor),
        child: InkWell(
          onTap: () => _handleTap(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 16.0),
            child: Row(
              children: [
                SizedBox(width: indent),
                verticalLine,
                arrowIcon,
                if (widget.item.hasCheckbox)
                  Checkbox(
                    value: _isChecked,
                    onChanged: _handleCheckboxChange,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                    side: BorderSide(color: iconColor),
                  ),
                if (!widget.item.hasCheckbox) const SizedBox(width: 4),
                Icon(
                  widget.item.icon,
                  size: 20,
                  color: widget.item.isLink ? primaryColor : iconColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: widget.level == 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: widget.item.isLink ? primaryColor : textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        if (widget.item.children.isNotEmpty)
          ClipRect(
            child: Align(
              heightFactor: _isExpanded ? 1.0 : 0.0,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.item.children.map((child) {
                  return CustomTreeNode(
                    key: ValueKey('${child.title}_${widget.level + 1}'),
                    item: child,
                    level: widget.level + 1,
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

// =======================================================
// BAGIAN 4: SCREEN DIALOG (DialogScreen)
// =======================================================

class DialogScreen extends StatefulWidget {
  const DialogScreen({super.key});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  // Helper untuk membangun Dialog (Dinamis)
  Widget _buildCustomAlertDialog({
    required String title,
    required String content,
    required List<Widget> actions,
    required Color bgColor,
    required Color textColor,
  }) {
    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
      actions: actions,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
      actionsPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
    );
  }

  // --- 1. ALERT ---
  Future<void> _showAlert({String content = 'Hello!'}) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = themeProvider.primaryColor;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return _buildCustomAlertDialog(
          title: 'Framework7',
          content: content,
          bgColor: bgColor,
          textColor: textColor,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- 2. CONFIRM ---
  void _showConfirm() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = themeProvider.primaryColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _buildCustomAlertDialog(
          title: 'Framework7',
          content: 'Are you feel good today?',
          bgColor: bgColor,
          textColor: textColor,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showConfirmResult();
              },
              child: Text(
                'OK',
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmResult() {
    _showAlert(content: 'Great!');
  }

  // --- 3. PROMPT ---
  void _showPrompt() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = themeProvider.primaryColor;

    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Framework7',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter your name:',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Your Name',
                  hintStyle:
                      TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                String input = controller.text;
                Navigator.of(dialogContext).pop();
                _showAlert(content: 'Are you sure that your name is ?: $input');
              },
              child: Text(
                'OK',
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
            ),
          ],
          contentPadding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
          actionsPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
        );
      },
    );
  }

  void _showMultipleAlerts() async {
    await _showAlert(content: 'Alert 1: Click OK to open Alert 2.');
    await _showAlert(content: 'Alert 2: Click OK to open Alert 3.');
    await _showAlert(content: 'Alert 3: Stack finished!');
  }

  // --- 4. SHOW MODALS (Bottom Sheets & Dialogs) ---

  void _showModal1(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = themeProvider.primaryColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(20),
          title: Text('Popup', style: TextStyle(color: textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popup is a modal window with any HTML content that pops up over App\'s main content. Popup as all other overlays is part of so called "Temporary Views".',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              const SizedBox(height: 16),
              _buildFullWidthButton(context, 'Open Popup', onPressed: () {
                Navigator.pop(context);
                _showModal2(context);
              }),
              const SizedBox(height: 8),
              _buildFullWidthButton(context, 'Create Dynamic Popup',
                  onPressed: () {
                Navigator.pop(context);
                _showModal3(context);
              }),
              const SizedBox(height: 16),
              Text(
                'Swipe To Close',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              Text('Popup can be closed with swipe to top or bottom:',
                  style: TextStyle(color: textColor)),
              const SizedBox(height: 8),
              _buildFullWidthButton(context, 'Swipe To Close', onPressed: () {
                Navigator.pop(context);
                _showModal4(context);
              }),
              const SizedBox(height: 16),
              Text(
                'Or it can be closed with swipe on special swipe handler and, for example, only to bottom:',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              const SizedBox(height: 8),
              _buildFullWidthButton(context, 'With Swipe Handler',
                  onPressed: () {
                Navigator.pop(context);
                _showModal5(context);
              }),
              const SizedBox(height: 16),
              Text(
                'Push View',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              Text(
                'Popup can push view behind. By default it has effect only when "safe-area-inset-top" is more than zero (iOS fullscreen webapp or iOS cordova app)',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              const SizedBox(height: 8),
              _buildFullWidthButton(context, 'Popup Push', onPressed: () {
                Navigator.pop(context);
                _showModal6(context);
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showModal2(BuildContext context) {
    // Implementasi popup teks panjang (mirip _showModal1 tapi konten beda)
    // Untuk mempersingkat, saya menggunakan struktur _showAlert tapi konten custom
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        title: Text("Popup Title", style: TextStyle(color: textColor)),
        content: SingleChildScrollView(
          child: Text(
            "Here comes popup... (Long Text Placeholder)",
            style: TextStyle(color: textColor),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Close"))
        ],
      ),
    );
  }

  void _showModal3(BuildContext context) {
    // Dynamic popup
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: themeProvider.themeMode == ThemeMode.dark
                  ? themeProvider.cardColor
                  : Colors.white,
              title: Text("Dynamic Popup",
                  style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              content: Text("This popup was created dynamically",
                  style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Close"))
              ],
            ));
  }

  void _showModal4(BuildContext context) {
    // Swipe to close (BottomSheet)
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bgColor = themeProvider.themeMode == ThemeMode.dark
        ? themeProvider.cardColor
        : Colors.white;
    final textColor =
        themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Swipe To Close",
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Spacer(),
            Text("Swipe me down", style: TextStyle(color: textColor)),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _showModal5(BuildContext context) {
    _showModal4(context); // Reusing for simplicity
  }

  void _showModal6(BuildContext context) {
    // Push View (Recursive) - ini memanggil CustomTreeNode._showModal6 logic tapi dari dialog screen
    // Karena ini demo, kita tampilkan snackbar atau simple dialog
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Push View Demo")));
  }

  // --- Helper Widgets untuk DialogScreen ---

  Widget _buildSectionHeader(String title) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        bottom: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: themeProvider.primaryColor,
        ),
      ),
    );
  }

  Widget _buildDialogButton(
    BuildContext context,
    String text, {
    VoidCallback? onPressed,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    VoidCallback? currentOnPressed;

    if (text == 'Alert')
      currentOnPressed = _showAlert;
    else if (text == 'Confirm')
      currentOnPressed = _showConfirm;
    else if (text == 'Prompt')
      currentOnPressed = _showPrompt;
    else if (text == 'Popup')
      currentOnPressed = () => _showModal1(context); // Trigger popup menu
    else
      currentOnPressed = onPressed ?? () {};

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: currentOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeProvider.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(
    BuildContext context,
    String text, {
    VoidCallback? onPressed,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    VoidCallback? currentOnPressed;

    if (text == 'Open Multiple Alerts')
      currentOnPressed = _showMultipleAlerts;
    else
      currentOnPressed = onPressed ?? () {};

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: currentOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final scaffoldBg = isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBg = themeProvider.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Dialog', style: TextStyle(color: Colors.white)),
        backgroundColor: appBarBg,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'There are 1:1 replacements of native Alert, Prompt and Confirm modals...',
                style: TextStyle(fontSize: 15, color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  _buildDialogButton(context, 'Alert'),
                  _buildDialogButton(context, 'Confirm'),
                  _buildDialogButton(context, 'Prompt'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  _buildDialogButton(context, 'Login'),
                  _buildDialogButton(context, 'Password'),
                ],
              ),
            ),
            _buildSectionHeader('Vertical Buttons'),
            _buildFullWidthButton(context, 'Vertical Buttons'),
            _buildSectionHeader('Preloader Dialog'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  _buildDialogButton(context, 'Preloader'),
                  _buildDialogButton(context, 'Custom Text'),
                ],
              ),
            ),
            _buildSectionHeader('Progress Dialog'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  _buildDialogButton(context, 'Infinite'),
                  _buildDialogButton(context, 'Determined'),
                ],
              ),
            ),
            _buildSectionHeader('Dialogs Stack'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'This feature doesn\'t allow to open multiple dialogs at the same time...',
                style: TextStyle(fontSize: 15, color: textColor),
              ),
            ),
            _buildFullWidthButton(context, 'Open Multiple Alerts'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}