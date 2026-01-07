// lib/swipeout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class SwipeoutPage extends StatefulWidget {
  const SwipeoutPage({super.key});

  @override
  State<SwipeoutPage> createState() => _SwipeoutPageState();
}

class _SwipeoutPageState extends State<SwipeoutPage> {
  // --- Data State untuk Lists ---
  final List<Map<String, dynamic>> _listWithConfirm = [
    {'id': 'c1', 'title': 'Swipe left on me please', 'icon': true},
    {'id': 'c2', 'title': 'Swipe left on me too', 'icon': true},
    {
      'id': 'c3',
      'title': 'I am not removable',
      'icon': true,
      'removable': false
    },
  ];
  final List<Map<String, dynamic>> _listWithoutConfirm = [
    {'id': 'nc1', 'title': 'Swipe left on me please', 'icon': false},
    {'id': 'nc2', 'title': 'Swipe left on me too', 'icon': false},
    {
      'id': 'nc3',
      'title': 'I am not removable',
      'icon': false,
      'removable': false
    },
  ];
  final List<Map<String, dynamic>> _listForActions = [
    {'id': 'a1', 'title': 'Swipe left on me please', 'icon': true},
    {'id': 'a2', 'title': 'Swipe left on me too', 'icon': true},
    {
      'id': 'a3',
      'title': 'You can\'t delete me',
      'icon': true,
      'removable': false
    },
  ];
  final List<Map<String, dynamic>> _listSwipeRight = [
    {'id': 'r1', 'title': 'Swipe right on me please', 'icon': true},
    {'id': 'r2', 'title': 'Swipe right on me too', 'icon': true},
  ];
  final List<Map<String, dynamic>> _listInbox = [
    {
      'id': 'i1',
      'title': 'Facebook',
      'subtitle': 'New messages from John Doe',
      'time': '17:14'
    },
    {
      'id': 'i2',
      'title': 'John Doe (via Twitter)',
      'subtitle': 'John Doe (@_johndoe) mentioned you on Twitter...',
      'time': '17:11'
    },
    {
      'id': 'i3',
      'title': 'Facebook',
      'subtitle': 'New messages from John Doe',
      'time': '16:48'
    },
    {
      'id': 'i4',
      'title': 'John Doe (via Twitter)',
      'subtitle': 'John Doe (@_johndoe) mentioned you on Twitter...',
      'time': '15:32'
    },
  ];

  // --- Helper: Judul Bagian (Dinamis) ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor, // Mengikuti tema
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --- Helper: Deskripsi (Dinamis) ---
  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.4,
          color: textColor, // Mengikuti tema
        ),
      ),
    );
  }

  // --- Helper: Container Latar Belakang List (Dinamis) ---
  Widget _buildListContainer(List<Widget> children, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor, // Mengikuti tema
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(children: children),
      ),
    );
  }

  // --- Aksi: Tampilkan Konfirmasi Hapus ---
  void _showDeleteConfirmDialog(
      BuildContext context, String id, List listData) {
    // Ambil tema di dalam dialog
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final dialogBg = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text('Framework7', style: TextStyle(color: textColor)),
        content: Text('Are you sure you want to delete this item?',
            style: TextStyle(color: textColor)),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel',
                style: TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w500)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text('OK',
                style: TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w500)),
            onPressed: () {
              Navigator.of(ctx).pop(true);
              _deleteItem(id, listData);
            },
          ),
        ],
      ),
    );
  }

  // --- Aksi: Tampilkan "Mark" Dialog ---
  void _showMarkDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final dialogBg = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text('Framework7', style: TextStyle(color: textColor)),
        content: Text('Mark', style: TextStyle(color: textColor)),
        actions: <Widget>[
          TextButton(
            child: Text('OK',
                style: TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w500)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  // --- Aksi: Tampilkan "More" Action Sheet ---
  void _showMoreActionsSheet(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final sheetBg = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Here comes some optional description or warning for actions below',
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                title: Text('Action 1',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor)),
                onTap: () => Navigator.of(ctx).pop(),
              ),
              ListTile(
                title: Text('Action 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor)),
                onTap: () => Navigator.of(ctx).pop(),
              ),
              Container(
                  height: 8,
                  color: isDark ? Colors.black12 : Colors.grey[200]), // Pemisah
              ListTile(
                title: Text('Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor)),
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Aksi: Hapus Item dari List ---
  void _deleteItem(String id, List listData) {
    setState(() {
      listData.removeWhere((item) => item['id'] == id);
    });
  }

  // --- Aksi: Tampilkan Callback ---
  void _showCallbackSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removal callback triggered!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // --- Helper: Membangun Item List Biasa (Slidable & Dinamis) ---
  Widget _buildSlidableItem({
    required Map<String, dynamic> item,
    required List listData,
    required Color itemBgColor,
    required Color textColor,
    required Color primaryColor,
    bool confirmDelete = false,
    bool showMoreAction = false,
    bool swipeRight = false,
  }) {
    final bool isRemovable = item['removable'] ?? true;
    final bool hasIcon = item['icon'] ?? false;

    final deleteAction = SlidableAction(
      onPressed: (context) {
        if (confirmDelete) {
          _showDeleteConfirmDialog(context, item['id'], listData);
        } else {
          _deleteItem(item['id'], listData);
          _showCallbackSnackbar(context);
        }
      },
      backgroundColor: const Color(0xFFF44336),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Delete',
    );

    final moreAction = SlidableAction(
      onPressed: (context) => _showMoreActionsSheet(context),
      backgroundColor: const Color(0xFF2196F3),
      foregroundColor: Colors.white,
      icon: Icons.more_horiz,
      label: 'More',
    );

    return Slidable(
      key: ValueKey(item['id']),
      enabled: isRemovable,
      startActionPane: swipeRight
          ? ActionPane(
              motion: const DrawerMotion(),
              children: [moreAction],
            )
          : null,
      endActionPane: !swipeRight
          ? ActionPane(
              motion: const DrawerMotion(),
              children: [
                if (showMoreAction) moreAction,
                deleteAction,
              ],
            )
          : null,
      child: Container(
        color: itemBgColor, // Background item dinamis
        child: ListTile(
          leading: hasIcon
              ? CircleAvatar(
                  backgroundColor: primaryColor, // Mengikuti tema
                  foregroundColor: Colors.white,
                  child: Icon(item['icon_data'] ?? Icons.camera),
                )
              : null,
          title: Text(item['title'], style: TextStyle(color: textColor)),
        ),
      ),
    );
  }

  // --- Helper: Membangun Item Inbox (Slidable & Dinamis) ---
  Widget _buildInboxItem(Map<String, dynamic> item, List listData,
      Color itemBgColor, Color textColor, Color subtitleColor) {
    return Slidable(
      key: ValueKey(item['id']),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            icon: Icons.reply,
            label: 'Reply',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _showMoreActionsSheet(context),
            backgroundColor: Colors.grey.shade500,
            foregroundColor: Colors.white,
            icon: Icons.more_horiz,
            label: 'More',
          ),
          SlidableAction(
            onPressed: (context) => _showMarkDialog(context),
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            icon: Icons.bookmark,
            label: 'Mark',
          ),
          SlidableAction(
            onPressed: (context) =>
                _showDeleteConfirmDialog(context, item['id'], listData),
            backgroundColor: const Color(0xFFF44336),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        color: itemBgColor, // Background item dinamis
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['title'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor)),
              Text(item['time'],
                  style: TextStyle(fontSize: 14, color: subtitleColor)),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              item['subtitle'],
              style: TextStyle(fontSize: 14, color: subtitleColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing:
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
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

    // Background Scaffold
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;

    // Background Container List (Wadah besar)
    // Mode Gelap: Transparan (menyatu dengan scaffold) atau Card Color
    // Mode Terang: Warna ungu muda (0xFFF7F2FF) atau Primary pudar
    final listContainerBgColor =
        isDark ? Colors.transparent : primaryColor.withOpacity(0.05);

    // Background Item List (Item kecil)
    final itemBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white60 : Colors.black54;

    // Warna Divider & AppBar
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
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
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Swipeout'),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescription(
              'Swipe out actions on list elements is one of the most awesome F7 features. It allows you to call hidden menu for each list element where you can put default ready-to use delete button or any other buttons for some required actions.',
              textColor,
            ),
            _buildSectionTitle(
                'Swipe to delete with confirm modal', primaryColor),
            _buildListContainer(
              _listWithConfirm
                  .map((item) => _buildSlidableItem(
                        item: item,
                        listData: _listWithConfirm,
                        itemBgColor: itemBgColor,
                        textColor: textColor,
                        primaryColor: primaryColor,
                        confirmDelete: true,
                      ))
                  .toList(),
              listContainerBgColor,
            ),
            _buildSectionTitle('Swipe to delete without confirm', primaryColor),
            _buildListContainer(
              _listWithoutConfirm
                  .map((item) => _buildSlidableItem(
                        item: item,
                        listData: _listWithoutConfirm,
                        itemBgColor: itemBgColor,
                        textColor: textColor,
                        primaryColor: primaryColor,
                        confirmDelete: false,
                      ))
                  .toList(),
              listContainerBgColor,
            ),
            _buildSectionTitle('Swipe for actions', primaryColor),
            _buildListContainer(
              _listForActions
                  .map((item) => _buildSlidableItem(
                        item: item,
                        listData: _listForActions,
                        itemBgColor: itemBgColor,
                        textColor: textColor,
                        primaryColor: primaryColor,
                        confirmDelete: true,
                        showMoreAction: true,
                      ))
                  .toList(),
              listContainerBgColor,
            ),
            _buildSectionTitle('With callback on remove', primaryColor),
            _buildListContainer(
              _listWithoutConfirm
                  .map((item) => _buildSlidableItem(
                        item: item,
                        listData: _listWithoutConfirm,
                        itemBgColor: itemBgColor,
                        textColor: textColor,
                        primaryColor: primaryColor,
                        confirmDelete: false,
                      ))
                  .toList(),
              listContainerBgColor,
            ),
            _buildSectionTitle(
                'With actions on left side (swipe to right)', primaryColor),
            _buildListContainer(
              _listSwipeRight
                  .map((item) => _buildSlidableItem(
                        item: item,
                        listData: _listSwipeRight,
                        itemBgColor: itemBgColor,
                        textColor: textColor,
                        primaryColor: primaryColor,
                        swipeRight: true,
                      ))
                  .toList(),
              listContainerBgColor,
            ),
            _buildSectionTitle('On both sides with overswipes', primaryColor),
            _buildListContainer(
              _listInbox
                  .map((item) => _buildInboxItem(
                      item, _listInbox, itemBgColor, textColor, subtitleColor))
                  .toList(),
              listContainerBgColor,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
