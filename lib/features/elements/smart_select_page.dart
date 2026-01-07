// lib/smart_select_page.dart
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

class SmartSelectPage extends StatefulWidget {
  const SmartSelectPage({super.key});

  @override
  State<SmartSelectPage> createState() => _SmartSelectPageState();
}

class _SmartSelectPageState extends State<SmartSelectPage> {
  // --- Data State untuk Nilai yang Dipilih ---
  String _selectedFruit = 'Apple';
  List<String> _selectedCars = ['Honda', 'Audi', 'Ford'];
  String _selectedOS = 'Mac';
  List<String> _selectedHero = ['Batman'];

  // --- GlobalKeys (Untuk Popover "Super Hero") ---
  final GlobalKey _fruitKey = GlobalKey();
  final GlobalKey _carKey = GlobalKey();
  final GlobalKey _osKey = GlobalKey();
  final GlobalKey _heroKey = GlobalKey();

  // --- Data untuk Pilihan ---
  final List<String> _fruitOptions = [
    'Apple',
    'Pineapple',
    'Pear',
    'Orange',
    'Melon',
    'Peach',
    'Banana'
  ];
  final List<String> _heroOptions = [
    'Batman',
    'Superman',
    'Hulk',
    'Spiderman',
    'Ironman',
    'Thor',
    'Wonder Woman'
  ];
  final List<String> _osOptions = ['Mac', 'Windows'];

  // --- Helper: Widget untuk Item Pilihan ---
  Widget _buildSmartSelectItem({
    required GlobalKey itemKey,
    required String title,
    required String displayValue,
    required VoidCallback onTap,
    required Color textColor,
    required Color dividerColor,
    required Color iconColor,
  }) {
    return Column(
      children: [
        ListTile(
          key: itemKey,
          title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  displayValue,
                  style: TextStyle(
                      fontSize: 16, color: textColor.withOpacity(0.6)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: iconColor, size: 20),
            ],
          ),
          onTap: onTap,
        ),
        Divider(height: 1, thickness: 1, color: dividerColor, indent: 16),
      ],
    );
  }

  // --- 1. Aksi untuk "Fruit" ---
  void _openFruitPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SmartSelectOptionPage(
          title: 'Fruit',
          options: _fruitOptions,
          currentValue: _selectedFruit,
        ),
      ),
    );
    if (result != null) {
      setState(() => _selectedFruit = result);
    }
  }

  // --- 2. Aksi untuk "Car" ---
  void _openCarPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SmartSelectCarPage(
          currentValue: List<String>.from(_selectedCars),
        ),
      ),
    );
    if (result != null) {
      setState(() => _selectedCars = result);
    }
  }

  // --- 3. Aksi untuk "Mac or Windows" ---
  void _openOSSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SmartSelectSheetContent(
          currentValue: _selectedOS,
          options: _osOptions,
          onDone: (result) {
            if (result != null) {
              setState(() => _selectedOS = result);
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // --- 4. Aksi untuk "Super Hero" ---
  void _openHeroPopover(BuildContext context, GlobalKey key) {
    List<String> tempSelection = List.from(_selectedHero);

    // Ambil tema untuk styling popover
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final popoverBg = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = themeProvider.primaryColor;

    showPopover(
      context: key.currentContext!,
      backgroundColor: popoverBg,
      radius: 12.0,
      arrowHeight: 15.0,
      arrowWidth: 20.0,
      onPop: () {
        setState(() {
          _selectedHero = List.from(tempSelection);
        });
      },
      bodyBuilder: (context) {
        return StatefulBuilder(
          builder: (context, setPopoverState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _heroOptions.map((hero) {
                  return CheckboxListTile(
                    title: Text(hero, style: TextStyle(color: textColor)),
                    value: tempSelection.contains(hero),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: primaryColor,
                    checkColor: Colors.white,
                    onChanged: (bool? checked) {
                      setPopoverState(() {
                        if (checked == true) {
                          tempSelection.add(hero);
                        } else {
                          tempSelection.remove(hero);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data dari ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Tentukan Warna berdasarkan Tema
    final scaffoldBgColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final iconColor = isDark ? Colors.white54 : Colors.grey.shade400;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Smart Select'),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Framework7 allows you to easily convert your usual form selects to dynamic pages with radios:',
              style: TextStyle(fontSize: 16.0, height: 1.4, color: textColor),
            ),
          ),
          _buildSmartSelectItem(
            itemKey: _fruitKey,
            title: 'Fruit',
            displayValue: _selectedFruit,
            onTap: _openFruitPage,
            textColor: textColor,
            dividerColor: dividerColor,
            iconColor: iconColor,
          ),
          _buildSmartSelectItem(
            itemKey: _carKey,
            title: 'Car',
            displayValue: _selectedCars.join(', '),
            onTap: _openCarPage,
            textColor: textColor,
            dividerColor: dividerColor,
            iconColor: iconColor,
          ),
          _buildSmartSelectItem(
            itemKey: _osKey,
            title: 'Mac or Windows',
            displayValue: _selectedOS,
            onTap: _openOSSheet,
            textColor: textColor,
            dividerColor: dividerColor,
            iconColor: iconColor,
          ),
          _buildSmartSelectItem(
            itemKey: _heroKey,
            title: 'Super Hero',
            displayValue: _selectedHero.join(', '),
            onTap: () => _openHeroPopover(context, _heroKey),
            textColor: textColor,
            dividerColor: dividerColor,
            iconColor: iconColor,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 🔽 HALAMAN HELPER 1: UNTUK "Fruit" 🔽 ---
// -----------------------------------------------------------------
class _SmartSelectOptionPage extends StatefulWidget {
  final String title;
  final List<String> options;
  final String currentValue;

  const _SmartSelectOptionPage({
    Key? key,
    required this.title,
    required this.options,
    required this.currentValue,
  }) : super(key: key);

  @override
  State<_SmartSelectOptionPage> createState() => _SmartSelectOptionPageState();
}

class _SmartSelectOptionPageState extends State<_SmartSelectOptionPage> {
  late String _tempValue;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final primaryColor = themeProvider.primaryColor;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, _tempValue),
            ),
            title: Text(widget.title),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          final option = widget.options[index];
          return RadioListTile<String>(
            title: Text(option, style: TextStyle(color: textColor)),
            value: option,
            groupValue: _tempValue,
            onChanged: (String? value) {
              setState(() {
                _tempValue = value!;
              });
              Navigator.pop(context, _tempValue);
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: primaryColor,
          );
        },
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: dividerColor, indent: 16),
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 🔽 HALAMAN HELPER 2: UNTUK "Car" 🔽 ---
// -----------------------------------------------------------------
class _SmartSelectCarPage extends StatefulWidget {
  final List<String> currentValue;

  const _SmartSelectCarPage({Key? key, required this.currentValue})
      : super(key: key);

  @override
  State<_SmartSelectCarPage> createState() => _SmartSelectCarPageState();
}

class _SmartSelectCarPageState extends State<_SmartSelectCarPage> {
  final Map<String, List<String>> _carGroups = {
    'Japanese': ['Honda', 'Lexus', 'Mazda', 'Nissan', 'Toyota'],
    'German': ['Audi', 'BMW', 'Mercedes', 'Volkswagen', 'Volvo'],
    'American': ['Cadillac', 'Chrysler', 'Dodge'],
  };

  late List<String> _tempValue;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempValue = widget.currentValue;
  }

  Widget _buildGroup(String title, List<String> options, Color textColor,
      Color headerBgColor, Color primaryColor) {
    final filteredOptions = options
        .where((opt) => opt.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    if (filteredOptions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: headerBgColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(0.6)),
          ),
        ),
        ...filteredOptions.map((option) {
          final bool isSelected = _tempValue.contains(option);
          return CheckboxListTile(
            title: Text(option, style: TextStyle(color: textColor)),
            value: isSelected,
            onChanged: (bool? checked) {
              setState(() {
                if (checked == true) {
                  _tempValue.add(option);
                } else {
                  _tempValue.remove(option);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: primaryColor,
            checkColor: Colors.white,
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final headerBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final primaryColor = themeProvider.primaryColor;
    final searchFillColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarBgColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1.0)),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: textColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Car'),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, _tempValue),
                child: Text('Close',
                    style: TextStyle(color: textColor, fontSize: 16)),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: appBarBgColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search car',
                hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600),
                prefixIcon: Icon(Icons.search,
                    color: isDark ? Colors.white54 : Colors.grey.shade600),
                filled: true,
                fillColor: searchFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
              ),
            ),
          ),
          Divider(height: 1, color: dividerColor),
          Expanded(
            child: ListView(
              children: _carGroups.entries
                  .map((entry) => _buildGroup(entry.key, entry.value, textColor,
                      headerBgColor, primaryColor))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- 🔽 WIDGET HELPER 3: UNTUK "Mac or Windows" 🔽 ---
// -----------------------------------------------------------------
class _SmartSelectSheetContent extends StatefulWidget {
  final String currentValue;
  final List<String> options;
  final Function(String?) onDone;

  const _SmartSelectSheetContent({
    Key? key,
    required this.currentValue,
    required this.options,
    required this.onDone,
  }) : super(key: key);

  @override
  State<_SmartSelectSheetContent> createState() =>
      _SmartSelectSheetContentState();
}

class _SmartSelectSheetContentState extends State<_SmartSelectSheetContent> {
  String? _tempValue;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final headerBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);
    final primaryColor = themeProvider.primaryColor;

    return Material(
      color: bgColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: headerBgColor,
                border: Border(bottom: BorderSide(color: dividerColor)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => widget.onDone(_tempValue),
                    child: Text(
                      'Done',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            ...widget.options.map((option) {
              return RadioListTile<String>(
                title: Text(option, style: TextStyle(color: textColor)),
                value: option,
                groupValue: _tempValue,
                onChanged: (String? value) {
                  setState(() => _tempValue = value);
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: primaryColor,
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
