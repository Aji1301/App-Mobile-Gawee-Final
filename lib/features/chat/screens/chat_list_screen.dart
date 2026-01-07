import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/chat_service.dart';
import 'chat_screen.dart';
import '../../../widgets/custom_drawer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  // 1. UPDATE: Ubah ke Future<void> dan hapus setState loading awal
  Future<void> _fetchConversations() async {
    if (!mounted) return;
    
    // HAPUS baris ini agar tidak muncul loading spinner tengah saat ditarik
    // setState(() => _isLoading = true); 
    
    final data = await ChatService.getMyConversations();
    
    if (mounted) {
      setState(() {
        _conversations = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil warna tema utama (Deep Purple)
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      drawer: SizedBox(width: 320, child: Drawer(child: CustomDrawerBody())),
      appBar: AppBar(
        title: Text(
          "Messages",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), 
        actions: [
          Builder(builder: (ctx) => IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          )),
        ],
      ),
      // 2. UPDATE: Bungkus dengan RefreshIndicator
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              onRefresh: _fetchConversations, // Fungsi yang dipanggil saat ditarik
              color: primaryColor,
              child: _conversations.isEmpty
                  ? ListView( // Gunakan ListView untuk Empty State agar tetap bisa ditarik
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text("No messages yet", style: GoogleFonts.poppins(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(), // Wajib ada agar scroll membal
                      itemCount: _conversations.length,
                      separatorBuilder: (_,__) => const Divider(height: 1, indent: 80),
                      itemBuilder: (context, index) {
                        final chat = _conversations[index];
                        final String avatarUrl = chat['avatar'] ?? '';
                        
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          // --- SAFE AVATAR (ANTI CRASH) ---
                          leading: Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: ClipOval(
                              child: (avatarUrl.isNotEmpty)
                                  ? Image.network(
                                      avatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => Icon(Icons.person, color: Colors.grey[400]),
                                    )
                                  : Icon(Icons.person, color: Colors.grey[400]),
                            ),
                          ),
                          title: Text(
                            chat['name'] ?? 'Unknown', 
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          subtitle: Text(
                            chat['lastMessage'] ?? '', 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
                          ),
                          trailing: Text(
                            _formatTime(chat['time']),
                            style: GoogleFonts.poppins(fontSize: 12, color: primaryColor, fontWeight: FontWeight.w500),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatPartnerId: chat['partnerId'],
                                  chatPartnerName: chat['name'],
                                  chatPartnerAvatarPath: avatarUrl,
                                ),
                              ),
                            );
                            _fetchConversations();
                          },
                        );
                      },
                    ),
            ),
    );
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null) return '';
    try {
      final date = DateTime.parse(timeStr).toLocal();
      return DateFormat('HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }
}