// Model untuk item di daftar pesan
class MessageItem {
  final String name;
  final String lastMessage;
  final String time;
  final String status;
  final String avatarPath; // Diubah dari avatarUrl menjadi avatarPath

  MessageItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.status,
    required this.avatarPath,
  });
}
