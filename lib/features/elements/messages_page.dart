import 'package:flutter/material.dart';
import '../chat/screens/chat_list_screen.dart'; // Pastikan import ini mengarah ke file ChatListScreen kamu

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita langsung memanggil ChatListScreen() di sini.
    // ChatListScreen sudah menangani:
    // 1. Fetch data percakapan (_fetchConversations)
    // 2. Tampilan Loading & Empty State
    // 3. Navigasi ke ChatScreen saat item diklik
    return const ChatListScreen();
  }
}