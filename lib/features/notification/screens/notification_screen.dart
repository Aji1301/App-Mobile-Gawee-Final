import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// Pastikan path ini benar sesuai struktur folder project Anda
// Jika belum punya widget ini, saya akan sediakan kode widgetnya di bawah
import '../widgets/notification_card.dart'; 
import '../../../widgets/custom_drawer.dart';
import '../../../services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _supabase = Supabase.instance.client;

  late final Stream<List<Map<String, dynamic>>> _notificationStream;

  @override
  void initState() {
    super.initState();
    final userId = _supabase.auth.currentUser?.id;
    
    // Inisialisasi Stream untuk Real-time Updates
    if (userId != null) {
      _notificationStream = _supabase
          .from('notifications')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('created_at', ascending: false);
    } else {
      _notificationStream = Stream.value([]);
    }
  }

  // Helper: Format Waktu (Contoh: "2h ago")
  String _formatTime(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  // Helper: Warna Indikator berdasarkan Tipe
  Color _getIndicatorColor(String type) {
    switch (type) {
      case 'success': return Colors.green;
      case 'warning': return Colors.redAccent;
      case 'application': return Colors.blueAccent;
      case 'info':
      default: return const Color(0xFF9C27B0); // Ungu default
    }
  }

  // Fungsi Hapus Notifikasi
  void _deleteNotification(String id) async {
    // Hapus dari UI langsung (Optimistic update)
    // Sebenarnya Stream akan otomatis update, tapi kita beri feedback user dulu
    
    try {
      await ApiService.deleteNotification(id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Notification deleted"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Failed to delete: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      
      // Drawer
      drawer: const SizedBox(
        width: 320,
        child: Drawer(child: CustomDrawerBody()),
      ),
      
      // AppBar
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Icon(Icons.menu, color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),

      // Body dengan StreamBuilder
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notificationStream,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          }

          // 2. Error State
          if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}"));
          }

          // 3. Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No notifications yet", 
                    style: GoogleFonts.poppins(color: Colors.grey)
                  ),
                ],
              ),
            );
          }

          final notifications = snapshot.data!;

          // 4. List Data
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final notifId = notif['id'];

              return Dismissible(
                key: Key(notifId), 
                direction: DismissDirection.endToStart, // Geser Kanan ke Kiri
                
                // Background Merah (Hapus)
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                ),
                
                onDismissed: (direction) {
                  _deleteNotification(notifId);
                },
                
                // Jika Anda punya widget NotificationCard terpisah, pakai ini.
                // Jika belum punya, ganti dengan Card biasa di bawah ini.
                child: NotificationCard(
                  title: notif['title'] ?? 'Notification',
                  description: notif['message'] ?? '',
                  time: _formatTime(notif['created_at']),
                  indicatorColor: _getIndicatorColor(notif['type'] ?? 'info'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}