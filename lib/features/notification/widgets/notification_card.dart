import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final Color indicatorColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Warna Text Adaptif
    final titleColor = isDark ? Colors.white : Colors.black87;
    final descColor = isDark ? Colors.white70 : Colors.black54;
    final timeColor = isDark ? Colors.white38 : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // Warna kartu mengikuti tema (Putih/Gelap)
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Shadow halus agar terlihat melayang (hanya di mode terang)
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.0 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDark 
            ? Border.all(color: Colors.white10) // Border tipis di mode gelap
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Indikator Bulat (Warna sesuai tipe notifikasi)
          Container(
            height: 12,
            width: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),

          // 2. Konten Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Judul & Waktu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: timeColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 6),
                
                // Deskripsi
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: descColor,
                    height: 1.4, // Spasi antar baris agar mudah dibaca
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}