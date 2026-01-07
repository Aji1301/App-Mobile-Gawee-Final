import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import drawer Anda
import '../../../widgets/custom_drawer.dart';
// Import halaman recent_job (untuk tombol 'Available Jobs')
import '../../recent_job/screens/recent_job_page.dart';
// Import ApiService
import '../../../services/api_service.dart';

class FeaturedJobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const FeaturedJobDetailScreen({super.key, required this.job});

  @override
  State<FeaturedJobDetailScreen> createState() =>
      _FeaturedJobDetailScreenState();
}

class _FeaturedJobDetailScreenState extends State<FeaturedJobDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final double _headerImageHeight = 250.0;
  final double _logoHeight = 100.0;
  final BorderRadius _logoBorderRadius = BorderRadius.circular(20);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getLogoPath(String jobTitle) {
    if (jobTitle.contains('Graphic')) {
      return 'assets/images/logo 1.png';
    } else if (jobTitle.contains('Junior')) {
      return 'assets/images/logo 3.png';
    } else {
      return 'assets/images/logo 4.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kPrimaryColor = theme.primaryColor;

    final title = widget.job['title'] ?? 'Job Title';
    final location = widget.job['location'] ?? 'Location';
    final companyName = widget.job['company_name'] ?? widget.job['company'] ?? 'Company';
    final description = widget.job['description'] ?? 'No description available.';
    
    // ✅ AMBIL DATA REQUIREMENTS DARI DATABASE
    // Jika null, gunakan template default
    final String requirementsRaw = widget.job['requirements'] ?? 
        "Good understanding of the field\nAble to work in team\nResponsible";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SizedBox(
        width: 320,
        child: Drawer(child: CustomDrawerBody()),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // A. HEADER AREA
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // Gambar Header
                    SizedBox(
                      height: _headerImageHeight,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/feature_job.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]),
                      ),
                    ),
                    // Gradient
                    Container(
                      height: _headerImageHeight,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                    // Container Putih
                    Container(
                      margin: EdgeInsets.only(top: _headerImageHeight - 30),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80.0, bottom: 30.0),
                        child: Column(
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 22, fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              location,
                              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 20),
                            // Tombol See Available Jobs
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecentJobScreen(companyName: companyName),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('See Available Jobs', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: kPrimaryColor)),
                                      Icon(Icons.arrow_forward_ios, size: 16, color: kPrimaryColor),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Logo
                    Positioned(
                      top: _headerImageHeight - (_logoHeight / 2) - 30,
                      child: Container(
                        height: _logoHeight,
                        width: _logoHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: _logoBorderRadius,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: ClipRRect(
                          borderRadius: _logoBorderRadius,
                          child: Image.asset(
                            _getLogoPath(title),
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) => const Icon(Icons.business, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // B. TAB BAR
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: kPrimaryColor,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorColor: kPrimaryColor,
                    indicatorWeight: 3,
                    labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    tabs: const [
                      Tab(text: 'ABOUT US'),
                      Tab(text: 'RATINGS'),
                      Tab(text: 'REVIEW'),
                    ],
                  ),
                ),
              ),

              // C. TAB CONTENT
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // ✅ PASSING REQUIREMENTS KE SINI
                      _AboutUsTabContent(
                        description: description, 
                        requirements: requirementsRaw
                      ),
                      
                      _RatingsTabContent(companyName: companyName),
                      
                      _ReviewTabContent(companyName: companyName),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Tombol Back
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  const _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) => Container(color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// ✅ TAB 1: ABOUT US (DYNAMIC REQUIREMENTS)
// ---------------------------------------------------------------------------
class _AboutUsTabContent extends StatelessWidget {
  final String description;
  final String requirements;

  const _AboutUsTabContent({required this.description, required this.requirements});

  @override
  Widget build(BuildContext context) {
    // Pecah text requirements berdasarkan baris baru (\n)
    List<String> reqList = requirements.split('\n');
    reqList = reqList.where((item) => item.trim().isNotEmpty).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600], height: 1.6)),
          const SizedBox(height: 20),
          Text('Requirements', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color)),
          const SizedBox(height: 10),
          
          // Loop requirements secara dinamis
          ...reqList.map((req) => _RequirementItem(text: req.trim())).toList(),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  const _RequirementItem({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700]))),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 2: RATINGS
// ---------------------------------------------------------------------------
class _RatingsTabContent extends StatefulWidget {
  final String companyName;
  const _RatingsTabContent({required this.companyName});

  @override
  State<_RatingsTabContent> createState() => _RatingsTabContentState();
}

class _RatingsTabContentState extends State<_RatingsTabContent> {
  late Future<List<Map<String, dynamic>>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = ApiService.getCompanyReviews(widget.companyName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data ?? [];

        // --- HITUNG STATISTIK ---
        int totalReviews = reviews.length;
        double averageRating = 0.0;
        Map<int, int> starCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

        if (totalReviews > 0) {
          int sum = 0;
          for (var r in reviews) {
            int rating = r['rating'] ?? 0;
            sum += rating;
            if (starCounts.containsKey(rating)) {
              starCounts[rating] = starCounts[rating]! + 1;
            }
          }
          averageRating = sum / totalReviews;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ratings',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  // Kolom Kiri: Angka Besar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < averageRating.floor() ? Icons.star : 
                            (index < averageRating ? Icons.star_half : Icons.star_border),
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(height: 5),
                      Text('$totalReviews reviews', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  
                  // Kolom Kanan: Grafik Batang Distribusi
                  Expanded(
                    child: Column(
                      children: [
                        _RatingBar(label: "5", count: starCounts[5]!, total: totalReviews),
                        _RatingBar(label: "4", count: starCounts[4]!, total: totalReviews),
                        _RatingBar(label: "3", count: starCounts[3]!, total: totalReviews),
                        _RatingBar(label: "2", count: starCounts[2]!, total: totalReviews),
                        _RatingBar(label: "1", count: starCounts[1]!, total: totalReviews),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;

  const _RatingBar({required this.label, required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    double percentage = total == 0 ? 0 : count / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 3: REVIEW LIST & INPUT
// ---------------------------------------------------------------------------
class _ReviewTabContent extends StatefulWidget {
  final String companyName;
  const _ReviewTabContent({required this.companyName});
  @override
  State<_ReviewTabContent> createState() => _ReviewTabContentState();
}

class _ReviewTabContentState extends State<_ReviewTabContent> {
  late Future<List<Map<String, dynamic>>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _refreshReviews();
  }

  void _refreshReviews() {
    setState(() {
      _reviewsFuture = ApiService.getCompanyReviews(widget.companyName);
    });
  }

void _showAddReviewDialog() {
    final commentController = TextEditingController();
    int selectedRating = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Rate ${widget.companyName}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () => setDialogState(() => selectedRating = index + 1),
                        icon: Icon(index < selectedRating ? Icons.star : Icons.star_border, color: Colors.amber, size: 32),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(hintText: 'Share your experience...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () async {
                    String currentUserName = "Anonymous";
                    final profile = await ApiService.getProfile();
                    
                    if (profile != null) {
                      currentUserName = profile['name'] ?? profile['full_name'] ?? profile['username'] ?? 'User';
                    }

                    await ApiService.addCompanyReview(widget.companyName, selectedRating, commentController.text, currentUserName);
                    if (mounted) {
                      Navigator.pop(context);
                      _refreshReviews();
                    }
                  },
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: _showAddReviewDialog,
            icon: const Icon(Icons.rate_review, size: 18, color: Colors.white),
            label: const Text("Write a Review", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _reviewsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("No reviews yet.", style: GoogleFonts.poppins(color: Colors.grey)));

              final reviews = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  String date = review['created_at'] != null ? review['created_at'].toString().substring(0, 10) : "Recently";
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 20, backgroundColor: Colors.grey[200], child: Icon(Icons.person, color: Colors.grey[400])),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(review['reviewer_name'] ?? 'Anonymous', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                  Row(children: List.generate(5, (i) => Icon(i < (review['rating'] ?? 0) ? Icons.star : Icons.star_border, color: Colors.amber, size: 14))),
                                ],
                              ),
                              Text(date, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 5),
                              Text(review['comment'] ?? '', style: GoogleFonts.poppins(fontSize: 13)),
                              const Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}