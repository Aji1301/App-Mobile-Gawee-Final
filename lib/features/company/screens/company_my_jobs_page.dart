import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import 'applicant_list_page.dart';
import 'post_job_page.dart'; 

class CompanyMyJobsPage extends StatefulWidget {
  const CompanyMyJobsPage({super.key});

  @override
  State<CompanyMyJobsPage> createState() => _CompanyMyJobsPageState();
}

class _CompanyMyJobsPageState extends State<CompanyMyJobsPage> {
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  void _fetchJobs() async {
    final data = await ApiService.getCompanyJobs();
    if (mounted) {
      setState(() {
        _jobs = data;
        _isLoading = false;
      });
    }
  }

  // ✅ Fungsi menghitung pelamar baru (status = 'pending')
  int _calculateNewApplicants(Map<String, dynamic> job) {
    if (job['applications'] == null) return 0;
    
    final List apps = job['applications'] as List;
    // Hitung hanya yang statusnya 'pending'
    return apps.where((app) => app['status'] == 'pending').length;
  }

  // ✅ Fungsi untuk menghilangkan notif secara visual (lokal)
  void _markAsReadLocally(int index) {
    setState(() {
      // Kita ubah list applications di memory agar statusnya tidak 'pending' lagi
      // Ini trik visual agar bubble langsung hilang tanpa refresh database
      if (_jobs[index]['applications'] != null) {
        List apps = _jobs[index]['applications'];
        for (var app in apps) {
          app['status'] = 'reviewed'; // Anggap sudah dilihat
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Applicants', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostJobPage()),
          );
          if (result == true) {
            _fetchJobs();
          }
        },
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Post Job", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _jobs.isEmpty
              ? Center(child: Text("You haven't posted any jobs yet.", style: GoogleFonts.poppins()))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _jobs.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    
                    // Hitung jumlah pelamar baru
                    int newApplicantsCount = _calculateNewApplicants(job);

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          job['title'] ?? 'No Title',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          job['location'] ?? 'Unknown Location',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        // ✅ Bagian Trailing: Bubble Count & Arrow
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tampilkan Bubble jika ada pelamar baru (> 0)
                            if (newApplicantsCount > 0)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.red, // Warna Merah untuk notif
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  newApplicantsCount.toString(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            
                            const SizedBox(width: 10), // Jarak antara bubble dan panah
                            
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ],
                        ),
                        onTap: () async {
                          // 1. Hilangkan bubble secara visual langsung (agar responsif)
                          _markAsReadLocally(index);

                          // 2. Buka halaman list pelamar
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicantListPage(
                                jobId: job['id'].toString(), // Pastikan String
                                jobTitle: job['title'],
                              ),
                            ),
                          );

                          // 3. Refresh data dari server saat kembali (Opsional, 
                          // berguna jika di halaman sebelah statusnya benar-benar diupdate di DB)
                          _fetchJobs();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}