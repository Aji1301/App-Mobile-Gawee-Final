import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class CardsExpandablePage extends StatefulWidget {
  const CardsExpandablePage({super.key});

  @override
  State<CardsExpandablePage> createState() => _CardsExpandablePageState();
}

class _CardsExpandablePageState extends State<CardsExpandablePage> {
  // Data Konten Lengkap untuk Modal Framework7
  final String fullModalContent =
      'Framework7 – is a free and open source HTML mobile framework to develop hybrid mobile apps or web apps with iOS or Android (Material) native look and feel. It is also an indispensable prototyping apps tool to show working app prototype as soon as possible in case you need to. Framework7 is created by Vladimir Kharlampidi (iDangero.us).\n\nThe main approach of the Framework7 is to give you an opportunity to create iOS and Android (Material) apps with HTML, CSS and JavaScript easily and clear. Framework7 is full of freedom. It doesn\'t limit your imagination or offer ways of any solutions somehow. Framework7 gives you freedom!\n\nFramework7 is not compatible with all platforms. It is focused only on iOS and Android (Material) to bring the best experience and simplicity.\n\nFramework7 is definitely for you if you decide to build iOS and Android hybrid app (Cordova or Capacitor) or web app that looks like and feels as great native iOS or Android (Material) apps.';

  // 🎯 KONTEN LOREM IPSUM BARU UNTUK KARTU LAIN
  final String fullContentBeachMonkeys =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam cursus rhoncus cursus. Etiam lorem est, consectetur vitae tempor a, volutpat eget purus. Duis urna lectus, vehicula at quam id, sodales dapibus turpis. Suspendisse potenti. Proin condimentum luctus nulla, et rhoncus ante rutrum eu. Maecenas ut tincidunt diam. Vestibulum lacinia dui ligula, sit amet pulvinar nisl blandit luctus. Vestibulum aliquam ligula nulla, tincidunt rhoncus tellus interdum at. Phasellus mollis ipsum at mollis tristique. Maecenas sit amet tempus justo. Duis dolor elit, mollis quis viverra quis, vehicula eu ante. Integer a molestie risus. Vestibulum eu sollicitudin massa, sit amet dictum sem. Aliquam nisi tellus, maximus eget placerat in, porta vel lorem. Aenean tempus sodales nisl in cursus. Curabitur tincidunt turpis in nisl ornare euismod eget at libero.\n\nSuspendisse ligula eros, congue in nulla pellentesque, imperdiet blandit sapien. Morbi nisi sem, efficitur a rutrum porttitor, feugiat vel enim. Fusce eget vehicula odio, et luctus neque. Donec mattis a nulla laoreet commodo. Integer eget hendrerit augue, vel porta libero. Morbi imperdiet, eros at ultricies rutrum, eros urna auctor enim, eget laoreet massa diam vitae lorem. Proin eget urna ultrices, semper ligula aliquam, dignissim eros. Donec vitae augue eu sapien tristique elementum a nec nulla. Aliquam erat volutpat. Curabitur condimentum, metus blandit lobortis fringilla, enim mauris venenatis neque, et venenatis lorem urna ut justo. Maecenas neque enim, congue ac tempor quis, tincidunt ut mi. Donec venenatis ante non consequat molestie. Quisque ut rhoncus ligula. Vestibulum sodales maximus justo sit amet ornare. Nullam pulvinar eleifend nisi sit amet molestie.';

  final String introText =
      'In addition to usual Cards there are also Expandable Cards that allow to store more information and illustrations about particular subject.';

  // --- FUNGSI MODAL BARU (DITAMBAH PARAMETER WARNA TOMBOL & KONTEN) ---
  void _showCardModal(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color headerColor,
    required Color buttonColor, // 🎯 Tambah warna tombol
    required String fullContent, // 🎯 Tambah konten
    String? imageUrl,
  }) {
    // Ambil tema untuk modal
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // Menggunakan Navigator.of(context).push untuk modal full-screen
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return _ModalContent(
            title: title,
            subtitle: subtitle,
            headerColor: headerColor,
            fullContent: fullContent, // Gunakan konten yang disesuaikan
            buttonColor: buttonColor, // Gunakan warna tombol yang disesuaikan
            imageUrl: imageUrl,
            isDark: isDark, // Kirim status dark mode
            modalBgColor:
                isDark ? themeProvider.scaffoldColorDark : Colors.white,
            textColor: isDark ? Colors.white : Colors.black87,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Transisi Fade untuk modal
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // --- Widget Pembantu: Konten Kartu yang Dapat Diperluas ---
  Widget _buildExpandableCard({
    required String title,
    required String subtitle,
    required Color headerColor,
    required String uniqueKey,
    required Color buttonColor, // 🎯 Tambah parameter untuk tombol di sini juga
    required String fullContent, // 🎯 Tambah parameter untuk konten
    String? imageUrl,
  }) {
    final double headerHeight = imageUrl != null ? 280 : 230;
    const Color headerTextColor = Colors.white;

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: imageUrl != null ? Colors.white : headerColor,
      child: InkWell(
        onTap: () => _showCardModal(
          context,
          title: title,
          subtitle: subtitle,
          headerColor: headerColor,
          buttonColor: buttonColor, // 🎯 Kirim warna tombol
          fullContent: fullContent, // 🎯 Kirim konten
          imageUrl: imageUrl,
        ),
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: headerHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: imageUrl != null ? Colors.transparent : headerColor,
            borderRadius: BorderRadius.circular(10.0),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.15),
                      BlendMode.darken,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: headerTextColor,
                    shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: headerTextColor.withOpacity(0.9),
                      shadows: const [
                        Shadow(blurRadius: 5, color: Colors.black),
                      ],
                    ),
                  ),
              ],
            ),
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
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,

      // --- AppBar (Navbar) ---
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
            foregroundColor: textColor, // Warna icon & title dinamis
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Cards Expandable',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Text(
                introText,
                style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
              ),
            ),

            // ----------------------------------------------------
            // 1. Kartu Merah (Warna Solid) -> Tombol Merah Gelap
            // ----------------------------------------------------
            _buildExpandableCard(
              title: 'Framework7',
              subtitle: 'Build Mobile Apps',
              headerColor: Colors.red.shade700,
              uniqueKey: 'red',
              buttonColor: const Color(0xFFC0392B), // Merah Gelap Asli
              fullContent: fullModalContent,
            ),

            // ----------------------------------------------------
            // 2. Kartu Kuning (Warna Solid) -> Tombol Biru
            // ----------------------------------------------------
            _buildExpandableCard(
              title: 'Framework7',
              subtitle: 'Build Mobile Apps',
              headerColor: Colors.amber.shade700,
              uniqueKey: 'yellow',
              buttonColor: Colors.blue.shade700, // Tombol Biru
              fullContent: fullModalContent,
            ),

            // ----------------------------------------------------
            // 3. Kartu Gambar (Beach, Goa) -> Tombol Hijau
            // ----------------------------------------------------
            _buildExpandableCard(
              title: 'Beach, Goa',
              subtitle: '',
              headerColor: Colors.transparent,
              imageUrl: 'https://picsum.photos/id/1040/600/300',
              uniqueKey: 'beach',
              buttonColor: Colors.green.shade700, // Tombol Hijau
              fullContent: fullContentBeachMonkeys, // 🎯 Konten Lorem Ipsum
            ),

            // ----------------------------------------------------
            // 4. Kartu Gambar (Monkeys) -> Tombol Ungu
            // ----------------------------------------------------
            _buildExpandableCard(
              title: 'Monkeys',
              subtitle: '',
              headerColor: Colors.transparent,
              imageUrl: 'https://picsum.photos/id/1020/600/300',
              uniqueKey: 'monkeys',
              buttonColor: Colors.purple.shade700, // Tombol Ungu
              fullContent: fullContentBeachMonkeys, // 🎯 Konten Lorem Ipsum
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// KELAS UNTUK MODAL POPUP PENUH (MODIFIKASI FINAL)
// ----------------------------------------------------

class _ModalContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color headerColor;
  final String fullContent;
  final Color buttonColor; // 🎯 Terima warna tombol
  final String? imageUrl;
  final bool isDark;
  final Color modalBgColor;
  final Color textColor;

  const _ModalContent({
    required this.title,
    required this.subtitle,
    required this.headerColor,
    required this.fullContent,
    required this.buttonColor, // 🎯 Required
    this.imageUrl,
    required this.isDark,
    required this.modalBgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isImageCard = imageUrl != null;
    final Color modalHeaderColor =
        isImageCard ? Colors.red.shade700 : headerColor;

    return Scaffold(
      backgroundColor: modalBgColor, // Background dinamis
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Merah/Kuning/Gambar (Termasuk Tombol X yang ikut di-scroll) ---
            Container(
              height: isImageCard ? 300 : 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: modalHeaderColor,
                image: isImageCard
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.15),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Konten Judul di kiri atas Container
                  Positioned(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul di Kiri Bawah Container
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 5, color: Colors.black),
                            ],
                          ),
                        ),
                        // Subtitle
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              shadows: const [
                                Shadow(blurRadius: 5, color: Colors.black),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 🎯 Tombol Close (X) di Pojok Kanan Atas (ikut di-scroll)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Konten Teks Panjang (Disesuaikan)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                fullContent, // 🎯 Menggunakan fullContent yang disesuaikan
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: textColor, // Warna teks dinamis
                ),
              ),
            ),

            // Jarak sebelum tombol CLOSE
            const SizedBox(height: 30),

            // Tombol CLOSE yang ikut di-scroll (muncul di akhir konten)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        buttonColor, // 🎯 Gunakan warna tombol yang disesuaikan
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('CLOSE', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
