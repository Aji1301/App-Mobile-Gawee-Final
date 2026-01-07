import 'package:flutter/material.dart';
import '../../../widgets/custom_drawer.dart';
// Import RecentJobScreen untuk navigasi hasil pencarian
import '../../recent_job/screens/recent_job_page.dart'; 

class FindJobScreen extends StatefulWidget {
  const FindJobScreen({super.key});

  @override
  State<FindJobScreen> createState() => _FindJobScreenState();
}

class _FindJobScreenState extends State<FindJobScreen> {
  // 1. Controller untuk menangkap input
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> popularSearches = const [
    "Software Engineer",
    "Designer",
    "Manager",
    "Flutter",
    "Marketing",
  ];

  @override
  void dispose() {
    _jobTitleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Fungsi Navigasi ke Hasil Pencarian
  void _performSearch({String? title, String? location}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecentJobScreen(
          // Kirim data pencarian ke halaman sebelah
          searchQuery: title ?? _jobTitleController.text,
          locationQuery: location ?? _locationController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color colorPrimaryButton = theme.primaryColor;
    final Color colorChipBackground = colorPrimaryButton.withOpacity(0.1);
    final Color colorGreyText = theme.textTheme.bodyMedium?.color ?? Colors.grey.shade600;
    final Color colorTitleText = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final Color colorCardBackground = theme.cardColor;

    return Scaffold(
      drawer: const Drawer(child: CustomDrawerBody()),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.canPop(context) ? Navigator.pop(context) : null,
        ),
        title: const Text("Find Job"),
        centerTitle: true,
        actions: [
          Builder(builder: (ctx) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. KOTAK SEARCH INPUT (Hubungkan Controller)
            _buildSearchBox(colorCardBackground, colorTitleText, colorGreyText),
            const SizedBox(height: 24),

            // 3. TOMBOL SEARCH (Panggil _performSearch)
            _buildSearchButton(context, colorPrimaryButton),
            const SizedBox(height: 32),

            Text("Popular Searches",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorTitleText)),
            const SizedBox(height: 16),

            // 4. CHIP POPULAR (Klik langsung cari)
            _buildPopularSearchChips(context, colorChipBackground, colorGreyText),
            const SizedBox(height: 32),

            _buildCreateResume(context, colorTitleText),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(Color bg, Color text, Color icon) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _jobTitleController, // Hubungkan
            style: TextStyle(color: text),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: icon),
              hintText: "Job title, keywords, or company",
              hintStyle: TextStyle(color: icon.withOpacity(0.5)),
              border: InputBorder.none,
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200, indent: 20, endIndent: 20),
          TextField(
            controller: _locationController, // Hubungkan
            style: TextStyle(color: text),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined, color: icon),
              hintText: "City or locality (e.g. Medan)",
              hintStyle: TextStyle(color: icon.withOpacity(0.5)),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _performSearch(), // Panggil Fungsi
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 2,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text("SEARCH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildPopularSearchChips(BuildContext context, Color bg, Color text) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: popularSearches.map((keyword) {
        return Material(
          color: bg,
          borderRadius: BorderRadius.circular(20.0),
          child: InkWell(
            onTap: () => _performSearch(title: keyword), // Klik chip -> Cari
            borderRadius: BorderRadius.circular(20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 18, color: text),
                  const SizedBox(width: 6),
                  Text(keyword, style: TextStyle(color: text)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCreateResume(BuildContext context, Color text) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/resume'), // Asumsi rute resume ada
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Create Your Resume", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: text)),
            Icon(Icons.arrow_forward_ios, size: 18, color: text),
          ],
        ),
      ),
    );
  }
}