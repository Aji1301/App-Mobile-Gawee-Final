import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Pastikan sudah ada package intl
import '../../../services/api_service.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  void _fetchApplications() async {
    final data = await ApiService.getMyApplications();
    if (mounted) {
      setState(() {
        _applications = data;
        _isLoading = false;
      });
    }
  }

  // Helper Warna Status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted': return Colors.green;
      case 'rejected': return Colors.red;
      case 'interview': return Colors.purple;
      default: return Colors.orange; // Pending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Applications', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text("You haven't applied to any jobs yet.", style: GoogleFonts.poppins(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _applications.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final app = _applications[index];
                    final job = app['jobs'] ?? {}; // Data job hasil JOIN
                    final status = app['status'] ?? 'pending';
                    final date = DateTime.parse(app['created_at']).toLocal();

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Status Badge & Tanggal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: _getStatusColor(status), width: 1),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      color: _getStatusColor(status),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy').format(date),
                                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Info Pekerjaan
                            Text(
                              job['title'] ?? 'Unknown Job',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              job['company_name'] ?? 'Unknown Company',
                              style: GoogleFonts.poppins(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            
                            // Lokasi & Gaji
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(job['location'] ?? '-', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                                const SizedBox(width: 16),
                                Icon(Icons.monetization_on_outlined, size: 14, color: Theme.of(context).primaryColor),
                                const SizedBox(width: 4),
                                Text(job['salary_range'] ?? '-', style: GoogleFonts.poppins(fontSize: 12, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}