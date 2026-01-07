import 'dart:io'; // [PENTING] Untuk akses File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // [PENTING] Package Image Picker
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_message.dart';
import '../../../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;
  final String chatPartnerAvatarPath;

  const ChatScreen({
    super.key,
    required this.chatPartnerId,
    required this.chatPartnerName,
    required this.chatPartnerAvatarPath,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // [BARU] Inisialisasi Image Picker
  final ImagePicker _picker = ImagePicker();
  
  // [BARU] State untuk loading upload
  bool _isUploading = false;

  // --- FUNGSI KIRIM PESAN TEXT ---
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    ChatService.sendMessage(
      receiverId: widget.chatPartnerId,
      content: text,
    );
    
    _controller.clear();
    _scrollToBottom();
  }

  // --- [BARU] FUNGSI KIRIM GAMBAR ---
  Future<void> _pickAndSendImage() async {
    try {
      // 1. Pilih gambar dari Galeri
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Kompresi kualitas gambar agar upload lebih cepat
      );

      if (pickedFile != null) {
        setState(() => _isUploading = true);

        // 2. Kirim ke ChatService
        await ChatService.sendImageMessage(
          receiverId: widget.chatPartnerId,
          imageFile: File(pickedFile.path),
        );

        setState(() => _isUploading = false);
        _scrollToBottom();
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengirim gambar: $e")),
        );
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
              0, 
              duration: const Duration(milliseconds: 300), 
              curve: Curves.easeOut
          );
        }
    });
  }

  // --- FUNGSI HAPUS PESAN ---
  void _confirmDeleteMessage(ChatMessage message) {
    if (!message.isMine) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Delete Message", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete this message?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ChatService.deleteMessage(message.id);
              } catch (e) {
                if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text("Failed to delete: $e")),
                   );
                }
              }
            },
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;

    final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F9);
    final appBarBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final inputBg = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[400];

    final avatarUrl = widget.chatPartnerAvatarPath;

    return Scaffold(
      backgroundColor: scaffoldBg, 
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: isDark ? Colors.grey[800] : Colors.grey[200]
              ),
              child: ClipOval(
                child: (avatarUrl.isNotEmpty)
                    ? Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Icon(Icons.person, size: 20, color: Colors.grey[400]),
                      )
                    : Icon(Icons.person, size: 20, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatPartnerName,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  StreamBuilder<Map<String, dynamic>>(
                    stream: ChatService.getOnlineStatusStream(widget.chatPartnerId),
                    builder: (context, snapshot) {
                      bool isOnline = false;
                      if (snapshot.hasData && snapshot.data != null) {
                        isOnline = snapshot.data!['is_online'] ?? false;
                      }
                      return Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isOnline ? "Online" : "Offline", 
                            style: GoogleFonts.poppins(fontSize: 12, color: isOnline ? Colors.green : subTextColor),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      body: Column(
        children: [
          // [BARU] Loading Indicator saat upload
          if (_isUploading)
            LinearProgressIndicator(
              color: primaryColor, 
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200]
            ),

          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: ChatService.getMessagesStream(widget.chatPartnerId),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: textColor)));
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: primaryColor));

                final messages = snapshot.data!;

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.waving_hand, size: 40, color: Colors.amber),
                        const SizedBox(height: 10),
                        Text(
                          "Say Hi to ${widget.chatPartnerName} 👋", 
                          style: GoogleFonts.poppins(color: subTextColor),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildBubble(message, primaryColor, isDark, textColor);
                  },
                );
              },
            ),
          ),
          
          // --- INPUT BAR ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: appBarBg,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 5, offset: const Offset(0, -2))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // [BARU] Tombol Kirim Gambar
                  IconButton(
                    icon: Icon(Icons.image_outlined, color: primaryColor),
                    // Disable tombol jika sedang upload
                    onPressed: _isUploading ? null : _pickAndSendImage,
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.poppins(fontSize: 14, color: textColor),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: GoogleFonts.poppins(color: hintColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUBBLE PESAN ---
  Widget _buildBubble(ChatMessage message, Color primaryColor, bool isDark, Color mainTextColor) {
    final isMine = message.isMine;
    final otherBubbleColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final otherTextColor = isDark ? Colors.white : const Color(0xFF333333);

    // [BARU] Cek tipe pesan
    final isImage = message.messageType == 'image';

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _confirmDeleteMessage(message),
        // [BARU] Anda bisa menambahkan onTap untuk melihat gambar full screen nanti
        onTap: isImage ? () {
          // TODO: Implement view image full screen
        } : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          // Jika gambar, padding lebih kecil agar gambar lebih besar
          padding: isImage 
              ? const EdgeInsets.all(4) 
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 260),
          decoration: BoxDecoration(
            color: isMine ? primaryColor : otherBubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMine ? 16 : 0),
              bottomRight: Radius.circular(isMine ? 0 : 16),
            ),
            boxShadow: !isMine 
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // [BARU] Render konten berdasarkan tipe
              if (isImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    message.content, // URL Gambar
                    fit: BoxFit.cover,
                    // Placeholder saat loading
                    loadingBuilder: (ctx, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150, width: 200,
                        color: Colors.black12,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: isMine ? Colors.white : primaryColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                          )
                        ),
                      );
                    },
                    // Error handler
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 100, width: 150,
                      color: Colors.grey[300],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey),
                          SizedBox(height: 4),
                          Text("Failed to load", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Text(
                  message.content,
                  style: GoogleFonts.poppins(
                    color: isMine ? Colors.white : otherTextColor,
                    fontSize: 14,
                  ),
                ),

              const SizedBox(height: 4),
              
              // Timestamp
              Padding(
                // Jika gambar, beri sedikit padding kiri agar jam tidak mepet
                padding: isImage ? const EdgeInsets.only(left: 4, bottom: 2) : EdgeInsets.zero,
                child: Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 10, 
                    color: isMine ? Colors.white.withOpacity(0.7) : Colors.grey[500]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}