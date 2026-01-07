import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

// ✅ IMPORT RESUME PREVIEW (Sesuaikan path jika folder berbeda)
import '../../resume/screens/resume_preview_screen.dart';

// ✅ IMPORT CHAT SCREEN (Sesuaikan path jika folder berbeda)
import '../../chat/screens/chat_screen.dart';

class ApplicantListPage extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const ApplicantListPage({
    required this.jobId,
    required this.jobTitle,
    super.key,
  });

  @override
  State<ApplicantListPage> createState() => _ApplicantListPageState();
}

class _ApplicantListPageState extends State<ApplicantListPage> {
  List<Map<String, dynamic>> _applicants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApplicants();
  }

  void _fetchApplicants() async {
    final data = await ApiService.getApplicants(widget.jobId);
    if (mounted) {
      setState(() {
        _applicants = data;
        _isLoading = false;
      });
    }
  }

  void _showStatusOptions(String applicationId, String currentStatus) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Update Status", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildStatusOption(applicationId, 'interview', Colors.purple, "Invite to Interview"),
              _buildStatusOption(applicationId, 'accepted', Colors.green, "Accept Applicant"),
              _buildStatusOption(applicationId, 'rejected', Colors.red, "Reject Applicant"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(String appId, String statusValue, Color color, String label) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(Icons.circle, color: color, size: 14)),
      title: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      onTap: () async {
        Navigator.pop(context); // Tutup BottomSheet
        setState(() => _isLoading = true);
        
        bool success = await ApiService.updateApplicationStatus(appId, statusValue);
        
        if (success) {
          _fetchApplicants(); // Refresh list
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Status Updated!")));
          }
        }
        setState(() => _isLoading = false);
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted': return Colors.green;
      case 'rejected': return Colors.red;
      case 'interview': return Colors.purple;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobTitle, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applicants.isEmpty
              ? Center(child: Text("No applicants yet.", style: GoogleFonts.poppins()))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _applicants.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final app = _applicants[index];
                    final String status = app['status'] ?? 'pending';

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Header: Nama & Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  app['applicant_name'] ?? 'No Name',
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
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
                              ],
                            ),
                            const SizedBox(height: 8),

                            // 2. Kontak Info
                            Row(
                              children: [
                                Icon(Icons.email, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 6),
                                Text(app['applicant_email'] ?? '-', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 6),
                                Text(app['applicant_phone'] ?? '-', style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 13)),
                              ],
                            ),
                            
                            const Divider(height: 24),

                            // 3. TOMBOL AKSI (View Resume, Chat, Status)
                            Row(
                              children: [
                                // Tombol View Resume (Utama)
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // 🔥 BUKA RESUME PREVIEW 🔥
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResumePreviewScreen(
                                            applicantId: app['applicant_id'], // ID Pelamar
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.description, size: 18),
                                    label: const Text("View Resume"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Tombol Chat (Kecil)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          chatPartnerId: app['applicant_id'], 
                                          chatPartnerName: app['applicant_name'] ?? 'Candidate',
                                          chatPartnerAvatarPath: app['applicant_avatar'] ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                    ),
                                    child: const Icon(Icons.chat_bubble_outline, color: Colors.blue, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Tombol Status (Kecil)
                                InkWell(
                                  onTap: () => _showStatusOptions(app['id'], status),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                    ),
                                    child: const Icon(Icons.edit, color: Colors.orange, size: 20),
                                  ),
                                ),
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