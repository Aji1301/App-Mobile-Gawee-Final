import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  // Menggunakan Ikon Bawaan Flutter
  final IconData mainIcon = Icons.shopping_bag_outlined;

  // Variabel state untuk Switch/Toggle
  bool _toggleValue1 = true;
  bool _ultraLongToggleValue = false; // Variabel state untuk Ultra Long

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
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks, Icon, & Divider
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white60 : Colors.grey.shade600;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Warna List (Strong, Outline, Separator)
    final listBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // --- PERBAIKAN DI SINI ---
    // Menambahkan '!' pada Colors.grey[900]! agar tipe datanya menjadi Color (bukan Color?)
    // Atau menggunakan default value jika null
    final Color strongListBgColor =
        isDark ? (Colors.grey[900] ?? Colors.black) : Colors.grey.shade100;

    final listOutlineColor = isDark ? Colors.white24 : Colors.grey.shade400;
    final listSeparatorColor = isDark ? Colors.white12 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          'List View',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Deskripsi Awal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Framework7 allows you to be flexible with list views (table views). You can make them as navigation menus, you can use there icons, inputs, and any elements inside of the list, and even make them nested:',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),

            // --- 1. Simple List ---
            _buildSectionTitle('Simple List', primaryColor),
            _buildSimpleList(
                strong: false,
                outline: false,
                inset: false,
                listBgColor: listBgColor,
                strongListBgColor: strongListBgColor,
                listOutlineColor: listOutlineColor,
                listSeparatorColor: listSeparatorColor,
                textColor: textColor),

            // --- 2. Strong List ---
            _buildSectionTitle('Strong List', primaryColor),
            _buildSimpleList(
                strong: true,
                outline: false,
                inset: false,
                listBgColor: listBgColor,
                strongListBgColor: strongListBgColor,
                listOutlineColor: listOutlineColor,
                listSeparatorColor: listSeparatorColor,
                textColor: textColor),

            // --- 3. Strong Outline List ---
            _buildSectionTitle('Strong Outline List', primaryColor),
            _buildSimpleList(
                strong: true,
                outline: true,
                inset: false,
                listBgColor: listBgColor,
                strongListBgColor: strongListBgColor,
                listOutlineColor: listOutlineColor,
                listSeparatorColor: listSeparatorColor,
                textColor: textColor),

            // --- 4. Strong Inset List ---
            _buildSectionTitle('Strong Inset List', primaryColor),
            _buildSimpleList(
                strong: true,
                outline: false,
                inset: true,
                listBgColor: listBgColor,
                strongListBgColor: strongListBgColor,
                listOutlineColor: listOutlineColor,
                listSeparatorColor: listSeparatorColor,
                textColor: textColor),

            // --- 5. Strong Outline Inset List ---
            _buildSectionTitle('Strong Outline Inset List', primaryColor),
            _buildSimpleList(
                strong: true,
                outline: true,
                inset: true,
                listBgColor: listBgColor,
                strongListBgColor: strongListBgColor,
                listOutlineColor: listOutlineColor,
                listSeparatorColor: listSeparatorColor,
                textColor: textColor),

            // --- 6. Simple Links List ---
            _buildSectionTitle('Simple Links List', primaryColor),
            _buildSimpleLinksList(textColor, listSeparatorColor, primaryColor),

            // --- 7. Data list, with icons ---
            _buildSectionTitle('Data list, with icons', primaryColor),
            _buildDataList(
                textColor, subtitleColor, listSeparatorColor, primaryColor),

            // 8. Links, Header, Footer (Complex List)
            _buildSectionTitle('Links, Header, Footer', primaryColor),
            _buildComplexList(
                textColor, subtitleColor, listSeparatorColor, primaryColor),

            // 9. Links, no icons
            _buildSectionTitle('Links, no icons', primaryColor),
            _buildBasicListItem('Ivan Petrov',
                isLink: true,
                textColor: textColor,
                subtitleColor: subtitleColor,
                listSeparatorColor: listSeparatorColor,
                primaryColor: primaryColor),
            _buildBasicListItem('John Doe',
                isLink: true,
                textColor: textColor,
                subtitleColor: subtitleColor,
                listSeparatorColor: listSeparatorColor,
                primaryColor: primaryColor),

            // ✅ 10. Grouped with sticky titles
            _buildSectionTitle('Grouped with sticky titles', primaryColor),
            _buildGroupedList(textColor, subtitleColor, listSeparatorColor,
                primaryColor, strongListBgColor, listBgColor),

            // --- 11. Media Lists (Songs) ---
            _buildSectionTitle('Media Lists', primaryColor),
            // Deskripsi Media Lists
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Media Lists are almost the same as Data Lists, but with a more flexible layout for visualization of more complex data, like products, services, users, etc.',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            // Sub-Judul Songs
            _buildGroupHeader('Songs',
                color: primaryColor,
                bgColor: listBgColor,
                textColor: textColor),
            _buildMediaList(textColor, subtitleColor, listSeparatorColor),
            // ✅ 11.5. Mail App List
            _buildMailAppList(
                textColor, subtitleColor, listSeparatorColor, primaryColor),

            // --- 12. Something More Simple (List Simple Icons) ---
            _buildSectionTitle('Something more simple', primaryColor),
            _buildSimpleIconList(textColor, subtitleColor, listSeparatorColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PEMBANTU UTAMA ---

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  // Widget untuk List Item Dasar
  Widget _buildBasicListItem(
    String title, {
    String? subtitle,
    String? trailing,
    bool isLink = false,
    Widget? leading,
    required Color textColor,
    required Color subtitleColor,
    required Color listSeparatorColor,
    required Color primaryColor,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: leading,
          title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          subtitle: subtitle != null
              ? Text(subtitle, style: TextStyle(color: subtitleColor))
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null)
                Text(
                  trailing,
                  style: TextStyle(
                    color: isLink ? primaryColor : textColor,
                  ),
                ),
              if (isLink)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
            ],
          ),
          onTap: isLink ? () {} : null,
        ),
        // Divider hanya jika tidak ada leading widget (seperti Simple List)
        if (leading == null)
          Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
      ],
    );
  }

  // Helper untuk membuat Leading Icon/Logo
  Widget _buildLeadingLogo(Color primaryColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: Icon(mainIcon, color: Colors.white, size: 16)),
    );
  }

  // Widget khusus untuk List Item dengan Switch/Toggle di belakang
  Widget _buildListItemWithToggle(
    String title,
    bool value, {
    Widget? leading,
    required Function(bool) onChanged,
    required Color textColor,
    required Color listSeparatorColor,
    required Color primaryColor,
  }) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          value: value,
          onChanged: onChanged,
          secondary: leading,
          activeColor: primaryColor,
        ),
        Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
      ],
    );
  }

  // --- BLOK LIST SPESIFIK ---

  // Simple List, Strong List, Strong Outline List, Inset
  Widget _buildSimpleList({
    required bool strong,
    required bool outline,
    required bool inset,
    required Color listBgColor,
    required Color strongListBgColor,
    required Color listOutlineColor,
    required Color listSeparatorColor,
    required Color textColor,
  }) {
    final BorderRadius borderRadius = BorderRadius.circular(inset ? 10 : 0);
    final EdgeInsets margin = inset
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : EdgeInsets.zero;

    // Tentukan warna background list
    final bgColor = strong ? strongListBgColor : listBgColor;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border:
            outline ? Border.all(color: listOutlineColor, width: 1.0) : null,
      ),
      child: Column(
        children: [
          // Kita kirim primaryColor dummy karena isLink false
          _buildBasicListItem(
            'Item 1',
            isLink: false,
            leading: strong ? null : const SizedBox(),
            textColor: textColor,
            subtitleColor: Colors.grey,
            listSeparatorColor: listSeparatorColor,
            primaryColor: Colors.transparent,
          ),
          Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
          _buildBasicListItem(
            'Item 2',
            isLink: false,
            leading: strong ? null : const SizedBox(),
            textColor: textColor,
            subtitleColor: Colors.grey,
            listSeparatorColor: listSeparatorColor,
            primaryColor: Colors.transparent,
          ),
          Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
          _buildBasicListItem(
            'Item 3',
            isLink: false,
            leading: strong ? null : const SizedBox(),
            textColor: textColor,
            subtitleColor: Colors.grey,
            listSeparatorColor: listSeparatorColor,
            primaryColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  // Simple Links List
  Widget _buildSimpleLinksList(
      Color textColor, Color listSeparatorColor, Color primaryColor) {
    return Column(
      children: [
        _buildBasicListItem('Link 1',
            isLink: true,
            leading: null,
            textColor: textColor,
            subtitleColor: Colors.grey,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Link 2',
            isLink: true,
            leading: null,
            textColor: textColor,
            subtitleColor: Colors.grey,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Link 3',
            isLink: true,
            leading: null,
            textColor: textColor,
            subtitleColor: Colors.grey,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
      ],
    );
  }

  // Data List (Ivan Petrov, Jenna Smith)
  Widget _buildDataList(Color textColor, Color subtitleColor,
      Color listSeparatorColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBasicListItem(
          'Ivan Petrov',
          trailing: 'CEO',
          leading: _buildLeadingLogo(primaryColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildBasicListItem(
          'John Doe',
          trailing: '5',
          leading: _buildLeadingLogo(primaryColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildBasicListItem('Jenna Smith',
            leading: _buildLeadingLogo(primaryColor),
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),

        // Links section
        _buildSectionTitle('Links', primaryColor),
        _buildBasicListItem(
          'Ivan Petrov',
          trailing: 'CEO',
          isLink: true,
          leading: _buildLeadingLogo(primaryColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildBasicListItem(
          'John Doe',
          trailing: 'Cleaner',
          isLink: true,
          leading: _buildLeadingLogo(primaryColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildBasicListItem(
          'Jenna Smith',
          isLink: true,
          leading: _buildLeadingLogo(primaryColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
      ],
    );
  }

  // Complex List (Links, Header, Footer)
  Widget _buildComplexList(Color textColor, Color subtitleColor,
      Color listSeparatorColor, Color primaryColor) {
    // Helper untuk membuat Widget Logo/Icon di complex list
    Widget leadingComplexImageWidget() {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(child: Icon(mainIcon, color: Colors.white, size: 16)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        _buildDetailItem(
          'Name',
          'John Doe',
          'Edit',
          leadingComplexImageWidget(),
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        // Phone
        _buildDetailItem(
          'Phone',
          '+7 90 111-22-3344',
          'Edit',
          leadingComplexImageWidget(),
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        // Email 1
        _buildDetailItem(
          'Email',
          'john@doe',
          'Edit',
          leadingComplexImageWidget(),
          footer: 'Home',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        // Email 2
        _buildDetailItem(
          'Email',
          'john@framework7',
          'Edit',
          leadingComplexImageWidget(),
          footer: 'Work',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
      ],
    );
  }

  // Fungsi _buildDetailItem
  Widget _buildDetailItem(
    String header,
    String title,
    String trailingText,
    Widget leadingWidget, {
    String? footer,
    required Color textColor,
    required Color subtitleColor,
    required Color listSeparatorColor,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: leadingWidget,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: TextStyle(fontSize: 12, color: subtitleColor),
              ),
              Text(title, style: TextStyle(fontSize: 16, color: textColor)),
              if (footer != null)
                Text(
                  footer,
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trailingText,
                style: TextStyle(color: primaryColor, fontSize: 14),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
          onTap: () {},
        ),
        Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
      ],
    );
  }

  // ✅ Grouped List (Simulasi Kontak A, B, C)
  Widget _buildGroupedList(
      Color textColor,
      Color subtitleColor,
      Color listSeparatorColor,
      Color primaryColor,
      Color stickyBgColor,
      Color bgWhite) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Title Here
        _buildGroupHeader('Group Title Here',
            color: subtitleColor, bgColor: bgWhite, textColor: textColor),
        _buildBasicListItem('Ivan Petrov',
            isLink: true,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Jenna Smith',
            isLink: true,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),

        // Judul Sticky: Grouped with sticky titles
        _buildGroupHeader('Grouped with sticky titles',
            isSticky: true,
            color: primaryColor,
            bgColor: stickyBgColor,
            textColor: textColor),

        // Grup A
        _buildGroupHeader('A',
            isSticky: true,
            color: primaryColor,
            bgColor: stickyBgColor,
            textColor: textColor),
        _buildBasicListItem('Aaron',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Abbie',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Adam',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),

        // Grup B
        _buildGroupHeader('B',
            isSticky: true,
            color: primaryColor,
            bgColor: stickyBgColor,
            textColor: textColor),
        _buildBasicListItem('Bailey',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Barclay',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Bartolo',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),

        // ✅ Grup C ditambahkan
        _buildGroupHeader('C',
            isSticky: true,
            color: primaryColor,
            bgColor: stickyBgColor,
            textColor: textColor),
        _buildBasicListItem('Caiden',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Calvin',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),
        _buildBasicListItem('Candy',
            leading: null,
            textColor: textColor,
            subtitleColor: subtitleColor,
            listSeparatorColor: listSeparatorColor,
            primaryColor: primaryColor),

        // --- LIST BARU: Mixed and Nested ---
        _buildMixedAndNestedList(textColor, subtitleColor, listSeparatorColor,
            primaryColor, bgWhite),
      ],
    );
  }

  Widget _buildGroupHeader(
    String title, {
    Color? color,
    bool isSticky = false,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      color:
          isSticky ? bgColor : Colors.transparent, // Background sticky dinamis
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color ?? textColor, // Warna teks dinamis
        ),
      ),
    );
  }

  // --- FUNGSI BARU UNTUK LIST "Mixed and Nested" ---
  Widget _buildMixedAndNestedList(Color textColor, Color subtitleColor,
      Color listSeparatorColor, Color primaryColor, Color bgWhite) {
    // Helper untuk Leading Icon/Logo
    Widget _buildLeadingIcon() {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(child: Icon(mainIcon, color: Colors.white, size: 16)),
      );
    }

    // Helper untuk Leading dengan dua ikon
    Widget _buildTwoIconsLeading() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLeadingIcon(),
          const SizedBox(width: 4),
          _buildLeadingIcon(),
        ],
      );
    }

    // List item dengan divider
    Widget _buildItem(
      String title, {
      String? trailing,
      Widget? leading,
      bool isLink = false,
    }) {
      return _buildBasicListItem(
        title,
        trailing: trailing,
        leading: leading,
        isLink: isLink,
        textColor: textColor,
        subtitleColor: subtitleColor,
        listSeparatorColor: listSeparatorColor,
        primaryColor: primaryColor,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Judul: Candy
        _buildGroupHeader('Candy',
            color: subtitleColor, bgColor: bgWhite, textColor: textColor),

        // --- Mixed and nested ---
        _buildSectionTitle('Mixed and nested', primaryColor),
        // Ivan Petrov
        _buildItem(
          'Ivan Petrov',
          leading: _buildLeadingIcon(),
          trailing: 'CEO',
          isLink: true,
        ),
        // Two icons here
        _buildItem(
          'Two icons here',
          leading: _buildTwoIconsLeading(),
          isLink: true,
        ),

        // --- No icons here (Group header) ---
        _buildGroupHeader('No icons here',
            bgColor: bgWhite, textColor: textColor),
        // Ivan Petrov
        _buildItem('Ivan Petrov', trailing: 'CEO', isLink: true),
        // Two icons here
        _buildItem('Two icons here', isLink: true),

        // --- No icons here (Group header) ---
        _buildGroupHeader('No icons here',
            bgColor: bgWhite, textColor: textColor),
        // Ultra long text
        _buildItem('Ultra long text goes here, no, it is really really long'),

        // With toggle
        _buildListItemWithToggle(
          'With toggle',
          _toggleValue1,
          leading: _buildLeadingIcon(),
          onChanged: (bool value) {
            setState(() {
              _toggleValue1 = value;
            });
          },
          textColor: textColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),

        // Ultra long text with toggle
        _buildListItemWithToggle(
          'Ultra long text goes here, no, it is really really long',
          _ultraLongToggleValue,
          leading: _buildLeadingIcon(),
          onChanged: (bool value) {
            setState(() {
              _ultraLongToggleValue = value;
            });
          },
          textColor: textColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),

        // --- Tablet inset ---
        _buildSectionTitle('Tablet inset', primaryColor),
        // Ivan Petrov
        _buildItem(
          'Ivan Petrov',
          leading: _buildLeadingIcon(),
          trailing: 'CEO',
          isLink: true,
        ),
        // Two icons here
        _buildItem('Two icons here', leading: _buildTwoIconsLeading()),
        // Ultra long text goes here
        _buildItem(
          'Ultra long text goes here, no, it is really really long',
          leading: _buildLeadingIcon(),
        ),

        // Footer Text
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Text(
            'This list block will look like "inset" only on tablets (iPad)',
            style: TextStyle(fontSize: 14, color: subtitleColor),
          ),
        ),
      ],
    );
  }

  // Media List (Songs)
  Widget _buildMediaList(
      Color textColor, Color subtitleColor, Color listSeparatorColor) {
    const String songDesc =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis tellus ut turpis condimentum, ut dignissim lacus tincidunt. Cras dolor metus, ultrices condimentum...';

    return Column(
      children: [
        _buildMediaItem(
          'Yellow Submarine',
          'Beatles',
          songDesc,
          '\$15',
          'dummy/album1.jpg',
          textColor,
          subtitleColor,
          listSeparatorColor,
        ),
        _buildMediaItem(
          'Don\'t Stop Me Now',
          'Queen',
          songDesc,
          '\$22',
          'dummy/album2.jpg',
          textColor,
          subtitleColor,
          listSeparatorColor,
        ),
        _buildMediaItem(
          'Billie Jean',
          'Michael Jackson',
          songDesc,
          '\$16',
          'dummy/album3.jpg',
          textColor,
          subtitleColor,
          listSeparatorColor,
        ),
      ],
    );
  }

  Widget _buildMediaItem(
    String title,
    String subtitle,
    String description,
    String trailingText,
    String imagePath,
    Color textColor,
    Color subtitleColor,
    Color listSeparatorColor,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.image, color: Colors.white, size: 30),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: TextStyle(color: subtitleColor)),
              const SizedBox(height: 4),
              Text(
                description,
                style:
                    TextStyle(fontSize: 12, color: textColor.withOpacity(0.8)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trailingText,
                style: TextStyle(color: subtitleColor, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
          onTap: () {},
        ),
        Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
      ],
    );
  }

  // --- FUNGSI UNTUK LIST "MAIL APP" ---
  Widget _buildMailAppItem({
    required String header,
    required String subject,
    required String body,
    required String time,
    bool showChevron = true,
    required Color textColor,
    required Color subtitleColor,
    required Color listSeparatorColor,
    required Color primaryColor,
  }) {
    final bodySafe = body.replaceAll('\n', ' ');
    final trimmedBody =
        bodySafe.substring(0, bodySafe.length > 100 ? 100 : bodySafe.length) +
            (bodySafe.length > 100 ? '...' : '');

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              header,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                trimmedBody,
                style: TextStyle(fontSize: 14, color: subtitleColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(color: subtitleColor, fontSize: 14),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
            ],
          ),
          onTap: () {},
        ),
        Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
      ],
    );
  }

  Widget _buildMailAppList(Color textColor, Color subtitleColor,
      Color listSeparatorColor, Color primaryColor) {
    const String bodyText =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis tellus ut turpis condimentum, ut dignissim lacus tincidunt. Cras dolor metus, ultrices condimentum...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Mail App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        _buildMailAppItem(
          header: 'Facebook',
          subject: 'New messages from John Doe',
          body: bodyText,
          time: '17:14',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildMailAppItem(
          header: 'John Doe (via Twitter)',
          subject: 'John Doe (@_johndoe) mentioned you on Twitter!',
          body: bodyText,
          time: '17:11',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildMailAppItem(
          header: 'Facebook',
          subject: 'New messages from John Doe',
          body: bodyText,
          time: '16:48',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildMailAppItem(
          header: 'John Doe (via Twitter)',
          subject: 'John Doe (@_johndoe) mentioned you on Twitter!',
          body: bodyText,
          time: '15:32',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildSectionTitle('With centered chevron icon', primaryColor),
        _buildMailAppItem(
          header: 'Facebook',
          subject: 'New messages from John Doe',
          body: bodyText,
          time: '17:14',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
        _buildMailAppItem(
          header: 'John Doe (via Twitter)',
          subject: 'John Doe (@_johndoe) mentioned you on Twitter!',
          body: bodyText,
          time: '17:11',
          textColor: textColor,
          subtitleColor: subtitleColor,
          listSeparatorColor: listSeparatorColor,
          primaryColor: primaryColor,
        ),
      ],
    );
  }

  // Simple Media List (Something More Simple)
  Widget _buildSimpleMediaList(
      Color textColor, Color subtitleColor, Color listSeparatorColor) {
    Widget _buildSimpleMediaLeading() {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.image, color: Colors.white, size: 20),
      );
    }

    Widget _buildSimpleMediaItem(
      String title,
      String subtitle, {
      bool isLink = false,
    }) {
      return Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: _buildSimpleMediaLeading(),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: subtitleColor),
            ),
            trailing: isLink
                ? Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20,
                  )
                : null,
            onTap: isLink ? () {} : null,
          ),
          Divider(height: 1, thickness: 0.5, color: listSeparatorColor),
        ],
      );
    }

    return Column(
      children: [
        _buildSimpleMediaItem('Yellow Submarine', 'Beatles'),
        _buildSimpleMediaItem('Don\'t Stop Me Now', 'Queen', isLink: true),
        _buildSimpleMediaItem('Billie Jean', 'Michael Jackson'),
      ],
    );
  }

  // Simple Icon List (Something More Simple)
  Widget _buildSimpleIconList(
      Color textColor, Color subtitleColor, Color listSeparatorColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSimpleMediaList(textColor, subtitleColor, listSeparatorColor),
      ],
    );
  }
}
