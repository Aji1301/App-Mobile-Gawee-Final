import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// Warna Kustom (Tetap dipertahankan untuk contoh variasi warna gauge)
const Color gaugeOrange = Color(0xFFFF9800);
const Color gaugeGreen = Color(0xFF4CAF50);
const Color gaugeRed = Color(0xFFD32F2F);
const Color gaugePink = Color(0xFFC2185B);
const Color gaugeYellow = Color(0xFFFFEB3B);

// ----------------------------------------------------
// 1. Gauge Painter (Tidak Berubah)
// ----------------------------------------------------
class GaugePainter extends CustomPainter {
  final double value; // Nilai 0.0 sampai 1.0
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final bool isSemicircle;

  GaugePainter({
    required this.value,
    required this.color,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.strokeWidth = 10.0,
    this.isSemicircle = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, radius);

    // Sudut awal dan akhir
    final double startAngle = isSemicircle ? pi : -pi / 2;
    // final double sweepAngle = isSemicircle ? pi * value : 2 * pi * value; // Unused variable warning removed

    // 1. Busur Belakang (Background)
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(isSemicircle ? 0.3 : 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double backgroundSweep = isSemicircle ? pi : 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      backgroundSweep,
      false,
      backgroundPaint,
    );

    // 2. Busur Nilai (Value)
    final Paint valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      isSemicircle ? pi * value : 2 * pi * value,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

// ----------------------------------------------------
// 2. Widget Gauge Dasar (Dinamis dengan Tema)
// ----------------------------------------------------
class GaugeWidget extends StatelessWidget {
  final Animation<double> valueAnimation;
  final Color color;
  final Widget? centerContent;
  final double size;
  final double strokeWidth;
  final bool isSemicircle;
  final Color? backgroundColor;

  const GaugeWidget({
    super.key,
    required this.valueAnimation,
    required this.color,
    this.centerContent,
    this.size = 150,
    this.strokeWidth = 12,
    this.isSemicircle = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil info tema untuk styling default
    final isDark =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    final defaultTextColor = isDark ? Colors.white : Colors.black87;
    final defaultTrackColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;

    return AnimatedBuilder(
      animation: valueAnimation,
      builder: (context, child) {
        final currentValue = valueAnimation.value;

        // Konten default jika centerContent tidak disediakan
        final defaultCenterContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(currentValue * 100).toInt()}%',
              style: TextStyle(
                fontSize: isSemicircle ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: defaultTextColor, // Warna teks dinamis
              ),
            ),
            if (!isSemicircle)
              const Text(
                'amount of something',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        );

        return Container(
          width: size,
          height: isSemicircle ? size / 2 : size,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: isSemicircle ? size : size,
                child: CustomPaint(
                  painter: GaugePainter(
                    value: currentValue,
                    color: color,
                    backgroundColor: backgroundColor ??
                        defaultTrackColor, // Warna track dinamis
                    strokeWidth: strokeWidth,
                    isSemicircle: isSemicircle,
                  ),
                ),
              ),
              centerContent ?? defaultCenterContent,
            ],
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------
// 3. Gauge Page (Halaman Utama)
// ----------------------------------------------------
class GaugePage extends StatefulWidget {
  const GaugePage({super.key});

  @override
  State<GaugePage> createState() => _GaugePageState();
}

class _GaugePageState extends State<GaugePage> {
  double _mainGaugeTargetValue = 0.0;

  // Widget Pembantu: Judul Bagian (Dinamis)
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryColor, // Mengikuti tema
        ),
      ),
    );
  }

  // Widget Pembantu: Tombol Persentase Interaktif (Dinamis)
  Widget _buildPercentButton(
      String label, double value, Color primaryColor, bool isDark) {
    final bool isSelected =
        (_mainGaugeTargetValue * 100).toInt() == (value * 100).toInt();

    return Expanded(
      child: Container(
        height: 40,
        margin: EdgeInsets.only(right: label != '100%' ? 4.0 : 0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _mainGaugeTargetValue = value;
            });
          },
          style: ElevatedButton.styleFrom(
            // Warna aktif mengikuti primaryColor, tidak aktif putih/gelap
            backgroundColor: isSelected
                ? primaryColor
                : (isDark ? Colors.grey[800] : Colors.white),
            foregroundColor: isSelected ? Colors.white : primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.grey[700]! : Colors.grey.shade400),
                width: 1.0,
              ),
            ),
            elevation: 0,
            padding: EdgeInsets.zero,
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Teks & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor =
        isDark ? Colors.white60 : Colors.black54; // Untuk deskripsi
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

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
              'Gauge',
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
            // Teks Pengantar
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Framework7 comes with Gauge component. It produces nice looking fully responsive SVG gauges.',
                style:
                    TextStyle(fontSize: 16, height: 1.4, color: subtitleColor),
              ),
            ),

            // ----------------------------------------------------
            // GAUGE UTAMA INTERAKTIF
            // ----------------------------------------------------
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: _mainGaugeTargetValue),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double value, Widget? child) {
                  return GaugeWidget(
                    valueAnimation: AlwaysStoppedAnimation(value),
                    color: primaryColor, // Menggunakan warna tema
                    size: 200,
                    strokeWidth: 15,
                    centerContent: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(value * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: primaryColor, // Warna teks mengikuti tema
                          ),
                        ),
                        const Text(
                          'amount of something',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Persentase
            Row(
              children: [
                _buildPercentButton('0%', 0.0, primaryColor, isDark),
                _buildPercentButton('25%', 0.25, primaryColor, isDark),
                _buildPercentButton('50%', 0.50, primaryColor, isDark),
                _buildPercentButton('75%', 0.75, primaryColor, isDark),
                _buildPercentButton('100%', 1.0, primaryColor, isDark),
              ],
            ),
            const SizedBox(height: 30),

            // ----------------------------------------------------
            // 1. Circle Gauges
            // ----------------------------------------------------
            _buildSectionTitle('Circle Gauges', primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Gauge 1: Orange 44% (Tetap orange sebagai variasi)
                const GaugeWidget(
                  valueAnimation: AlwaysStoppedAnimation(0.44),
                  color: gaugeOrange,
                  size: 140,
                  centerContent: Text(
                    '44%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: gaugeOrange,
                    ),
                  ),
                ),
                // Gauge 2: Green Budget (Tetap hijau sebagai variasi)
                const GaugeWidget(
                  valueAnimation: AlwaysStoppedAnimation(0.12),
                  color: gaugeGreen,
                  size: 140,
                  centerContent: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$120',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: gaugeGreen,
                        ),
                      ),
                      Text(
                        'of \$1000 budget',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ----------------------------------------------------
            // 2. Semicircle Gauges
            // ----------------------------------------------------
            _buildSectionTitle('Semicircle Gauges', primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Gauge 1: Red 30%
                const GaugeWidget(
                  valueAnimation: AlwaysStoppedAnimation(0.30),
                  color: gaugeRed,
                  size: 140,
                  isSemicircle: true,
                  strokeWidth: 8,
                ),
                // Gauge 2: Pink 30kg
                const GaugeWidget(
                  valueAnimation: AlwaysStoppedAnimation(0.5),
                  color: gaugePink,
                  size: 140,
                  isSemicircle: true,
                  strokeWidth: 8,
                  centerContent: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '30kg',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: gaugePink,
                        ),
                      ),
                      Text(
                        'of 60kg total',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ----------------------------------------------------
            // 3. Customization
            // ----------------------------------------------------
            _buildSectionTitle('Customization', primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Gauge 1: Yellow/Green (Custom Colors)
                GaugeWidget(
                  valueAnimation: const AlwaysStoppedAnimation(0.35),
                  color: gaugeGreen,
                  size: 140,
                  strokeWidth: 20,
                  backgroundColor: gaugeYellow.withOpacity(0.5),
                  centerContent: const Text(
                    '35%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: gaugeYellow,
                    ),
                  ),
                ),
                // Gauge 2: Orange Budget Spent
                const GaugeWidget(
                  valueAnimation: AlwaysStoppedAnimation(0.67),
                  color: gaugeOrange,
                  size: 140,
                  strokeWidth: 20,
                  centerContent: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$670',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: gaugeOrange,
                        ),
                      ),
                      Text(
                        'of \$1000 spent',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Gauge 3: Semicircle Custom Yellow
                const GaugeWidget(
                  valueAnimation: AlwaysStoppedAnimation(0.50),
                  color: gaugeYellow,
                  size: 140,
                  isSemicircle: true,
                  strokeWidth: 15,
                  centerContent: Text(
                    '50%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: gaugeYellow,
                    ),
                  ),
                ),
                // Gauge 4: Semicircle Custom Orange Text
                const GaugeWidget(
                  valueAnimation: AlwaysStoppedAnimation(0.77),
                  color: gaugeOrange,
                  size: 140,
                  isSemicircle: true,
                  strokeWidth: 15,
                  centerContent: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$770',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: gaugeOrange,
                        ),
                      ),
                      Text(
                        'spent so far',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
