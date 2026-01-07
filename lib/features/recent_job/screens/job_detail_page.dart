import 'package:flutter/material.dart';
import 'our_gallery_page.dart';
import 'submission_page.dart';
import '../../../widgets/custom_drawer.dart';

// ✅ IMPORT CHAT SCREEN
import '../../chat/screens/chat_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, String> job; // Data job dari list sebelumnya

  const JobDetailScreen({required this.job, super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isNavigatingToGallery = false;
  
  // Data Galeri (Tetap)
  final List<Map<String, String>> galleryImages = const [
    {'url': 'assets/images/image1.png', 'caption': 'Amazing beach in Goa, India'},
    {'url': 'assets/images/image2.png', 'caption': 'I met this dog in Bali'},
  ];

  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    
    // Cek status saved awal (jika data ada)
    if (widget.job['is_saved'] == 'true') {
      _isSaved = true;
    }
  }

  void _handleTabSelection() {
    if (_tabController.index == 1 && !_tabController.indexIsChanging) {
      if (!_isNavigatingToGallery) {
        _isNavigatingToGallery = true;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OurGalleryScreen(images: galleryImages)),
        ).then((_) {
          _isNavigatingToGallery = false;
          _tabController.index = 0;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildJobTypeChip(BuildContext context, String label, bool isPrimary) {
    return Chip(
      label: Text(label),
      backgroundColor: isPrimary ? Colors.deepPurple.shade50 : Colors.grey.shade200,
      labelStyle: TextStyle(
        color: isPrimary ? Colors.deepPurple : Colors.black87,
        fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: isPrimary ? const BorderSide(color: Colors.deepPurple, width: 1.5) : BorderSide.none),
    );
  }

  String _getLogoPath(String jobTitle) {
    if (jobTitle.contains('Graphic')) return 'assets/images/logo 1.png';
    if (jobTitle.contains('Junior')) return 'assets/images/logo 3.png';
    return 'assets/images/logo 4.png';
  }

  void _toggleBookmark() {
    setState(() => _isSaved = !_isSaved);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isSaved ? 'Pekerjaan disimpan!' : 'Simpan dibatalkan.'), duration: const Duration(milliseconds: 800)));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor; 
    final String logoPath = _getLogoPath(widget.job['title']!);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(width: 320, child: Drawer(child: CustomDrawerBody())),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.of(context).pop()),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.asset(logoPath, width: 28, height: 28)),
            const SizedBox(width: 8),
            Text(widget.job['company'] ?? 'Company', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () => _scaffoldKey.currentState?.openDrawer())],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(children: [_buildJobTypeChip(context, 'FULLTIME', true), const SizedBox(width: 8), _buildJobTypeChip(context, 'CONTRACT', false)]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.job['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                Text(widget.job['location']!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(widget.job['salary']!, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    const Text('Salary range (monthly)', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            tabs: const [Tab(text: 'Job Description'), Tab(text: 'Our Gallery')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0), 
                  // ✅ KIRIM DATA REQUIREMENTS DARI WIDGET.JOB KE CHILD WIDGET
                  child: JobDescriptionContent(
                    primaryColor: primaryColor, 
                    description: widget.job['description'],
                    requirements: widget.job['requirements'], // <--- Ambil dari database
                  )
                ),
                const SizedBox.expand(),
              ],
            ),
          ),
          
          // === BAGIAN TOMBOL AKSI ===
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 1. TOMBOL BOOKMARK
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: primaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, size: 28, color: primaryColor),
                    onPressed: _toggleBookmark,
                  ),
                ),
                
                const SizedBox(width: 12),

                // 2. TOMBOL CHAT COMPANY
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: primaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.chat_bubble_outline, size: 26, color: primaryColor),
                    tooltip: 'Chat Company',
                    onPressed: () {
                      final String targetId = widget.job['company_id'] 
                                              ?? widget.job['created_by'] 
                                              ?? '1c0ee786-ac33-43fc-b664-57c307aef847'; 

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatPartnerId: targetId,
                            chatPartnerName: widget.job['company'] ?? 'Hiring Manager',
                            chatPartnerAvatarPath: widget.job['company_logo_url'] ?? '', 
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // 3. TOMBOL APPLY
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        builder: (context) {
                          return SubmissionPage(
                            primaryColor: primaryColor, 
                            jobId: widget.job['id'].toString()
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, 
                      padding: const EdgeInsets.symmetric(vertical: 15), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: const Text('APPLY JOB', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ WIDGET KONTEN (SUDAH DIPERBARUI AGAR DINAMIS)
class JobDescriptionContent extends StatelessWidget {
  final Color primaryColor;
  final String? description;
  final String? requirements; // ✅ Tambahkan variabel ini

  const JobDescriptionContent({
    required this.primaryColor, 
    this.description, 
    this.requirements, // ✅ Terima data
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final descText = (description != null && description!.isNotEmpty) 
        ? description! 
        : 'No description provided.';

    // ✅ LOGIKA PEMISAH BARIS BARU (Sama seperti di Featured)
    // Jika data kosong, gunakan default text
    final String reqRaw = (requirements != null && requirements!.isNotEmpty)
        ? requirements!
        : " Good understanding of the field\n Able to work in team\n Responsible";

    List<String> reqList = reqRaw.split('\n');
    reqList = reqList.where((item) => item.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Job Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor)),
        const SizedBox(height: 10),
        Text(descText, style: const TextStyle(fontSize: 14, height: 1.5)),
        
        const SizedBox(height: 20),
        
        Text('Requirements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor)),
        const SizedBox(height: 10),
        
        // ✅ TAMPILKAN LIST SECARA DINAMIS
        ...reqList.map((text) => _buildRequirementItem(text.trim(), primaryColor)).toList(),
      ],
    );
  }

  Widget _buildRequirementItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(Icons.check_circle, size: 18, color: color),
          ), 
          const SizedBox(width: 8), 
          Expanded(child: Text(text))
        ],
      ),
    );
  }
}