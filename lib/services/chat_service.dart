import 'dart:io'; // [PENTING] Untuk File image
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/chat/models/chat_message.dart'; // Pastikan path ini sesuai

class ChatService {
  static final _supabase = Supabase.instance.client;

  // ==========================================
  // 1. KIRIM PESAN (TEXT)
  // ==========================================
  static Future<void> sendMessage({
    required String receiverId,
    required String content,
    String type = 'text', // Default type adalah text
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('messages').insert({
      'sender_id': user.id,
      'receiver_id': receiverId,
      'content': content,
      'message_type': type, // Menyimpan tipe pesan (text/image)
      // created_at otomatis dihandle oleh Supabase
    });
  }

  // ==========================================
  // 2. [BARU] KIRIM PESAN GAMBAR
  // ==========================================
  static Future<void> sendImageMessage({
    required String receiverId,
    required File imageFile,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Upload Gambar ke Storage Bucket 'chat_assets'
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName; // Path file di bucket

      await _supabase.storage.from('chat_assets').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // 2. Dapatkan URL Public agar bisa diakses orang lain
      final imageUrl = _supabase.storage.from('chat_assets').getPublicUrl(filePath);

      // 3. Simpan Pesan ke Database dengan tipe 'image'
      await sendMessage(
        receiverId: receiverId,
        content: imageUrl, // Content berisi URL gambar
        type: 'image',     // Tipe pesan adalah image
      );
    } catch (e) {
      print("Error sending image: $e");
      rethrow;
    }
  }

  // ==========================================
  // 3. STREAM PESAN (Real-time chat room)
  // ==========================================
  static Stream<List<ChatMessage>> getMessagesStream(String chatPartnerId) {
    final myUserId = _supabase.auth.currentUser?.id;
    if (myUserId == null) return Stream.value([]);

    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((data) {
          final filtered = data.where((m) =>
              (m['sender_id'] == myUserId && m['receiver_id'] == chatPartnerId) ||
              (m['sender_id'] == chatPartnerId && m['receiver_id'] == myUserId));
          
          return filtered
              .map((e) => ChatMessage.fromMap(e, myUserId))
              .toList()
              .reversed
              .toList(); 
        });
  }

  // ==========================================
  // 4. AMBIL DAFTAR INBOX
  // ==========================================
  static Future<List<Map<String, dynamic>>> getMyConversations() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase
          .from('messages')
          .select('*, sender:sender_id(full_name, username, avatar_url), receiver:receiver_id(full_name, username, avatar_url)')
          .or('sender_id.eq.${user.id},receiver_id.eq.${user.id}')
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> rawList = List<Map<String, dynamic>>.from(response);
      final Map<String, Map<String, dynamic>> conversationMap = {};

      for (var msg in rawList) {
        final isSender = msg['sender_id'] == user.id;
        final partnerId = isSender ? msg['receiver_id'] : msg['sender_id'];
        
        final partnerData = isSender ? msg['receiver'] : msg['sender'];
        
        // --- LOGIKA PENENTUAN NAMA ---
        String displayName = 'Unknown User';
        
        if (partnerData != null) {
            if (partnerData['full_name'] != null && partnerData['full_name'].toString().isNotEmpty) {
                displayName = partnerData['full_name'];
            } 
            else if (partnerData['username'] != null && partnerData['username'].toString().isNotEmpty) {
                displayName = partnerData['username'];
            }
        } 
        // -----------------------------

        final String avatar = partnerData?['avatar_url'] ?? '';
        final String type = msg['message_type'] ?? 'text';
        
        // Tampilkan "Sent a photo" jika pesan terakhir adalah gambar
        String lastMsgContent = msg['content'];
        if (type == 'image') {
          lastMsgContent = isSender ? "You sent a photo" : "Sent a photo";
        }

        if (!conversationMap.containsKey(partnerId)) {
          conversationMap[partnerId] = {
            'partnerId': partnerId,
            'name': displayName,
            'avatar': avatar,    
            'lastMessage': lastMsgContent,
            'time': msg['created_at'],
            'status': (msg['is_read'] ?? false) ? 'Read' : 'Unread',
          };
        }
      }

      return conversationMap.values.toList();
    } catch (e) {
      print("Error fetching conversations: $e");
      return [];
    }
  }

  // ==========================================
  // 5. HAPUS PESAN
  // ==========================================
  static Future<void> deleteMessage(String messageId) async {
    try {
      // Pastikan RLS Policy di Supabase mengizinkan delete
      await _supabase.from('messages').delete().eq('id', messageId);
    } catch (e) {
      print("Error deleting message: $e");
      rethrow;
    }
  }

  // ==========================================
  // 6. UPDATE STATUS ONLINE/OFFLINE
  // ==========================================
  static Future<void> updateUserStatus(bool isOnline) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('profiles').update({
        'is_online': isOnline,
        'last_active': DateTime.now().toIso8601String(),
      }).eq('id', user.id);
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  // ==========================================
  // 7. STREAM STATUS LAWAN BICARA
  // ==========================================
  static Stream<Map<String, dynamic>> getOnlineStatusStream(String partnerId) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', partnerId)
        .map((event) => event.isNotEmpty ? event.first : {});
  }
}