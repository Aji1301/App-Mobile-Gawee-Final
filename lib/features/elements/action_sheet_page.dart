import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Adjust path to your ThemeProvider

class ActionSheetPage extends StatelessWidget {
  ActionSheetPage({super.key});

  final List<String> buttonTitles = ['One group', 'Two groups'];

  @override
  Widget build(BuildContext context) {
    // 1. Get Theme Data
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // 2. Define Dynamic Colors
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final blockBorderColor = isDark ? Colors.white24 : const Color(0xFFE0E0E0);
    final containerBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar ---
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Action Sheet',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      // --- Body ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24),

            // --- Button Wrapper ---
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: containerBgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: blockBorderColor, width: 1.0),
              ),
              child: Column(
                children: [
                  // Group Buttons
                  Row(
                    children: buttonTitles.map((title) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: title == 'One group' ? 8.0 : 0,
                          ),
                          child: _buildActionButton(
                            context,
                            title,
                            height: 40.0,
                            color: primaryColor,
                            onTap: () => _showFullGroupActionSheet(context),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  // Grid Button
                  _buildActionButton(
                    context,
                    'Action Grid',
                    height: 40.0,
                    color: primaryColor,
                    onTap: () => _showGridActionSheet(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Info Block Title ---
            Text(
              'Action Sheet To Popover',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),

            // --- Info Block ---
            _buildInfoBlock(context, containerBgColor, textColor, primaryColor),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper: Action Button ---
  Widget _buildActionButton(
    BuildContext context,
    String title, {
    required double height,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          minimumSize: Size(double.infinity, height),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  // --- Helper: Info Block ---
  Widget _buildInfoBlock(BuildContext context, Color bgColor, Color textColor,
      Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text.rich(
        TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
          children: <TextSpan>[
            const TextSpan(
              text:
                  'Action Sheet can be automatically converted to Popover (for tablets). This button will open Popover on tablets and Action Sheet on phones: ',
            ),
            TextSpan(
              text: 'Actions',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _showSimpleGroupActionSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  // --- Action Sheet Logic (Updated with Theme) ---

  // Type 1: Full Group Action Sheet
  void _showFullGroupActionSheet(BuildContext context) {
    // Get theme data inside the callback
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final sheetBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    // Primary button color logic: use primaryColor for consistency
    final actionButtonColor = primaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: sheetBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title
              ListTile(
                title: Text(
                  'Do something',
                  style: TextStyle(color: primaryColor, fontSize: 14),
                ),
                onTap: () {},
              ),
              // Button 1
              ListTile(
                title: Text(
                  'Button 1',
                  style: TextStyle(
                    color: actionButtonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Button 2
              ListTile(
                title: Text(
                  'Button 2',
                  style: TextStyle(
                    color: actionButtonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Cancel
              ListTile(
                title: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Type 2: Grid Action Sheet
  void _showGridActionSheet(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final sheetBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black54;

    final List<Map<String, dynamic>> gridItems = [
      {
        'label': 'Button 1',
        'icon': Icons.person,
        'image': 'https://picsum.photos/id/1005/60/60'
      },
      {
        'label': 'Button 2',
        'icon': Icons.image,
        'image': 'https://picsum.photos/id/237/60/60'
      },
      {
        'label': 'Button 3',
        'icon': Icons.camera,
        'image': 'https://picsum.photos/id/177/60/60'
      },
      {
        'label': 'Button 1',
        'icon': Icons.videocam,
        'image': 'https://picsum.photos/id/1084/60/60'
      },
      {
        'label': 'Button 2',
        'icon': Icons.audiotrack,
        'image': 'https://picsum.photos/id/1018/60/60'
      },
      {
        'label': 'Button 3',
        'icon': Icons.settings,
        'image': 'https://picsum.photos/id/1025/60/60'
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: sheetBgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // First Row
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return _buildGridItem(gridItems[index], textColor);
                    },
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? Colors.white12 : const Color(0xFFE0E0E0),
                  ),
                  const SizedBox(height: 8),

                  // Second Row
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return _buildGridItem(gridItems[index + 3], textColor);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridItem(Map<String, dynamic> item, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item['image'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(width: 60, height: 60, color: Colors.grey[200]);
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: Center(
                child: Icon(item['icon'], size: 30, color: textColor),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item['label'],
          style: TextStyle(fontSize: 14, color: textColor),
        ),
      ],
    );
  }

  // Type 3: Simple Group Action Sheet
  void _showSimpleGroupActionSheet(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;
    final sheetBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE0E0E0);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: sheetBgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Do something',
                  style: TextStyle(color: primaryColor, fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Button 1',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Button 2',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(height: 1, thickness: 1, color: dividerColor),
              ListTile(
                title: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
