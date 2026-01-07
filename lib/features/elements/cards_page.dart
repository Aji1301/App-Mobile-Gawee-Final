import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  // --- Data Dummy ---
  static const String dummyText =
      'Cards are a great way to contain and organize your information, especially when combined with List Views. Cards can contain unique related data, like for example photos, text or links about a particular subject. Cards are typically an entry point to more complex and detailed information.';
  static const String loremIpsum =
      'Another card. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse feugiat sem est, non tincidunt ligula volutpat sit amet. Mauris aliquet magna justo.';
  static const String cardHeader = 'Card header';
  static const String cardFooter = 'Card Footer';
  static const String simpleCardText =
      'This is a simple card with plain text, but cards can also contain their own header, footer, list view, image, or any other element.';
  static const String smallText =
      'Card with header and footer. Card headers are used to display card titles and footers for additional information or just for custom actions.';

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F2FF);

    // Warna Kartu & Teks
    final cardBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor =
        isDark ? Colors.white60 : Colors.black54; // Untuk teks sekunder/footer

    // Warna Garis/Divider
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final outlineColor = isDark ? Colors.white24 : const Color(0xFF333333);

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
              'Cards',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
        ),
      ),

      // --- Body Halaman ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Teks Pengantar
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                dummyText,
                style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
              ),
            ),

            // ----------------------------------------------------
            // 1. Simple Cards
            // ----------------------------------------------------
            _buildSectionTitle('Simple Cards', primaryColor),
            _buildCard(
              isSimple: true,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              child: Text(
                simpleCardText,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            _buildCardWithHeaderFooter(
              isSimple: true,
              header: cardHeader,
              footer: cardFooter,
              body: smallText,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            _buildCard(
              isSimple: true,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              child: Text(
                loremIpsum,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 2. Outline Cards
            // ----------------------------------------------------
            _buildSectionTitle('Outline Cards', primaryColor),
            _buildCard(
              isOutline: true,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              child: Text(
                simpleCardText,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            _buildCardWithHeaderFooter(
              isOutline: true,
              header: cardHeader,
              footer: cardFooter,
              body: smallText,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            _buildCard(
              isOutline: true,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              child: Text(
                loremIpsum,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 3. Outline With Dividers
            // ----------------------------------------------------
            _buildSectionTitle('Outline With Dividers', primaryColor),
            _buildCardWithHeaderFooter(
              isOutline: true,
              useDividers: true,
              header: cardHeader,
              footer: cardFooter,
              body: smallText,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 4. Raised Cards
            // ----------------------------------------------------
            _buildSectionTitle('Raised Cards', primaryColor),
            _buildCard(
              isRaised: true,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              child: Text(
                simpleCardText,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            _buildCardWithHeaderFooter(
              isRaised: true,
              header: cardHeader,
              footer: cardFooter,
              body: smallText,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            _buildCard(
              isRaised: true,
              backgroundColor: cardBgColor,
              outlineColor: outlineColor,
              child: Text(
                loremIpsum,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 5. Styled Cards (Media/Image Card)
            // ----------------------------------------------------
            _buildSectionTitle('Styled Cards', primaryColor),
            _buildMediaCard(
              imageUrl: 'https://picsum.photos/id/1015/600/300',
              title: 'Journey To Mountains',
              date: 'January 21, 2015',
              body:
                  'Quisque eget vestibulum nulla. Quisque quis dui quis ex ultricies efficitur vitae non felis. Phasellus quis nibh hendrerit...',
              footerLeft: 'Like',
              footerRight: 'Read more',
              backgroundColor: cardBgColor,
              textColor: textColor,
              subTextColor: subTextColor,
              primaryColor: primaryColor,
            ),
            _buildMediaCard(
              imageUrl: 'https://picsum.photos/id/1084/600/300',
              title: 'Lorem Ipsum',
              date: 'January 21, 2015',
              body:
                  'Quisque eget vestibulum nulla. Quisque quis dui quis ex ultricies efficitur vitae non felis. Phasellus quis nibh hendrerit...',
              footerLeft: 'Like',
              footerRight: 'Read more',
              backgroundColor: cardBgColor,
              textColor: textColor,
              subTextColor: subTextColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // 6. Cards With List View
            // ----------------------------------------------------
            _buildSectionTitle('Cards With List View', primaryColor),
            _buildCardWithListView(cardBgColor, outlineColor, textColor,
                dividerColor, primaryColor),

            const SizedBox(height: 24),
            _buildNewReleasesCard(cardBgColor, textColor, subTextColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Helpers Utama ---

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // Helper Card Dasar (Simple, Outline, Raised)
  Widget _buildCard({
    required Widget child,
    required Color backgroundColor,
    required Color outlineColor,
    bool isSimple = false,
    bool isOutline = false,
    bool isRaised = false,
    bool useDividers = false,
  }) {
    return Card(
      elevation: isRaised ? 3.0 : 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: isOutline || useDividers
            ? BorderSide(color: outlineColor, width: 1.0)
            : BorderSide.none,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  // Helper Card dengan Header dan Footer
  Widget _buildCardWithHeaderFooter({
    required String header,
    required String footer,
    required String body,
    required Color backgroundColor,
    required Color outlineColor,
    required Color textColor,
    required Color subTextColor,
    bool isSimple = false,
    bool isOutline = false,
    bool isRaised = false,
    bool useDividers = false,
  }) {
    final BorderSide border = useDividers || isOutline
        ? BorderSide(color: outlineColor, width: 1.0)
        : BorderSide.none;

    return Card(
      elevation: isRaised ? 3.0 : 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: isOutline || useDividers
            ? BorderSide(color: outlineColor, width: 1.0)
            : BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(bottom: useDividers ? border : BorderSide.none),
            ),
            child: Text(
              header,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              body,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(top: useDividers ? border : BorderSide.none),
            ),
            child: Text(
              footer,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Card dengan Gambar (Styled Cards)
  Widget _buildMediaCard({
    required String imageUrl,
    required String title,
    required String date,
    required String body,
    required String footerLeft,
    required String footerRight,
    required Color backgroundColor,
    required Color textColor,
    required Color subTextColor,
    required Color primaryColor,
  }) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar dengan overlay teks
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) =>
                      Container(height: 180, color: Colors.grey[300]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
              ),
            ],
          ),
          // Metadata
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'Posted on $date',
              style: TextStyle(fontSize: 12, color: subTextColor),
            ),
          ),
          // Body Teks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              body,
              style: TextStyle(fontSize: 14, height: 1.4, color: textColor),
            ),
          ),
          // Footer Aksi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  footerLeft,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  footerRight,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Card dengan List View
  Widget _buildCardWithListView(
    Color backgroundColor,
    Color outlineColor,
    Color textColor,
    Color dividerColor,
    Color primaryColor,
  ) {
    final List<String> links = [
      'Link 1',
      'Link 2',
      'Link 3',
      'Link 4',
      'Link 5',
    ];

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: outlineColor, width: 1.0),
      ),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Cards With List View',
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: links.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    title: Text(
                      links[index],
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: outlineColor,
                    ),
                    onTap: () {},
                  ),
                  if (index < links.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16.0,
                      endIndent: 0,
                      color: dividerColor,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper Card dengan New Releases
  Widget _buildNewReleasesCard(
      Color backgroundColor, Color textColor, Color subTextColor) {
    final List<Map<String, dynamic>> releases = [
      {
        'title': 'Yellow Submarine',
        'subtitle': 'Beatles',
        'image': 'https://picsum.photos/id/10/60/60',
      },
      {
        'title': 'Don\'t Stop Me Now',
        'subtitle': 'Queen',
        'image': 'https://picsum.photos/id/11/60/60',
      },
      {
        'title': 'Billie Jean',
        'subtitle': 'Michael Jackson',
        'image': 'https://picsum.photos/id/12/60/60',
      },
    ];

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'New Releases:',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: releases.length,
            itemBuilder: (context, index) {
              final item = releases[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    item['image'],
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                title: Text(
                  item['title'],
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: textColor),
                ),
                subtitle: Text(item['subtitle'],
                    style: TextStyle(color: subTextColor)),
                dense: true,
                onTap: () {},
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'January 20, 2015',
                  style: TextStyle(fontSize: 12, color: subTextColor),
                ),
                Text(
                  '5 comments',
                  style: TextStyle(fontSize: 12, color: subTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
