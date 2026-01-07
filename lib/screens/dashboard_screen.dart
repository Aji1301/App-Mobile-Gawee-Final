import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// IMPORT SERVICE API
import '../services/api_service.dart';

import '../providers/theme_provider.dart';
import '../widgets/custom_drawer.dart';
import '../utils/constants.dart';

// Pastikan import path ini sesuai dengan struktur folder Anda
import '../features/recent_job/screens/recent_job_page.dart';
import '../features/recent_job/screens/job_detail_page.dart';
import '../features/featured_job/screens/featured_job_detail_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _supabase = Supabase.instance.client;

  Map<String, dynamic>? _userProfile;
  int _appliedCount = 0;
  int _interviewCount = 0;
  RealtimeChannel? _applicationsSubscription;

  // ✅ VARIABLE DATA JOB & KATEGORI
  List<Map<String, dynamic>> _recentJobs = [];
  List<Map<String, dynamic>> _featuredJobs = [];
  List<String> _dynamicCategories = []; // <--- Variable Kategori Dinamis
  
  // Loading States
  bool _isJobsLoading = true;
  bool _isFeaturedLoading = true;
  bool _isCategoriesLoading = true; // <--- Loading Kategori

  // Warna-warni untuk Chip Kategori
  final List<Color> _categoryColors = [
    const Color(0xFF0E6F83), // Teal
    const Color(0xFF006A5B), // Dark Green
    const Color(0xFF8B5600), // Brown
    const Color(0xFF116C1A), // Green
    const Color(0xFF295D8A), // Blue
    const Color(0xFF8052F7), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchStats();
    _fetchRecentJobs();
    _fetchFeaturedJobs();
    _fetchJobCategories(); // <--- Ambil Kategori Dinamis
    _setupRealtimeSubscription();
  }

  @override
  void dispose() {
    if (_applicationsSubscription != null) {
      _supabase.removeChannel(_applicationsSubscription!);
    }
    super.dispose();
  }

  // --- LOGIKA REALTIME ---
  void _setupRealtimeSubscription() {
    _applicationsSubscription = _supabase
        .channel('public:applications')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'applications',
          callback: (payload) {
            _fetchStats();
          },
        )
        .subscribe();
  }

  void _fetchProfile() async {
    final data = await ApiService.getProfile();
    if (mounted) setState(() => _userProfile = data);
  }

  void _fetchStats() async {
    final stats = await ApiService.getDashboardStats();
    if (mounted) {
      setState(() {
        _appliedCount = stats['applied'] ?? 0;
        _interviewCount = stats['interviews'] ?? 0;
      });
    }
  }

  // ✅ 1. AMBIL RECENT JOBS
  void _fetchRecentJobs() async {
    final jobsData = await ApiService.getJobs(); 
    if (mounted) {
      setState(() {
        _recentJobs = jobsData.map((job) {
          return {
            'id': job['id'].toString(),
            'title': job['title'] ?? 'No Title',
            'company': job['company_name'] ?? 'No Company',
            'location': job['location'] ?? 'Unknown',
            'salary': job['salary_range'] ?? 'Negotiable',
            'description': job['description'] ?? '',
            'is_saved': job['is_saved'] == 'true',
            'logoPath': _getLogoPath(job['title'] ?? ''),
            'logoColor': _getLogoColor(job['title'] ?? ''),
            'requirements': job['requirements'] ?? '',
          };
        }).toList();

        // Batasi 5 pekerjaan terbaru di dashboard
        if (_recentJobs.length > 5) {
          _recentJobs = _recentJobs.sublist(0, 5);
        }
        _isJobsLoading = false;
      });
    }
  }

  // ✅ 2. AMBIL FEATURED JOBS
  void _fetchFeaturedJobs() async {
    final featuredData = await ApiService.getFeaturedJobs();
    if (mounted) {
      setState(() {
        _featuredJobs = featuredData.map((job) {
          return {
            'id': job['id'].toString(),
            'title': job['title'] ?? 'No Title',
            'company': job['company_name'] ?? 'No Company',
            'location': job['location'] ?? 'Unknown',
            'salary': job['salary_range'] ?? 'Negotiable',
            'description': job['description'] ?? '',
            'is_saved': job['is_saved'] == 'true',
            'logoPath': _getLogoPath(job['title'] ?? ''),
            'logoColor': _getLogoColor(job['title'] ?? ''),
            'requirements': job['requirements'] ?? '',
          };
        }).toList();
        _isFeaturedLoading = false;
      });
    }
  }

// ✅ LOGIKA KATEGORI: MENGAMBIL LANGSUNG DARI KOLOM 'CATEGORY'
  void _fetchJobCategories() async {
    try {
      // Ambil kolom 'category' saja dari database
      final response = await _supabase.from('jobs').select('category');
      final List<dynamic> data = response as List<dynamic>;
      
      final Map<String, int> categoryCounts = {};
      for (var item in data) {
        final String? cat = item['category'];
        if (cat != null && cat.isNotEmpty) {
          categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
        }
      }

      // Filter: Tampilkan kategori jika ada minimal 1 pekerjaan
      final List<String> filtered = categoryCounts.entries
          .where((entry) => entry.value > 0) 
          .map((entry) => entry.key)
          .toList();

      if (mounted) {
        setState(() {
          _dynamicCategories = filtered;
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isCategoriesLoading = false);
    }
  }

  // ✅ LOGIKA SORTING BY BOOKMARK
  void _toggleBookmark(int index) {
    setState(() {
      bool currentStatus = _recentJobs[index]['is_saved'];
      _recentJobs[index]['is_saved'] = !currentStatus;

      // Jika di-bookmark, pindahkan ke paling atas
      if (_recentJobs[index]['is_saved'] == true) {
        final item = _recentJobs.removeAt(index);
        _recentJobs.insert(0, item);
      }
    });
  }

  // Helper UI
  String _getLogoPath(String jobTitle) {
    if (jobTitle.contains('Graphic')) return 'assets/images/logo 1.png';
    if (jobTitle.contains('Junior')) return 'assets/images/logo 3.png';
    return 'assets/images/logo 4.png';
  }

  Color _getLogoColor(String jobTitle) {
    if (jobTitle.contains('Graphic')) return const Color(0xFF1B7C50);
    if (jobTitle.contains('Junior')) return const Color(0xFF295D8A);
    return const Color(0xFF0E6F83);
  }

  void _showColorPickerSheet(BuildContext context, ThemeProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
        builder: (ctx, scroll) => _ColorPickerSheet(provider: provider, scrollController: scroll),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color!;
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final kPrimaryColor = theme.primaryColor;

    final String userName = _userProfile?['name'] ?? (_userProfile == null ? 'Loading...' : 'User');
    final String? avatarUrl = _userProfile?['avatar']; 

    return Scaffold(
      key: _scaffoldKey,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          // Refresh semua data saat drawer ditutup
          _fetchProfile();
          _fetchStats();
          _fetchRecentJobs();
          _fetchFeaturedJobs();
          _fetchJobCategories();
        }
      },
      drawer: const SizedBox(width: 320, child: Drawer(child: CustomDrawerBody())),
      body: SafeArea(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              // ======= TOP BAR =======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.menu, size: 28, color: textColor), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showColorPickerSheet(context, Provider.of<ThemeProvider>(context, listen: false)),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]),
                        child: Icon(Icons.color_lens, size: 18, color: textColor.withOpacity(0.8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(!isDark),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]),
                        child: Icon(isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined, size: 18, color: isDark ? Colors.amber : textColor),
                      ),
                    ),
                  ],
                ),
              ),

              // ======= BODY =======
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Info
                      Row(
                        children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Hello', style: GoogleFonts.poppins(color: textColor.withOpacity(0.7))),
                              const SizedBox(height: 6),
                              Text(userName, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ]),
                          ),
                          Builder(builder: (context) {
                            final String? urlGambar = avatarUrl;
                            final bool adaGambar = urlGambar != null && urlGambar.isNotEmpty;
                            return CircleAvatar(radius: 24, backgroundColor: Colors.grey[200], backgroundImage: adaGambar ? NetworkImage(urlGambar) : null, onBackgroundImageError: adaGambar ? (_, __) {} : null, child: !adaGambar ? const Icon(Icons.person, color: Colors.grey) : null);
                          })
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))]),
                        child: Row(children: [Icon(Icons.search, color: textColor.withOpacity(0.6)), const SizedBox(width: 8), Expanded(child: TextField(style: GoogleFonts.poppins(color: textColor), decoration: InputDecoration(hintText: 'Search job here...', hintStyle: GoogleFonts.poppins(color: textColor.withOpacity(0.5)), border: InputBorder.none, isDense: true)))]),
                      ),
                      const SizedBox(height: 30),

                      // Recomended Banner
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity, height: 110, padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(gradient: LinearGradient(colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 8))]),
                            child: Row(children: [Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text('Recomended Jobs', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text('See our recomendations job for you based your skills', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis)])), const Spacer(flex: 2)]),
                          ),
                          Positioned(right: 10, top: -20, child: Image.asset('assets/images/onboarding_4.png', height: 110)),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Stats Card
                      Row(children: [Expanded(child: _StatCard(number: _appliedCount.toString(), label: 'Jobs Applied')), const SizedBox(width: 12), Expanded(child: _StatCard(number: _interviewCount.toString(), label: 'Interviews'))]),
                      const SizedBox(height: 20),

                      // ======= KATEGORI (DINAMIS & OTOMATIS) =======
                      Text('Job Categories', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      
                      _isCategoriesLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _dynamicCategories.isEmpty
                              ? Text(
                                  "Not enough jobs to show categories",
                                  style: GoogleFonts.poppins(color: textColor.withOpacity(0.5)),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: _dynamicCategories.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      String category = entry.value;
                                      
                                      // Pilih warna secara berurutan
                                      Color chipColor = _categoryColors[index % _categoryColors.length];

                                      return Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: _CategoryChip(
                                          label: category,
                                          color: chipColor,
                                          onTap: () => _navToRecent(context, category),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                      const SizedBox(height: 22),

                      // ======= FEATURED JOBS (DATA DINAMIS) =======
                      Text('Featured Jobs', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      
                      _isFeaturedLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : _featuredJobs.isEmpty 
                          ? Center(child: Text("No featured jobs yet.", style: TextStyle(color: textColor.withOpacity(0.5))))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: _featuredJobs.map((job) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: InkWell(
                                      onTap: () {
                                        final jobDataForDetail = {
                                          ...job,
                                          'icon_bg_color': job['logoColor'].value.toRadixString(16).toUpperCase(),
                                          'icon_fg_color': '0xFFFFFFFF',
                                        };
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => FeaturedJobDetailScreen(job: jobDataForDetail)),
                                        );
                                      },
                                      child: _FeaturedJobCard(
                                        title: job['title'],
                                        company: job['company'],
                                        location: job['location'],
                                        salary: job['salary'],
                                        logoColor: job['logoColor'],
                                        logoPath: job['logoPath'],
                                        isBookmarked: job['is_saved'],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                      // ======= RECENT JOBS LIST =======
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Jobs List', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecentJobScreen())),
                            child: Text('More', style: GoogleFonts.poppins(color: kPrimaryColor, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _isJobsLoading 
                        ? const Center(child: CircularProgressIndicator()) 
                        : _recentJobs.isEmpty 
                          ? Center(child: Text("No jobs found", style: TextStyle(color: textColor.withOpacity(0.5))))
                          : Column(
                              children: _recentJobs.asMap().entries.map((entry) {
                                int index = entry.key;
                                Map<String, dynamic> job = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _RecentJobTile(
                                    title: job['title'],
                                    company: job['company'],
                                    location: job['location'],
                                    salary: job['salary'],
                                    logoColor: job['logoColor'],
                                    logoPath: job['logoPath'],
                                    isBookmarked: job['is_saved'],
                                    onBookmarkTap: () => _toggleBookmark(index),
                                    fullJobData: job, 
                                  ),
                                );
                              }).toList(),
                            ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navToRecent(BuildContext context, String category) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RecentJobScreen(categoryName: category)));
  }
}

// ===================================================================
// WIDGET TAMBAHAN
// ===================================================================

class _RecentJobTile extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final Color logoColor;
  final String logoPath;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;
  final Map<String, dynamic> fullJobData;

  const _RecentJobTile({
    required this.title, required this.company, required this.location, required this.salary,
    required this.logoColor, required this.logoPath, required this.isBookmarked,
    required this.onBookmarkTap, required this.fullJobData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        // PERBAIKAN: Konversi ke Map<String, String> agar fitur Apply jalan
        final Map<String, String> jobDataForDetail = {
          'id': fullJobData['id']?.toString() ?? '',
          'title': title,
          'company': company,
          'location': location,
          'salary': salary,
          'description': fullJobData['description']?.toString() ?? 'No description provided.',
          'requirements': fullJobData['requirements']?.toString() ?? '',
          'is_saved': isBookmarked.toString(),
          'icon_bg_color': logoColor.value.toRadixString(16).toUpperCase(),
          'icon_fg_color': '0xFFFFFFFF',
        };
        Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailScreen(job: jobDataForDetail)));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))]),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: logoColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(logoPath, fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => Icon(Icons.work, color: logoColor, size: 24)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text(location, style: GoogleFonts.poppins(color: theme.textTheme.bodyMedium!.color!.withOpacity(0.6), fontSize: 12)), const SizedBox(height: 4), Text(salary, style: GoogleFonts.poppins(color: theme.primaryColor, fontWeight: FontWeight.w600))])),
          const SizedBox(width: 8),
          IconButton(icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.orange), onPressed: onBookmarkTap),
        ]),
      ),
    );
  }
}

class _FeaturedJobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final Color logoColor;
  final String? logoPath;
  final bool isBookmarked;
  const _FeaturedJobCard({required this.title, required this.company, required this.location, required this.salary, required this.logoColor, this.logoPath, this.isBookmarked = false});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 220, padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: logoPath == null ? logoColor.withOpacity(0.12) : Colors.transparent, borderRadius: BorderRadius.circular(8)), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: (logoPath != null) ? Image.asset(logoPath!, fit: BoxFit.cover, errorBuilder: (ctx,err,stack) => Icon(Icons.work, color: logoColor)) : Icon(Icons.work, color: logoColor, size: 22))), Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.orange)]), const SizedBox(height: 10), Text(company, style: GoogleFonts.poppins(color: theme.textTheme.bodyMedium!.color!.withOpacity(0.6), fontWeight: FontWeight.w500, fontSize: 13)), const SizedBox(height: 4), Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)), const SizedBox(height: 4), Text(location, style: GoogleFonts.poppins(color: theme.textTheme.bodyMedium!.color!.withOpacity(0.6), fontSize: 12)), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(salary, style: GoogleFonts.poppins(color: theme.primaryColor, fontWeight: FontWeight.w600, fontSize: 13)), Icon(Icons.arrow_forward_ios, color: theme.textTheme.bodyMedium!.color!.withOpacity(0.5), size: 14)])]),
    );
  }
}

class _ColorPickerSheet extends StatelessWidget {
  final ThemeProvider provider;
  final ScrollController scrollController;
  const _ColorPickerSheet({required this.provider, required this.scrollController});
  @override
  Widget build(BuildContext context) {
    final colors = defaultColors;
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      children: [
        Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 25),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 1.0),
          itemCount: colors.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            String name = colors.keys.elementAt(index);
            Color color = colors.values.elementAt(index);
            bool isSelected = provider.primaryColor.value == color.value;
            return _ColorPickerItem(name: name, color: color, isSelected: isSelected, onTap: () => provider.setPrimaryColor(color));
          },
        ),
      ],
    );
  }
}

class _ColorPickerItem extends StatelessWidget {
  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  const _ColorPickerItem({required this.name, required this.color, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 45, height: 45, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10), border: isSelected ? Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!, width: 2) : null), child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 28) : null),
          const SizedBox(height: 8),
          Text(name, style: GoogleFonts.poppins(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  const _StatCard({required this.number, required this.label});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(number, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(label, style: GoogleFonts.poppins(color: theme.textTheme.bodyMedium!.color!.withOpacity(0.6)))]),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _CategoryChip({required this.label, required this.color, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 6))]),
        child: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}