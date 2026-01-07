import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Adjust this path to your ThemeProvider location

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  // Use Provider to get colors instead of static const

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
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

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
            title: const Text(
              'Dialog',
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
            // Description
            Text(
              'There are 1:1 replacements of native Alert, Prompt and Confirm modals. They support callbacks, have very easy api and can be combined with each other. Check these examples:',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 20),

            // --- 1. Basic Dialogs ---
            Row(
              children: [
                Expanded(
                  child: _buildPurpleButton(
                    'Alert',
                    () => _showAlert(context),
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPurpleButton(
                    'Confirm',
                    () => _showConfirm(context),
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPurpleButton(
                    'Prompt',
                    () => _showPrompt(context),
                    primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildPurpleButton(
                    'Login',
                    () => _showLogin(context),
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPurpleButton(
                    'Password',
                    () => _showPassword(context),
                    primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 2. Vertical Buttons ---
            _buildTitle('Vertical Buttons', primaryColor),
            _buildPurpleButton(
              'Vertical Buttons',
              () => _showVerticalButtons(context),
              primaryColor,
              isFullWidth: true,
            ),
            const SizedBox(height: 24),

            // --- 3. Preloader Dialog ---
            _buildTitle('Preloader Dialog', primaryColor),
            Row(
              children: [
                Expanded(
                  child: _buildPurpleButton(
                    'Preloader',
                    () => _showPreloader(context),
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPurpleButton(
                    'Custom Text',
                    () => _showPreloader(context, text: 'Loading Data...'),
                    primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 4. Progress Dialog ---
            _buildTitle('Progress Dialog', primaryColor),
            Row(
              children: [
                Expanded(
                  child: _buildPurpleButton(
                    'Infinite',
                    () => _showInfiniteProgress(context),
                    primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPurpleButton(
                    'Determined',
                    () => _showDeterminedProgress(context),
                    primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 5. Dialogs Stack ---
            _buildTitle('Dialogs Stack', primaryColor),
            Text(
              'This feature doesn\'t allow to open multiple dialogs at the same time, and will automatically open next dialog when you close the current one. Such behavior is similar to browser native dialogs:',
              style: TextStyle(fontSize: 14, color: subtitleColor),
            ),
            const SizedBox(height: 10),
            _buildPurpleButton(
              'Open Multiple Alerts',
              () => _showDialogsStack(context),
              primaryColor,
              isFullWidth: true,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPurpleButton(
    String text,
    VoidCallback onPressed,
    Color color, {
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // --- Dialog Functions (Updated for Theme) ---

  // Helper to retrieve theme data inside callbacks
  (Color primary, Color bg, Color text, Color subText) _getThemeColors(
      BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return (
      themeProvider.primaryColor,
      isDark ? themeProvider.cardColor : Colors.white,
      isDark ? Colors.white : Colors.black87,
      isDark ? Colors.white70 : Colors.grey.shade600
    );
  }

  void _showAlert(BuildContext context,
      {String title = 'Framework7', String content = 'Hello!'}) {
    final colors = _getThemeColors(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        title: Text(title, style: TextStyle(color: colors.$3)),
        content: Text(content, style: TextStyle(color: colors.$3)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: colors.$1)),
          ),
        ],
      ),
    );
  }

  void _showConfirm(BuildContext context) async {
    final colors = _getThemeColors(context);

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        title: Text('Framework7', style: TextStyle(color: colors.$3)),
        content: Text('Are you feel good today?',
            style: TextStyle(color: colors.$3)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: colors.$4)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('OK', style: TextStyle(color: colors.$1)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (context.mounted)
        _showAlert(context, title: 'Framework7', content: 'Great!');
    }
  }

  void _showPrompt(BuildContext context) async {
    final colors = _getThemeColors(context);
    TextEditingController controller = TextEditingController();

    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        title: Text('Framework7', style: TextStyle(color: colors.$3)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: colors.$3),
          decoration: InputDecoration(
            hintText: "What is your name?",
            hintStyle: TextStyle(color: colors.$4),
            enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: colors.$4)),
            focusedBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: colors.$1)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('Cancel', style: TextStyle(color: colors.$4)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('OK', style: TextStyle(color: colors.$1)),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty && context.mounted) {
      _showPromptConfirmChain(context, name: name);
    }
  }

  void _showPromptConfirmChain(BuildContext context,
      {required String name}) async {
    final colors = _getThemeColors(context);

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        title: Text('Framework7', style: TextStyle(color: colors.$3)),
        content: Text('Are you sure that your name is $name?',
            style: TextStyle(color: colors.$3)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: colors.$4)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('OK', style: TextStyle(color: colors.$1)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      _showAlert(context,
          title: 'Framework7', content: 'Ok, your name is $name');
    }
  }

  void _showLogin(BuildContext context) async {
    final colors = _getThemeColors(context);
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    bool? submitted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        title: Text('Framework7', style: TextStyle(color: colors.$3)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your username and password',
                style: TextStyle(color: colors.$3)),
            const SizedBox(height: 15),
            TextField(
              controller: usernameController,
              style: TextStyle(color: colors.$3),
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(color: colors.$4),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.$4)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.$1)),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: colors.$3),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: colors.$4),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.$4)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.$1)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: colors.$4)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('OK', style: TextStyle(color: colors.$1)),
          ),
        ],
      ),
    );

    if (submitted == true && context.mounted) {
      String username =
          usernameController.text.isEmpty ? 'N/A' : usernameController.text;
      String password =
          passwordController.text.isEmpty ? 'N/A' : passwordController.text;

      _showAlert(context,
          title: 'Framework7',
          content: 'Thank you!\nUsername: $username\nPassword: $password');
    }
  }

  void _showPassword(BuildContext context) async {
    final colors = _getThemeColors(context);
    TextEditingController controller = TextEditingController();

    String? passwordInput = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        title: Text('Framework7', style: TextStyle(color: colors.$3)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your password', style: TextStyle(color: colors.$3)),
            TextField(
              controller: controller,
              obscureText: true,
              style: TextStyle(color: colors.$3),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: colors.$4),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.$4)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.$1)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('Cancel', style: TextStyle(color: colors.$4)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('OK', style: TextStyle(color: colors.$1)),
          ),
        ],
      ),
    );

    if (passwordInput != null && context.mounted) {
      String displayedPassword =
          passwordInput.isEmpty ? '[kosong]' : passwordInput;
      _showAlert(context,
          title: 'Framework7',
          content: 'Password yang dimasukkan: $displayedPassword');
    }
  }

  void _showVerticalButtons(BuildContext context) {
    final colors = _getThemeColors(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        title: Text('Vertical Buttons',
            textAlign: TextAlign.center, style: TextStyle(color: colors.$3)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style:
                  TextButton.styleFrom(minimumSize: const Size.fromHeight(40)),
              child: Text('Button 1',
                  style: TextStyle(fontSize: 16, color: colors.$1)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style:
                  TextButton.styleFrom(minimumSize: const Size.fromHeight(40)),
              child: Text('Button 2',
                  style: TextStyle(fontSize: 16, color: colors.$1)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style:
                  TextButton.styleFrom(minimumSize: const Size.fromHeight(40)),
              child: Text('Button 3',
                  style: TextStyle(fontSize: 16, color: colors.$1)),
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        titlePadding: const EdgeInsets.only(top: 24, bottom: 8),
        actions: const [],
      ),
    );
  }

  void _showPreloader(BuildContext context, {String text = 'Loading...'}) {
    final colors = _getThemeColors(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        content: Row(
          children: [
            CircularProgressIndicator(color: colors.$1),
            const SizedBox(width: 20),
            Text(text, style: TextStyle(color: colors.$3)),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showInfiniteProgress(BuildContext context) {
    _showPreloader(context, text: 'Fetching...');
  }

  void _showDeterminedProgress(BuildContext context) {
    final colors = _getThemeColors(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: colors.$2,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Processing... (Simulasi)',
                style: TextStyle(color: colors.$3)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
                value: 0.75,
                color: colors.$1,
                backgroundColor: colors.$4.withOpacity(0.2)),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showDialogsStack(BuildContext context) async {
    final colors = _getThemeColors(context);

    // Helper to keep code DRY inside stack
    Future<void> showStackedAlert(String title, String msg) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: colors.$2,
          title: Text(title, style: TextStyle(color: colors.$3)),
          content: Text(msg, style: TextStyle(color: colors.$3)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: colors.$1)),
            ),
          ],
        ),
      );
    }

    await showStackedAlert('Alert 1', 'Ini alert pertama.');
    await showStackedAlert('Alert 2', 'Ini alert kedua.');
    await showStackedAlert('Alert 3', 'Ini alert ketiga.');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Semua dialog stack sudah ditampilkan.'),
          backgroundColor: colors.$1,
        ),
      );
    }
  }
}
