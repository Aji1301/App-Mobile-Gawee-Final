import 'package:flutter/material.dart';
import 'job_detail_page.dart';
import '../../../services/api_service.dart'; // Import API Service
import '../../../widgets/custom_drawer.dart';

class RecentJobScreen extends StatefulWidget {
  final String? categoryName;
  final String? companyName;
  final String? searchQuery;
  final String? locationQuery;

  const RecentJobScreen({
    super.key,
    this.categoryName,
    this.companyName,
    this.searchQuery,
    this.locationQuery,
  });

  @override
  State<RecentJobScreen> createState() => _RecentJobScreenState();
}

class _RecentJobScreenState extends State<RecentJobScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Controller untuk search bar di halaman ini
  final TextEditingController _searchController = TextEditingController();

  // Variable Data
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Jika ada search query dari halaman sebelumnya, isi ke text field
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
    }
    _fetchJobs();
  }

  // --- ✅ LOGIKA BACKEND YANG SUDAH DI-UPDATE ---
  void _fetchJobs({String? manualQuery}) async {
    setState(() => _isLoading = true);

    // 1. Tentukan Query Search Judul
    // Hanya ambil dari ketikan manual atau parameter search query (Home).
    // JANGAN menimpa variable ini dengan categoryName.
    String? query = manualQuery ?? widget.searchQuery;

    // 2. Panggil API dengan parameter terpisah
    final data = await ApiService.getJobs(
      query: query,                 // Filter Title (Judul)
      location: widget.locationQuery,
      companyName: widget.companyName,
      category: widget.categoryName, // ✅ Filter Kategori Khusus
    );

    if (mounted) {
      setState(() {
        _jobs = data;
        _isLoading = false;
      });
    }
  }

  void _toggleSaveJob(String jobId) {
    // Logika simpan lokal sementara (UI Only)
    setState(() {
      final index = _jobs.indexWhere((job) => job['id'] == jobId);
      if (index != -1) {
        // Toggle status bookmark (visual saja)
        bool current = _jobs[index]['is_saved'] == 'true';
        _jobs[index]['is_saved'] = current ? 'false' : 'true';
      }
    });
  }

  // Helper Logo
  String _getLogoPath(String jobTitle) {
    if (jobTitle.contains('Graphic')) return 'assets/images/logo 1.png';
    if (jobTitle.contains('Junior')) return 'assets/images/logo 3.png';
    return 'assets/images/logo 4.png';
  }

  @override
  Widget build(BuildContext context) {
    // === AMBIL WARNA DARI TEMA AGAR ADAPTIF ===
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final cardColor = theme.cardColor;

    // Judul Dinamis
    String appBarTitle = 'Recent Job';
    if (widget.categoryName != null) appBarTitle = '${widget.categoryName} Jobs';
    if (widget.companyName != null) appBarTitle = widget.companyName!;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 320, child: Drawer(child: CustomDrawerBody())),
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(color: textColor)), // Judul ikuti tema
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor, // Background AppBar ikuti tema
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor), // Icon ikuti tema
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(backgroundColor: cardColor), // Background tombol ikuti tema
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.more_vert, color: textColor), // Icon ikuti tema
              onPressed: () => _scaffoldKey.currentState?.openDrawer()),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KOTAK PENCARIAN
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor, // Background gelap saat Dark Mode
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), 
                    spreadRadius: 1, 
                    blurRadius: 5, 
                    offset: const Offset(0, 3)
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => _fetchJobs(manualQuery: val),
                style: TextStyle(color: textColor), // Tulisan putih saat Dark Mode
                decoration: InputDecoration(
                  hintText: 'Search job here...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: Icon(Icons.search, color: textColor.withOpacity(0.5)),
                ),
              ),
            ),
          ),

          // DAFTAR PEKERJAAN (LIVE DATA)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _jobs.isEmpty
                    ? Center(
                        child: Text(
                          'No jobs found.', 
                          style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 16)
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _jobs.length,
                        itemBuilder: (context, index) {
                          final job = _jobs[index];
                          
                          // Mapping Data DB ke Format UI
                          final uiJobMap = {
                            'id': job['id'].toString(),
                            'title': job['title']?.toString() ?? '',
                            'company': job['company_name']?.toString() ?? '',
                            'location': job['location']?.toString() ?? '',
                            'salary': job['salary_range']?.toString() ?? '',
                            'description': job['description']?.toString() ?? '', 
                            'is_saved': job['is_saved']?.toString() ?? 'false',
                            'icon_bg_color': '0xFF8052F7', 
                            'icon_fg_color': '0xFFFFB3E9', 

                            'requirements': job['requirements']?.toString() ?? '', 
                            'is_saved': job['is_saved'].toString(),

                          };

                          return JobListItem(
                            job: uiJobMap,
                            isSaved: uiJobMap['is_saved'] == 'true',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailScreen(job: uiJobMap),
                                ),
                              );
                            },
                            onSaveToggle: () => _toggleSaveJob(uiJobMap['id']!),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// Widget JobListItem
class JobListItem extends StatelessWidget {
  final Map<String, String> job;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSaveToggle;

  const JobListItem({
    required this.job,
    required this.isSaved,
    required this.onTap,
    required this.onSaveToggle,
    super.key,
  });

  String _getLogoPath(String jobTitle) {
    if (jobTitle.contains('Graphic')) return 'assets/images/logo 1.png';
    if (jobTitle.contains('Junior')) return 'assets/images/logo 3.png';
    return 'assets/images/logo 4.png';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final cardColor = theme.cardColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(bottom: BorderSide(color: textColor.withOpacity(0.1))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _getLogoPath(job['title']!), 
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Icon(Icons.work, color: primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title']!, 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)
                  ),
                  Text(
                    job['location']!, 
                    style: TextStyle(color: textColor.withOpacity(0.6))
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job['salary']!, 
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border, 
                color: isSaved ? primaryColor : textColor.withOpacity(0.4)
              ),
              onPressed: onSaveToggle,
            ),
          ],
        ),
      ),
    );
  }
}