import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Adjust path to your ThemeProvider

class AutocompletePage extends StatefulWidget {
  const AutocompletePage({super.key});

  @override
  State<AutocompletePage> createState() => _AutocompletePageState();
}

class _AutocompletePageState extends State<AutocompletePage> {
  // --- Data Dummy ---
  static const List<String> _fruits = [
    'Apple',
    'Apricot',
    'Avocado',
    'Banana',
    'Blackberry',
    'Blueberry',
    'Cherry',
    'Coconut',
    'Cranberry',
    'Dragonfruit',
    'Durian',
    'Grape',
    'Grapefruit',
    'Guava',
    'Kiwi',
    'Lemon',
    'Lime',
    'Mango',
    'Melon',
    'Orange',
    'Papaya',
    'Passion Fruit',
    'Peach',
    'Pear',
    'Pineapple',
    'Plum',
    'Pomegranate',
    'Raspberry',
    'Strawberry',
    'Watermelon'
  ];

  static const List<String> _languages = [
    'ActionScript',
    'AppleScript',
    'Asp',
    'BASIC',
    'C',
    'C++',
    'Clojure',
    'COBOL',
    'ColdFusion',
    'Dart',
    'Erlang',
    'Fortran',
    'Go',
    'Groovy',
    'Haskell',
    'Java',
    'JavaScript',
    'Kotlin',
    'Lisp',
    'Perl',
    'PHP',
    'Python',
    'Ruby',
    'Scala',
    'Scheme',
    'Swift',
    'TypeScript'
  ];

  // --- State for Selected Values ---
  String _simpleStandaloneValue = 'Apple';
  String _popupAutocompleteValue = 'Banana';
  String _multipleValues = 'Apple';
  String _ajaxValue = 'JavaScript';

  // --- Helper Widgets ---
  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.0, height: 1.4, color: textColor),
      ),
    );
  }

  Widget _buildInputLabel(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 6.0, top: 12.0),
      child: Text(label, style: TextStyle(fontSize: 14.0, color: textColor)),
    );
  }

  // --- Widget: Dropdown Autocomplete Input ---
  Widget _buildDropdownAutocomplete({
    required List<String> options,
    String label = 'Fruit',
    String? placeholder,
    required Color fieldColor,
    required Color textColor,
    required Color dividerColor,
    required Color cardColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return options.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            // Input Field View
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                style: TextStyle(fontSize: 16, color: textColor),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  hintText: placeholder ?? label,
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  filled: true,
                  fillColor: fieldColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              );
            },
            // Options List View
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                  child: Container(
                    width: constraints.maxWidth,
                    margin: const EdgeInsets.only(top: 4.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, indent: 16, color: dividerColor),
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            title: Text(option,
                                style:
                                    TextStyle(fontSize: 16, color: textColor)),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            onTap: () => onSelected(option),
                            tileColor: cardColor,
                            hoverColor: textColor.withOpacity(0.1),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- Widget: Standalone Item (Navigation) ---
  Widget _buildStandaloneItem({
    required String title,
    required List<String> data,
    required String currentValue,
    required ValueChanged<String> onValueChanged,
    required Color itemBgColor,
    required Color textColor,
    required Color dividerColor,
    required Color primaryColor,
    required bool isDark,
  }) {
    return Container(
      color: itemBgColor,
      child: Column(
        children: [
          ListTile(
            title:
                Text(title, style: TextStyle(fontSize: 16, color: textColor)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentValue,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right,
                    color: textColor.withOpacity(0.5), size: 20),
              ],
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _StandaloneSearchPage(
                    title: title,
                    data: data,
                    initialValue: currentValue,
                    isDark: isDark,
                    primaryColor: primaryColor,
                    scaffoldColor: itemBgColor, // Pass background color
                    textColor: textColor,
                  ),
                ),
              );

              if (result != null) {
                onValueChanged(result);
              }
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor, indent: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Theme Data
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = themeProvider.primaryColor;

    // 2. Define Dynamic Colors
    final scaffoldBgColor =
        isDark ? themeProvider.scaffoldColorDark : Colors.white;
    final appBarBgColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFF4);

    // Field & Item Backgrounds
    final fieldColor =
        isDark ? themeProvider.cardColor : const Color(0xFFE9E9EB);
    final itemBgColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F8);
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBgColor,
        foregroundColor: textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Autocomplete',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: dividerColor, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Search Bar Header ---
            Container(
              padding: const EdgeInsets.all(16.0),
              color: itemBgColor,
              child: TextField(
                readOnly: true,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  prefixIcon:
                      Icon(Icons.search, color: textColor.withOpacity(0.5)),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // 1. DROPDOWN AUTOCOMPLETE
            _buildSectionTitle('Dropdown Autocomplete', primaryColor),
            _buildDescription(
                'Dropdown autocomplete is good to use as a quick and simple solution to provide more options in addition to free-type value.',
                textColor),

            _buildInputLabel('Simple Dropdown Autocomplete', textColor),
            _buildDropdownAutocomplete(
                options: _fruits,
                fieldColor: fieldColor,
                textColor: textColor,
                dividerColor: dividerColor,
                cardColor: cardColor),

            _buildInputLabel('Dropdown With All Values', textColor),
            _buildDropdownAutocomplete(
                options: _fruits,
                fieldColor: fieldColor,
                textColor: textColor,
                dividerColor: dividerColor,
                cardColor: cardColor),

            _buildInputLabel('Dropdown With Placeholder', textColor),
            _buildDropdownAutocomplete(
                options: _fruits,
                placeholder: 'Type fruit name',
                fieldColor: fieldColor,
                textColor: textColor,
                dividerColor: dividerColor,
                cardColor: cardColor),

            _buildInputLabel('Dropdown With Typeahead', textColor),
            _buildDropdownAutocomplete(
                options: _fruits,
                fieldColor: fieldColor,
                textColor: textColor,
                dividerColor: dividerColor,
                cardColor: cardColor),

            _buildInputLabel('Dropdown With Ajax-Data', textColor),
            _buildDropdownAutocomplete(
                options: _languages,
                label: 'Language',
                placeholder: 'Language',
                fieldColor: fieldColor,
                textColor: textColor,
                dividerColor: dividerColor,
                cardColor: cardColor),

            _buildInputLabel('Dropdown With Ajax-Data + Typeahead', textColor),
            _buildDropdownAutocomplete(
                options: _languages,
                label: 'Language',
                placeholder: 'Language',
                fieldColor: fieldColor,
                textColor: textColor,
                dividerColor: dividerColor,
                cardColor: cardColor),

            const SizedBox(height: 30),

            // 2. STANDALONE AUTOCOMPLETE
            _buildSectionTitle('Standalone Autocomplete', primaryColor),
            _buildDescription(
                'Standalone autocomplete provides better mobile UX by opening it in a new page or popup. Good to use when you need to get strict values without allowing free-type values.',
                textColor),

            _buildInputLabel('Simple Standalone Autocomplete', textColor),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: dividerColor),
                      bottom: BorderSide(color: dividerColor))),
              child: Column(children: [
                _buildStandaloneItem(
                  title: 'Favorite Fruite',
                  data: _fruits,
                  currentValue: _simpleStandaloneValue,
                  onValueChanged: (val) =>
                      setState(() => _simpleStandaloneValue = val),
                  itemBgColor: itemBgColor,
                  textColor: textColor,
                  dividerColor: dividerColor,
                  primaryColor: primaryColor,
                  isDark: isDark,
                )
              ]),
            ),

            _buildInputLabel('Popup Autocomplete', textColor),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: dividerColor),
                      bottom: BorderSide(color: dividerColor))),
              child: Column(children: [
                _buildStandaloneItem(
                  title: 'Favorite Fruite',
                  data: _fruits,
                  currentValue: _popupAutocompleteValue,
                  onValueChanged: (val) =>
                      setState(() => _popupAutocompleteValue = val),
                  itemBgColor: itemBgColor,
                  textColor: textColor,
                  dividerColor: dividerColor,
                  primaryColor: primaryColor,
                  isDark: isDark,
                )
              ]),
            ),

            _buildInputLabel('Multiple Values', textColor),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: dividerColor),
                      bottom: BorderSide(color: dividerColor))),
              child: Column(children: [
                _buildStandaloneItem(
                  title: 'Favorite Fruite',
                  data: _fruits,
                  currentValue: _multipleValues,
                  onValueChanged: (val) =>
                      setState(() => _multipleValues = val),
                  itemBgColor: itemBgColor,
                  textColor: textColor,
                  dividerColor: dividerColor,
                  primaryColor: primaryColor,
                  isDark: isDark,
                )
              ]),
            ),

            _buildInputLabel('With Ajax-Data', textColor),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: dividerColor),
                      bottom: BorderSide(color: dividerColor))),
              child: Column(children: [
                _buildStandaloneItem(
                  title: 'Language',
                  data: _languages,
                  currentValue: _ajaxValue,
                  onValueChanged: (val) => setState(() => _ajaxValue = val),
                  itemBgColor: itemBgColor,
                  textColor: textColor,
                  dividerColor: dividerColor,
                  primaryColor: primaryColor,
                  isDark: isDark,
                )
              ]),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- Halaman Pencarian Standalone (UPDATED WITH THEME) ---
class _StandaloneSearchPage extends StatefulWidget {
  final String title;
  final List<String> data;
  final String initialValue;
  final bool isDark;
  final Color primaryColor;
  final Color scaffoldColor;
  final Color textColor;

  const _StandaloneSearchPage({
    required this.title,
    required this.data,
    required this.initialValue,
    required this.isDark,
    required this.primaryColor,
    required this.scaffoldColor,
    required this.textColor,
  });

  @override
  State<_StandaloneSearchPage> createState() => _StandaloneSearchPageState();
}

class _StandaloneSearchPageState extends State<_StandaloneSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredData = [];
  String _selectedValue = '';
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _filteredData = [];
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _hasSearched = false;
        _filteredData = [];
      } else {
        _hasSearched = true;
        _filteredData = widget.data
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onItemSelected(String value) {
    setState(() {
      _selectedValue = value;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        Navigator.pop(context, value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic colors for this page
    final cardColor = widget.isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white; // Standard dark/light card
    final hintColor = widget.textColor.withOpacity(0.5);

    return Scaffold(
      backgroundColor: widget.scaffoldColor,
      appBar: AppBar(
        backgroundColor: widget.scaffoldColor,
        foregroundColor: widget.textColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),

        // Search Bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _filterData,
              style: TextStyle(color: widget.textColor),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.search, color: hintColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.cancel, color: hintColor),
                        onPressed: () {
                          _searchController.clear();
                          _filterData('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(hintColor),
    );
  }

  Widget _buildBody(Color hintColor) {
    if (!_hasSearched) {
      return Center(
        child: Text(
          'Type to search ${widget.title}...',
          style: TextStyle(color: widget.textColor, fontSize: 16),
        ),
      );
    }

    if (_filteredData.isEmpty) {
      return Center(
        child: Text(
          'No results found.',
          style: TextStyle(color: widget.textColor, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: _filteredData.length,
      itemBuilder: (context, index) {
        final item = _filteredData[index];

        return RadioListTile<String>(
          title: Text(
            item,
            style: TextStyle(fontSize: 16, color: widget.textColor),
          ),
          value: item,
          groupValue: _selectedValue,
          activeColor: widget.primaryColor,
          onChanged: (String? value) {
            if (value != null) _onItemSelected(value);
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        );
      },
    );
  }
}
