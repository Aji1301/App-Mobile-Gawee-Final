import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class FabPage extends StatelessWidget {
  const FabPage({super.key});

  final String dummyText =
      "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quia, quo rem beatae, delectus eligendi est saepe molestias perferendis suscipit, commodi labore ipsa non quasi eum magnam neque ducimus! Quasi, numquam.\n\n"
      "Maiores culpa, itaque! Eaque natus ab cum ipsam numquam blanditiis a, quia, molestiae aut laudantium recusandae ipsa. Ad iste ex asperiores ipsa, mollitia perferendis consectetur quam eaque, voluptate laboriosam unde.\n\n"
      "Sed odit quis aperiam temporibus vitae necessitatibus, laboriosam, exercitationem dolores odio sapiente provident. Accusantium id, itaque aliquam libero ipsum eos fugiat distinctio laboriosam exercitationem sequi facere quas quidem magnam reprehenderit.\n\n"
      "Pariatur corporis illo, amet doloremque. Ab veritatis sunt nisi consectetur error modi, nam illo et nostrum quia aliquam ipsam vitae facere voluptates atque similique odit mollitia, rerum placeat nobis est.\n\n"
      "Et impedit soluta minus a autem adipisci cupiditate eius dignissimos nihil officia dolore voluptatibus aperiam reprehenderit esse facilis labore qui, officiis consectetur. Ipsa obcaecati aspernatur odio assumenda veniam, ipsum alias.\n\n"
      "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Culpa ipsa debitis sed nihil eaque dolore cum iste quibusdam, accusamus doloribus, tempora quia quos voluptatibus corporis officia at quas dolorem earum!\n\n"
      "Quod soluta eos inventore magnam suscipit enim at hic in maiores temporibus pariatur tempora minima blanditiis vero autem est perspiciatis totam dolorum, itaque repellat? Nobis necessitatibus aut odit aliquam adipisci.\n\n"
      "Tenetur delectus perspiciatis ex numquam, unde corrupti velit! Quam aperiam, animi fuga veritatis consectetur, voluptatibus atque consequuntur dignissimos itaque, sint impedit cum cumque at. Adipisci sint, iusto blanditiis ullam? Vel?\n\n"
      "Dignissimos velit officia quibusdam! Eveniet beatae, aut, omnis temporibus consequatur expedita eaque aliquid quos accusamus fugiat id iusto autem obcaecati repellat fugit cupiditate suscipit natus quas doloribus? Temporibus necessitatibus, libero.\n\n"
      "Architecto quisquam ipsa fugit facere, repudiandae asperiores vitae obcaecati possimus, labore excepturi reprehenderit consectetur perferendis, ullam quidem hic, repellat fugiat eaque fuga. Consectetur in eveniet, deleniti recusandae omnis eum quas?\n\n"
      "Quos nulla consequatur quo, officia quaerat. Nulla voluptatum, assumenda quibusdam, placeat cum aut illo deleniti dolores commodi odio ipsam, recusandae est pariatur veniam repudiandae blanditiis. Voluptas unde deleniti quisquam, nobis?\n\n"
      "Atque qui quaerat quasi officia molestiae, molestias totam incidunt reprehenderit laboriosam facilis veritatis, non iusto! Dolore ipsam obcaecati voluptates minima maxime minus qui mollitia facere. Nostrum esse recusandae voluptatibus eligendi. ganti teksnya menjadi itu";

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final primaryColor = themeProvider.primaryColor;

    // Background Scaffold & AppBar
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;

    // Warna Teks & Icon
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBgColor, // Background dinamis
      appBar: AppBar(
        title: Text(
          'Floating Action Button',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBgColor, // AppBar background dinamis
        elevation: 0.5,
        iconTheme: IconThemeData(color: iconColor),
      ),

      body: Stack(
        children: [
          // Konten Utama (Scrollable)
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dummyText,
                    style: TextStyle(
                        fontSize: 16, color: textColor) // Teks dinamis
                    ),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // --- KELOMPOK SUDUT KANAN ---
          // FAB 1: Top Right
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: 'fab1_rt',
                onPressed: () {},
                backgroundColor: primaryColor, // Mengikuti tema
                foregroundColor:
                    Colors.white, // Mengubah icon jadi putih agar kontras
                child: const Icon(Icons.add),
              ),
            ),
          ),

          // FAB 3: Bottom Right
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: 'fab3_rb',
                onPressed: () {},
                backgroundColor: primaryColor, // Mengikuti tema
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              ),
            ),
          ),

          // --- KELOMPOK SUDUT KIRI ---
          // FAB KIRI ATAS
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: 'fab_lt',
                onPressed: () {},
                backgroundColor: primaryColor, // Mengikuti tema
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              ),
            ),
          ),

          // FAB KIRI BAWAH
          Positioned(
            bottom: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: 'fab_lb',
                onPressed: () {},
                backgroundColor: primaryColor, // Mengikuti tema
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              ),
            ),
          ),

          // --- FAB TENGAH HALAMAN (PUSAT) ---
          Positioned(
            // Menghitung posisi pusat layar
            top: MediaQuery.of(context).size.height / 2 -
                kToolbarHeight / 2 -
                28,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              heroTag: 'fab_center',
              onPressed: () {},
              backgroundColor: primaryColor, // Mengikuti tema
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ),

          // --- FAB 4: Bottom Center (Extended - Tetap) ---
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                heroTag: 'fab4_ext',
                onPressed: () {},
                backgroundColor: primaryColor, // Mengikuti tema
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('CREATE'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
