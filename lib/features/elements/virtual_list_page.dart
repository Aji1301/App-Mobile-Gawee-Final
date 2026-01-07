import 'package:flutter/material.dart';

// =======================================================
// BAGIAN 1: MAIN APP (dari main.dart)
// =======================================================

void main() {
  runApp(const MyApp());
}

// 🚀 PERBAIKAN: Menambahkan ElementPage sebagai placeholder
class ElementPage extends StatelessWidget {
  const ElementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Element Page')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Virtual List Demo'),
          // Navigasi ke HomePage (rute '/')
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual List Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // 🚀 PERBAIKAN: Rute awal diubah ke element_page
      initialRoute: '/element-page',
      routes: {
        // 🚀 PERBAIKAN: Rute element_page ditambahkan
        '/element-page': (context) => const ElementPage(),
        '/': (context) => const HomePage(),
        '/virtual-list-vdom': (context) => const VirtualListPage(),
      },
    );
  }
}

// =======================================================
// BAGIAN 2: HOME PAGE (dari home_page.dart)
// =======================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _itemCount = 10000;

  final List<Map<String, String>> _allItems = List.generate(
    _itemCount,
    (index) => {
      'title': 'Item ${index + 1}',
      'subtitle': 'Subtitle ${index + 1}',
    },
  );

  List<Map<String, String>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterList);
    _searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems.where((item) {
          // Pencarian berdasarkan Judul
          return item['title']!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual List'),
        // 🚀 PERBAIKAN: Baris ini dihapus agar tombol kembali (cursor)
        // otomatis muncul dan mengarah ke ElementPage.
        // automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Virtual List allows to render lists with huge amount of elements without loss of performance. And it is fully compatible with all Framework7 list components such as Search Bar, Infinite Scroll, Pull To Refresh, Swipeouts (swipe-to-delete) and Sortable.',
                  style: TextStyle(fontSize: 15, height: 1.4),
                ),
                SizedBox(height: 10),
                Text(
                  'Here is the example of virtual list with 10 000 items:',
                  style: TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
          Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: ListTile(
              title: const Text('Virtual List VDOM'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/virtual-list-vdom');
              },
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text("Tidak ada item yang ditemukan."))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(item['title']!),
                            subtitle: Text(item['subtitle']!),
                            trailing: const Icon(Icons.chevron_right, size: 18),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Anda mengklik ${item['title']!} di Halaman 1',
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 0, thickness: 0.5),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// BAGIAN 3: VIRTUAL LIST PAGE (dari virtual_list_page.dart)
// =======================================================
// (Tidak ada perubahan, sudah benar)

class VirtualListPage extends StatefulWidget {
  const VirtualListPage({super.key});

  @override
  State<VirtualListPage> createState() => _VirtualListPageState();
}

class _VirtualListPageState extends State<VirtualListPage> {
  static const int _itemCount = 10000;

  final List<Map<String, String>> _allItems = List.generate(
    _itemCount,
    (index) => {
      'title': 'Item ${index + 1}',
      'subtitle': 'Subtitle${index + 1}',
    },
  );

  List<Map<String, String>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterList);
    _searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems.where((item) {
          return item['title']!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual List VDOM')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'This example shows how to use Virtual List with external renderer, like with built-in Virtual DOM',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text("Nothing found"))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(item['title']!),
                            subtitle: Text(item['subtitle']!),
                            trailing: const Icon(Icons.chevron_right, size: 18),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Anda mengklik ${item['title']!} di Halaman 2',
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 0, thickness: 0.5),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
