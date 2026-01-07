import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isMine;
  
  // [BARU] Properti untuk menyimpan tipe pesan ('text' atau 'image')
  final String messageType; 

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isMine,
    required this.messageType, // [BARU] Wajib diisi di constructor
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String myUserId) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      content: map['content'] ?? '',
      timestamp: DateTime.tryParse(map['created_at'].toString())?.toLocal() ?? DateTime.now(),
      isMine: map['sender_id'] == myUserId,
      
      // [BARU] Ambil 'message_type' dari database. 
      // Jika kosong (null), default-nya adalah 'text' (untuk kompatibilitas data lama)
      messageType: map['message_type'] ?? 'text', 
    );
  }
}