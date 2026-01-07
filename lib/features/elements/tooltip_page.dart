import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // PASTIKAN path ini sesuai dengan lokasi file ThemeProvider Anda

// ----------------------------------------------------
// Data Dummy
// ----------------------------------------------------
final String longLorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec lacinia augue urna, in tincidunt augue hendrerit ut. In nulla massa, facilisis non consectetur a, tempus semper ex. Proin eget volutpat nisl. Integer lacinia maximus nunc molestie viverra. ⓘ Etiam ullamcorper ultricies ipsum, ut congue tortor rutrum at. Vestibulum rutrum risus a orci dictum, in placerat leo finibus. Sed a congue enim, ut dictum felis. Aliquam erat volutpat. Etiam id nisi in magna egestas malesuada. Sed vitae orci sollicitudin, accumsan nisi a, bibendum felis. Maecenas risus libero, gravida ut tincidunt auctor, ⓘ aliquam non lectus. Nam laoreet turpis erat, eget bibendum leo suscipit nec.\n\nVestibulum ⓘ gravida dui magna, eget pulvinar ligula molestie hendrerit. Mauris vitae facilisis justo. Nam velit mi, pharetra sit amet luctus quis, consectetur a tellus. Maecenas ac magna sit amet eros aliquam rhoncus. Ut dapibus vehicula lectus, ac blandit felis ultricies at. In sollicitudin, lorem eget volutpat viverra, magna ⓘ felis tempus nisl, porta consectetur nunc neque eget risus. Phasellus vestibulum leo at ante ornare, vel congue justo tincidunt.";

// ----------------------------------------------------
// 1. Tooltip Manager (Mengelola Overlay)
// ----------------------------------------------------
class TooltipManager {
  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext context,
    GlobalKey targetKey,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool isPersistent = false,
  }) {
    dismiss();

    // Pastikan konteks valid dan RenderBox ditemukan
    final RenderBox? renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Tentukan posisi X & Y untuk tooltip
    final double targetCenterX = position.dx + size.width / 2;
    final double targetTopY = position.dy;

    // Hitung posisi horizontal yang lebih baik
    double calculatedLeft = targetCenterX - 150;
    if (calculatedLeft < 10) calculatedLeft = 10;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: targetTopY - 10, // Sedikit di atas ikon
        left: calculatedLeft,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _CustomTooltip(
              message: message,
              targetWidth: size.width,
              targetGlobalX: position.dx,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Hanya gunakan Future.delayed jika tidak persistent
    if (!isPersistent) {
      Future.delayed(duration, dismiss);
    }
  }

  static void dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

// ----------------------------------------------------
// 2. Custom Tooltip Widget
// ----------------------------------------------------
class _CustomTooltip extends StatelessWidget {
  final String message;
  final double targetWidth;
  final double targetGlobalX;

  const _CustomTooltip({
    required this.message,
    required this.targetWidth,
    required this.targetGlobalX,
  });

  @override
  Widget build(BuildContext context) {
    // Mengambil warna card dari provider agar konsisten dengan tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Background tooltip mengikuti warna card tema
    final bgColor = themeProvider.cardColor;
    final textColor = isDark ? Colors.white : const Color(0xFF333333);

    return GestureDetector(
      onTap: TooltipManager.dismiss, // Tutup ketika di-tap
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.15), // Menggunakan withValues
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          // Tambahan border tipis di mode gelap agar terlihat jelas
          border: isDark ? Border.all(color: Colors.white12) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 3. Tooltip Page (Halaman Utama)
// ----------------------------------------------------
class TooltipPage extends StatefulWidget {
  const TooltipPage({super.key});

  @override
  State<TooltipPage> createState() => _TooltipPageState();
}

class _TooltipPageState extends State<TooltipPage> {
  final GlobalKey _infoIconKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  // Kunci unik untuk ikon di dalam teks panjang
  final List<GlobalKey> _textIconKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  // --- Widget Pembantu: Ikon Info di Teks ---
  Widget _buildInfoIconInText(GlobalKey key, String message, Color iconColor) {
    return GestureDetector(
      key: key,
      onTap: () {
        TooltipManager.show(
          context,
          key,
          message,
          duration: const Duration(seconds: 4),
        );
      },
      child: Icon(Icons.info_outline, size: 16, color: iconColor),
    );
  }

  // --- Widget Pembantu: Tombol Dinamis ---
  Widget _buildDynamicButton(
      String title, GlobalKey key, String message, Color btnColor) {
    return Container(
      key: key,
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton(
        onPressed: () {
          TooltipManager.show(context, key, message, isPersistent: true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- INTEGRASI THEME PROVIDER ---
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Warna Primer (Ungu atau yang dipilih user)
    final primaryColor = themeProvider.primaryColor;

    // Warna Scaffold (Background Halaman)
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;

    // Warna Teks
    final mainTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    // Warna Content Block (Kotak Lorem Ipsum)
    // Mode Gelap = Card Color, Mode Terang = Primary Color pudar (5%)
    final contentBlockColor = isDark
        ? themeProvider.cardColor
        : primaryColor.withValues(alpha: 0.05); // Menggunakan withValues

    // Warna App Bar & Divider
    final appBarBgColor = isDark ? Colors.transparent : scaffoldBgColor;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Membagi teks panjang menjadi bagian-bagian dengan ikon info di dalamnya
    final List<String> parts = longLorem.split('ⓘ');

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
            foregroundColor: mainTextColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Tooltip',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                key: _infoIconKey,
                icon: Icon(Icons.info_outline, color: mainTextColor),
                onPressed: () {
                  TooltipManager.show(
                    context,
                    _infoIconKey,
                    "One more tooltip with more text and custom formatting",
                    isPersistent: true,
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Teks Pengantar ---
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tooltips display informative text when users hover over, or tap an target element.',
                    style: TextStyle(
                        fontSize: 16, height: 1.4, color: mainTextColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tooltip can be positioned around any element with any HTML content inside.',
                    style: TextStyle(
                        fontSize: 16, height: 1.4, color: mainTextColor),
                  ),
                ],
              ),
            ),

            // --- Teks Panjang dengan Ikon Info ---
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: contentBlockColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: mainTextColor,
                  ),
                  children: List.generate(parts.length, (index) {
                    final List<InlineSpan> span = [
                      TextSpan(text: parts[index]),
                    ];
                    if (index < parts.length - 1) {
                      span.add(
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _buildInfoIconInText(
                            _textIconKeys[index],
                            'Tooltip message for icon ${index + 1}',
                            secondaryTextColor,
                          ),
                        ),
                      );
                    }
                    return TextSpan(children: span);
                  }),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- Auto Initialization Section ---
            Text(
              'Auto Initialization',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor, // Mengikuti warna tema
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "For simple cases when you don't need a lot of control over the Tooltip, it can be initialized automatically with tooltip-init class and data-tooltip attribute:",
              style: TextStyle(fontSize: 16, height: 1.4, color: mainTextColor),
            ),
            const SizedBox(height: 24),

            // Tombol "Button with Tooltip"
            _buildDynamicButton(
              'Button with Tooltip',
              _buttonKey,
              "Button tooltip text",
              primaryColor,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
