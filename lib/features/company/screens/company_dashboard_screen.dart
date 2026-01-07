import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import '../../resume/screens/resume_preview_screen.dart'; // Import Resume Preview

// SCREEN 1: DASHBOARD (DAFTAR LOWONGAN SAYA)
class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  List<Map<String, dynamic>> _myJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyJobs();
  }

  void _loadMyJobs() async {
    final jobs = await ApiService.getCompanyJobs();
    if (mounted) setState(() { _myJobs = jobs; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Job Postings"), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _myJobs.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final job = _myJobs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(job['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  subtitle: Text("Location: ${job['location']}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Buka Daftar Pelamar untuk Job ini
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobApplicantsScreen(jobId: job['id'], jobTitle: job['title']),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            // Nanti di sini arahkan ke halaman "Post Job"
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Post Job belum dibuat")));
        }, 
        child: const Icon(Icons.add),
      ),
    );
  }
}

// SCREEN 2: DAFTAR PELAMAR (APPLICANTS LIST)
class JobApplicantsScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicantsScreen({required this.jobId, required this.jobTitle, super.key});

  @override
  State<JobApplicantsScreen> createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  List<Map<String, dynamic>> _applicants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplicants();
  }

  void _loadApplicants() async {
    final data = await ApiService.getApplicants(widget.jobId);
    if (mounted) setState(() { _applicants = data; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Applicants: ${widget.jobTitle}"), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _applicants.isEmpty 
          ? const Center(child: Text("Belum ada pelamar."))
          : ListView.builder(
              itemCount: _applicants.length,
              itemBuilder: (context, index) {
                final app = _applicants[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(app['applicant_name'] ?? "Unknown"),
                  subtitle: Text("Status: ${app['status']}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    onPressed: () {
                      // 🔥 INI BAGIAN KUNCI: LIHAT RESUME PELAMAR 🔥
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResumePreviewScreen(
                            applicantId: app['applicant_id'], // Kirim ID Pelamar
                          ),
                        ),
                      );
                    }, 
                    child: const Text("View Resume", style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
    );
  }
}