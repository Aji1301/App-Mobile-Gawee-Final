import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// Model data Nutrisi (Tetap)
class NutritionData {
  final String dessert;
  final int calories;
  final double fat;
  final int carbs;
  final double protein;
  bool isInStock;
  final String comments;

  NutritionData(
    this.dessert,
    this.calories,
    this.fat,
    this.carbs,
    this.protein, {
    this.isInStock = true,
    this.comments = 'N/A',
  });
}

// Data List (Tetap)
final List<NutritionData> dessertData = [
  NutritionData('Frozen yogurt', 159, 6.0, 24, 4.0,
      comments: 'I like frozen yogurt'),
  NutritionData('Ice cream sandwich', 237, 9.0, 37, 4.4,
      isInStock: false, comments: 'But like ice cream more'),
  NutritionData('Eclair', 262, 16.0, 24, 6.0, comments: 'Super tasty'),
  NutritionData('Cupcake', 305, 3.7, 67, 4.3, comments: "Don't like it"),
  NutritionData('Gingerbread', 356, 17.0, 49, 3.9),
  NutritionData('Jelly bean', 375, 0.0, 94, 0.0, isInStock: false),
  NutritionData('Lollipop', 392, 0.2, 98, 0.0),
  NutritionData('Honeycomb', 408, 3.2, 87, 6.5),
  NutritionData('Donut', 452, 25.0, 51, 4.9),
  NutritionData('KitKat', 518, 26.0, 65, 7.0),
  NutritionData('Krusty Krab Pizza', 1500, 50.0, 200, 50.0),
];

class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  // State dan Konstanta
  int _rowsPerPage = 5;
  final List<int> _availableRowsPerPage = [5, 10, 25, 100];

  // State terpisah untuk isolasi seleksi
  final List<bool> _selectableRowsSelected = List.filled(4, false);
  final List<bool> _tabletOnlyRowsSelected = List.filled(4, false);
  final List<bool> _defaultStyleSelected = List.filled(4, false);
  final List<bool> _alternateHeaderSelected = List.filled(4, false);
  final List<bool> _sortableSelected = List.filled(4, false);
  final List<bool> _cardWithTitleSelected = List.filled(4, false);
  final List<bool> _cardPlainSelected = List.filled(4, false);

  // State untuk pengurutan (Sortable Columns)
  int? _sortColumnIndex;
  bool _sortAscending = true;

  final double _fixedColumnWidth = 150.0;
  final double _dataCellHeight = 48.0;
  final double _inStockColumnWidth = 120.0;
  final double _nutrientColWidth = 80.0;

  // --- LOGIKA PENGURUTAN (Tetap) ---
  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      List<NutritionData> sortableData = dessertData.sublist(0, 4);

      sortableData.sort((a, b) {
        Comparable aValue;
        Comparable bValue;

        switch (columnIndex) {
          case 0:
            aValue = a.dessert;
            bValue = b.dessert;
            break;
          case 1:
            aValue = a.calories;
            bValue = b.calories;
            break;
          case 2:
            aValue = a.fat;
            bValue = b.fat;
            break;
          case 3:
            aValue = a.carbs;
            bValue = b.carbs;
            break;
          case 4:
            aValue = a.protein;
            bValue = b.protein;
            break;
          default:
            return 0;
        }

        final comparison = Comparable.compare(aValue, bValue);
        return ascending ? comparison : -comparison;
      });
    });
  }

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

    // Warna Teks
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    final dividerColor = isDark ? Colors.white12 : Colors.grey.shade300;

    final List<NutritionData> dataForTables = dessertData.sublist(0, 4);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          'Data Table',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBgColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Bagian 1: Plain Table ---
            _buildSectionTitle('Plain table', primaryColor),
            _buildNutritionTable(
              withCheckboxes: false,
              data: dataForTables,
              isPaginationTable: false,
              textColor: textColor,
              dividerColor: dividerColor,
              headerColor: isDark ? themeProvider.cardColor : Colors.white,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- Bagian 1.5: within card ---
            _buildSectionTitle('within card', primaryColor),
            _buildNutritionTableInCard(
              withCheckboxes: true,
              data: dataForTables,
              selectedList: _cardPlainSelected,
              cardColor: isDark ? themeProvider.cardColor : Colors.white,
              textColor: textColor,
              dividerColor: dividerColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- Bagian 1.7: With Footer Pagination (Fixed Column) ---
            _buildSectionTitle(
                'With Footer Pagination (Fixed Column)', primaryColor),
            _buildCustomFixedColumnTable(
                data: dessertData,
                textColor: textColor,
                dividerColor: dividerColor,
                footerColor:
                    isDark ? themeProvider.cardColor : Colors.grey.shade50,
                subTextColor: subTextColor),

            const SizedBox(height: 30),

            // --- Selectable rows (Custom Checkbox) ---
            _buildSectionTitle('Selectable rows', primaryColor),
            _buildSelectableTable(
              data: dataForTables,
              isCustomSelectable: true,
              selectedList: _selectableRowsSelected,
              textColor: textColor,
              dividerColor: dividerColor,
              headerColor: isDark ? themeProvider.cardColor : Colors.white,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- Tablet-only columns (Custom Checkbox) ---
            _buildSectionTitle('Tablet-only columns', primaryColor),
            Text(
              '"Comments" column will be visible only on devices with screen width >= 768px (tablets)',
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            _buildTabletOnlyTable(
              data: dataForTables,
              isCustomSelectable: true,
              selectedList: _tabletOnlyRowsSelected,
              textColor: textColor,
              dividerColor: dividerColor,
              headerColor: isDark ? themeProvider.cardColor : Colors.white,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- Bagian 3: With Inputs (Admin Table) ---
            _buildSectionTitle('With inputs', primaryColor),
            Text(
              'Such tables are widely used in admin interfaces for filtering or search data',
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            const SizedBox(height: 10),
            _buildAdminTableWithFilters(textColor, dividerColor, primaryColor),

            const SizedBox(height: 30),

            // --- Within card with title and actions ---
            _buildSectionTitle(
                'Within card with title and actions', primaryColor),
            _buildCardWithTitleAndActions(
              data: dataForTables,
              selectedList: _cardWithTitleSelected,
              cardColor: isDark ? themeProvider.cardColor : Colors.white,
              textColor: textColor,
              dividerColor: dividerColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- Sortable columns ---
            _buildSectionTitle('Sortable columns', primaryColor),
            _buildNutritionTable(
              withCheckboxes: true,
              showTitle: true,
              data: dataForTables,
              isPaginationTable: false,
              onSort: _onSort,
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              selectedList: _sortableSelected,
              textColor: textColor,
              dividerColor: dividerColor,
              headerColor: isDark ? themeProvider.cardColor : Colors.white,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- With title and different actions on select (Default Style) ---
            _buildSectionTitle(
              'With title and different actions on select (Default Style)',
              primaryColor,
            ),
            _buildNutritionTable(
              withCheckboxes: true,
              showTitle: true,
              data: dataForTables,
              isPaginationTable: false,
              selectedList: _defaultStyleSelected,
              textColor: textColor,
              dividerColor: dividerColor,
              headerColor: isDark ? themeProvider.cardColor : Colors.white,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- Alternate header with actions ---
            _buildSectionTitle('Alternate header with actions', primaryColor),
            _buildAlternateHeaderTable(
              data: dataForTables,
              selectedList: _alternateHeaderSelected,
              textColor: textColor,
              dividerColor: dividerColor,
              headerColor: isDark ? themeProvider.cardColor : Colors.white,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 30),

            // --- Collapsible Table ---
            _buildSectionTitle('Collapsible', primaryColor),
            Text(
              'The following table will be collapsed to kind of List View on small screens:',
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            _buildNutritionTable(
              withCheckboxes: false,
              showTitle: true,
              data: dataForTables,
              isPaginationTable: false,
              textColor: textColor,
              dividerColor: dividerColor,
              headerColor: isDark ? themeProvider.cardColor : Colors.white,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // WIDGET PEMBANTU UTAMA (MENGURUS SEMUA VARIASI DATATABLE STANDAR)
  // -------------------------------------------------------------------

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildNutritionTable({
    required List<NutritionData> data,
    List<bool>? selectedList,
    bool withCheckboxes = false,
    bool isCustomSelectable = false,
    bool showTitle = false,
    bool isPaginationTable = false,
    bool includeInStockColumn = false,
    bool showTabletOnlyColumn = false,
    bool includeActionsColumn = false,
    Function(int, bool)? onSort,
    int? sortColumnIndex,
    bool sortAscending = true,
    required Color textColor,
    required Color dividerColor,
    required Color headerColor,
    required Color primaryColor,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    List<NutritionData> displayedData = data;

    // Cek status header In Stock
    bool? isAllInStock;
    if (includeInStockColumn && data.isNotEmpty) {
      bool allTrue = data.every((item) => item.isInStock);
      bool allFalse = data.every((item) => !item.isInStock);
      if (allTrue)
        isAllInStock = true;
      else if (allFalse)
        isAllInStock = false;
      else
        isAllInStock = null;
    }

    // --- 1. Definisi Kolom Header ---
    List<DataColumn> initialColumns = [];

    // 1. Tambahkan kolom Checkbox kustom (Header)
    if (isCustomSelectable && selectedList != null) {
      bool allCustomSelected = selectedList.every((selected) => selected);

      initialColumns.add(
        DataColumn(
          label: Checkbox(
            value: allCustomSelected,
            activeColor: primaryColor,
            checkColor: Colors.white,
            side: MaterialStateBorderSide.resolveWith(
              (states) =>
                  BorderSide(width: 2.0, color: textColor.withOpacity(0.6)),
            ),
            onChanged: (bool? newValue) {
              setState(() {
                bool setTo = newValue ?? false;
                for (int i = 0; i < selectedList.length; i++) {
                  selectedList[i] = setTo;
                }
              });
            },
          ),
        ),
      );
    }

    // 2. Kolom Dessert (Header)
    initialColumns.add(
      DataColumn(
        label: Text('Dessert (100g serving)',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        onSort: onSort != null
            ? (i, asc) => onSort(isCustomSelectable ? 1 : 0, asc)
            : null,
      ),
    );

    // 3. Kolom Nutrisi (Header)
    initialColumns.addAll([
      DataColumn(
        label: Text('Calories',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        onSort: onSort != null
            ? (i, asc) => onSort(isCustomSelectable ? 2 : 1, asc)
            : null,
      ),
      DataColumn(
        label: Text('Fat (g)',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        onSort: onSort != null
            ? (i, asc) => onSort(isCustomSelectable ? 3 : 2, asc)
            : null,
      ),
      DataColumn(
        label: Text('Carbs',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        onSort: onSort != null
            ? (i, asc) => onSort(isCustomSelectable ? 4 : 3, asc)
            : null,
      ),
      DataColumn(
        label: Text('Protein (g)',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        onSort: onSort != null
            ? (i, asc) => onSort(isCustomSelectable ? 5 : 4, asc)
            : null,
      ),
    ]);

    // 4. Kolom 'In Stock' (Header)
    if (includeInStockColumn) {
      initialColumns.add(
        DataColumn(
          label: Container(
            width: _inStockColumnWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('In Stock',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold)),
                Checkbox(
                  value: isAllInStock,
                  tristate: true,
                  activeColor: primaryColor,
                  checkColor: Colors.white,
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(
                        width: 2.0, color: textColor.withOpacity(0.6)),
                  ),
                  onChanged: (bool? newValue) {
                    setState(() {
                      bool setTo = newValue ?? false;
                      for (var item in data.sublist(0, selectedList!.length)) {
                        item.isInStock = setTo;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 5. Kolom 'Comments' (Responsif)
    if (showTabletOnlyColumn && screenWidth >= 768) {
      initialColumns.add(
        DataColumn(
            label: Container(
                width: 150,
                child: Text('Comments',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold)))),
      );
    }

    // 6. Kolom Comments (permanen) & Aksi
    if (includeActionsColumn) {
      initialColumns.add(DataColumn(
          label: Text('Comments',
              style:
                  TextStyle(color: textColor, fontWeight: FontWeight.bold))));
      initialColumns.add(
        // Kolom aksi tanpa label header
        const DataColumn(label: Text('')),
      );
    }

    // --- 2. Definisi DataRow dan Cells ---
    List<DataRow> rows = displayedData.asMap().entries.map((entry) {
      int index = entry.key;
      NutritionData item = entry.value;

      bool isSelected = (isCustomSelectable || withCheckboxes) &&
              selectedList != null &&
              index < selectedList.length
          ? selectedList[index]
          : false;

      List<DataCell> cells = [];

      // 1. Sel Checkbox kustom
      if (isCustomSelectable && selectedList != null) {
        cells.add(
          DataCell(
            Checkbox(
              value: selectedList[index],
              activeColor: primaryColor,
              checkColor: Colors.white,
              side: MaterialStateBorderSide.resolveWith(
                (states) =>
                    BorderSide(width: 2.0, color: textColor.withOpacity(0.6)),
              ),
              onChanged: (bool? newValue) {
                setState(() {
                  selectedList[index] = newValue ?? false;
                });
              },
            ),
          ),
        );
      }

      // 2. Data Cell Dessert
      cells.add(
        DataCell(
          Container(
            width: 150,
            child: Text(
              item.dessert,
              style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
            ),
          ),
        ),
      );

      // 3. Data Cells Nutrisi
      cells.addAll([
        DataCell(Container(
            width: _nutrientColWidth,
            child: Text(item.calories.toString(),
                style: TextStyle(color: textColor)))),
        DataCell(Container(
            width: _nutrientColWidth,
            child:
                Text(item.fat.toString(), style: TextStyle(color: textColor)))),
        DataCell(Container(
            width: _nutrientColWidth,
            child: Text(item.carbs.toString(),
                style: TextStyle(color: textColor)))),
        DataCell(Container(
            width: _nutrientColWidth,
            child: Text(item.protein.toString(),
                style: TextStyle(color: textColor)))),
      ]);

      // 4. Tambah sel 'In Stock'
      if (includeInStockColumn) {
        cells.add(
          DataCell(
            SizedBox(
              width: _inStockColumnWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                  value: item.isInStock,
                  activeColor: primaryColor,
                  checkColor: Colors.white,
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(
                        width: 2.0, color: textColor.withOpacity(0.6)),
                  ),
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      setState(() {
                        item.isInStock = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }

      // 5. Tambah sel 'Comments' (Responsif)
      if (showTabletOnlyColumn && screenWidth >= 768) {
        cells.add(DataCell(Container(
            width: 150,
            child: Text(item.comments, style: TextStyle(color: textColor)))));
      }

      // 6. Comments & Actions (Permanen)
      if (includeActionsColumn) {
        cells.add(
          DataCell(Text(item.comments, style: TextStyle(color: textColor))),
        );
        cells.add(
          DataCell(
            Row(
              children: [
                Icon(Icons.edit_outlined, size: 18, color: primaryColor),
                SizedBox(width: 8),
                Icon(Icons.delete_outline, size: 18, color: primaryColor),
              ],
            ),
          ),
        );
      }

      return DataRow(
        cells: cells,
        selected: withCheckboxes && isSelected,
        onSelectChanged: isCustomSelectable
            ? null
            : withCheckboxes
                ? (selected) {
                    if (selectedList != null && index < selectedList.length) {
                      setState(() {
                        selectedList[index] = selected ?? false;
                      });
                    }
                  }
                : null,
        // Warna latar belakang baris di mode Custom Selectable
        color: (isCustomSelectable || withCheckboxes) && isSelected
            ? MaterialStateProperty.all(primaryColor.withOpacity(0.1))
            : null,
      );
    }).toList();

    List<DataColumn> finalColumns = initialColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nutrition',
                  style: TextStyle(fontSize: 18, color: textColor)),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.sort, color: textColor),
                      onPressed: () {}),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: textColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: sortColumnIndex,
            sortAscending: sortAscending,
            border: TableBorder(
              horizontalInside: BorderSide(
                color: dividerColor,
                width: 1.0,
              ),
              bottom: isPaginationTable
                  ? BorderSide.none
                  : BorderSide(color: dividerColor, width: 1.0),
            ),
            headingRowColor: MaterialStateProperty.all(headerColor),
            dataRowMinHeight: 48,
            dataRowMaxHeight: 48,
            columns: finalColumns,
            rows: rows,
            showCheckboxColumn: !isCustomSelectable && withCheckboxes,
            dividerThickness: 0.0,
          ),
        ),
      ],
    );
  }

  // --- WIDGET BARU: Card with Title and Actions ---
  Widget _buildCardWithTitleAndActions({
    required List<NutritionData> data,
    required List<bool> selectedList,
    required Color cardColor,
    required Color textColor,
    required Color dividerColor,
    required Color primaryColor,
  }) {
    return Card(
      elevation: 2.0,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildNutritionTable(
          data: data,
          withCheckboxes: true,
          showTitle: true,
          selectedList: selectedList,
          textColor: textColor,
          dividerColor: dividerColor,
          headerColor: cardColor, // Header mengikuti warna card
          primaryColor: primaryColor,
        ),
      ),
    );
  }

  // --- WIDGET BARU: Alternate Header Table ---
  Widget _buildAlternateHeaderTable({
    required List<NutritionData> data,
    required List<bool> selectedList,
    required Color textColor,
    required Color dividerColor,
    required Color headerColor,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Add', style: TextStyle(color: primaryColor)),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Remove',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
            IconButton(
                icon: Icon(Icons.more_vert, color: textColor),
                onPressed: () {}),
          ],
        ),
        _buildNutritionTable(
          data: data,
          isCustomSelectable: true,
          selectedList: selectedList,
          includeActionsColumn: true,
          textColor: textColor,
          dividerColor: dividerColor,
          headerColor: headerColor,
          primaryColor: primaryColor,
        ),
      ],
    );
  }

  // WIDGET: Tablet-Only Table
  Widget _buildTabletOnlyTable({
    required List<NutritionData> data,
    required bool isCustomSelectable,
    required List<bool> selectedList,
    required Color textColor,
    required Color dividerColor,
    required Color headerColor,
    required Color primaryColor,
  }) {
    return _buildNutritionTable(
      data: data,
      withCheckboxes: false,
      isCustomSelectable: isCustomSelectable,
      selectedList: selectedList,
      showTitle: false,
      includeInStockColumn: false,
      showTabletOnlyColumn: true,
      textColor: textColor,
      dividerColor: dividerColor,
      headerColor: headerColor,
      primaryColor: primaryColor,
    );
  }

  // WIDGET: Selectable Table
  Widget _buildSelectableTable({
    required List<NutritionData> data,
    required bool isCustomSelectable,
    required List<bool> selectedList,
    required Color textColor,
    required Color dividerColor,
    required Color headerColor,
    required Color primaryColor,
  }) {
    return _buildNutritionTable(
      data: data,
      withCheckboxes: false,
      isCustomSelectable: isCustomSelectable,
      selectedList: selectedList,
      showTitle: false,
      includeInStockColumn: true,
      textColor: textColor,
      dividerColor: dividerColor,
      headerColor: headerColor,
      primaryColor: primaryColor,
    );
  }

  // WIDGET: Table di dalam Card (Plain)
  Widget _buildNutritionTableInCard({
    required bool withCheckboxes,
    required List<NutritionData> data,
    required List<bool> selectedList,
    required Color cardColor,
    required Color textColor,
    required Color dividerColor,
    required Color primaryColor,
  }) {
    return Card(
      elevation: 2.0,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildNutritionTable(
          data: data,
          withCheckboxes: withCheckboxes,
          selectedList: selectedList,
          showTitle: false,
          isPaginationTable: false,
          textColor: textColor,
          dividerColor: dividerColor,
          headerColor: cardColor, // Header mengikuti warna card
          primaryColor: primaryColor,
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // WIDGET CUSTOM UNTUK FIXED COLUMN (TETAP)
  // -------------------------------------------------------------------

  Widget _buildCustomFixedColumnTable({
    required List<NutritionData> data,
    required Color textColor,
    required Color dividerColor,
    required Color footerColor,
    required Color subTextColor,
  }) {
    int maxRows = (_rowsPerPage == 100) ? data.length : _rowsPerPage;
    List<NutritionData> displayedData = data.take(maxRows).toList();

    int displayLength = (_rowsPerPage == 100)
        ? data.length
        : (maxRows > data.length ? data.length : maxRows);

    String rangeText = '1-$displayLength of ${data.length}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomTableHeader(textColor),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFixedColumn(displayedData, textColor, dividerColor),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildScrollableColumns(
                      displayedData, textColor, dividerColor),
                ),
              ),
            ],
          ),
        ),
        _buildPaginationFooter(
            rangeText, footerColor, subTextColor, textColor, dividerColor),
      ],
    );
  }

  Widget _buildCustomTableHeader(Color textColor) {
    return Row(
      children: [
        Container(
          width: _fixedColumnWidth,
          height: _dataCellHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Dessert (100g serving)',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHeaderCell('Calories', 80.0, textColor),
                _buildHeaderCell('Fat (g)', 70.0, textColor),
                _buildHeaderCell('Carbs', 80.0, textColor),
                _buildHeaderCell('Protein (g)', 100.0, textColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text, double width, Color textColor) {
    return Container(
      width: width,
      height: _dataCellHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
      ),
    );
  }

  Widget _buildFixedColumn(
      List<NutritionData> data, Color textColor, Color dividerColor) {
    return Column(
      children: data.map((item) {
        return Container(
          width: _fixedColumnWidth,
          height: _dataCellHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          child: Text(
            item.dessert,
            style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScrollableColumns(
      List<NutritionData> data, Color textColor, Color dividerColor) {
    return Column(
      children: data.map((item) {
        return Container(
          height: _dataCellHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: dividerColor, width: 1.0),
            ),
          ),
          child: Row(
            children: [
              _buildDataCell(item.calories.toString(), 80.0, textColor),
              _buildDataCell(item.fat.toString(), 70.0, textColor),
              _buildDataCell(item.carbs.toString(), 80.0, textColor),
              _buildDataCell(item.protein.toString(), 100.0, textColor),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDataCell(String text, double width, Color textColor) {
    return Container(
      width: width,
      height: _dataCellHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  Widget _buildPaginationFooter(
    String rangeText,
    Color footerColor,
    Color subTextColor,
    Color textColor,
    Color dividerColor,
  ) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: footerColor,
        border: Border(
          top: BorderSide(color: dividerColor, width: 1.0),
          bottom: BorderSide(color: dividerColor, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Rows per page:',
            style: TextStyle(color: subTextColor, fontSize: 13),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 30,
            width: 75,
            child: DropdownButtonFormField<int>(
              dropdownColor: footerColor,
              value: _rowsPerPage,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: dividerColor),
                ),
              ),
              items: _availableRowsPerPage.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value == 100 ? 'All' : value.toString(),
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _rowsPerPage = newValue;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            rangeText,
            style: TextStyle(color: subTextColor, fontSize: 13),
          ),
          IconButton(
            icon: Icon(Icons.chevron_left, color: subTextColor),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: textColor),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // --- Admin Table With Filters ---
  Widget _buildAdminTableWithFilters(
      Color textColor, Color dividerColor, Color primaryColor) {
    List<DataColumn> columns = [
      _buildFilterColumn('ID',
          textColor: textColor, primaryColor: primaryColor),
      _buildFilterColumn('Name',
          textColor: textColor, primaryColor: primaryColor),
      _buildFilterColumn('Email',
          textColor: textColor, primaryColor: primaryColor),
      _buildFilterColumn('Gender',
          isDropdown: true, textColor: textColor, primaryColor: primaryColor),
    ];

    List<DataRow> rows = [
      _buildAdminDataRow('1', 'John Doe', 'john@doe.com', 'Male', textColor),
      _buildAdminDataRow('2', 'Jane Doe', 'jane@doe.com', 'Female', textColor),
      _buildAdminDataRow(
          '3', 'Vladimir Khar...', 'vladimir@google.com', 'Male', textColor),
      _buildAdminDataRow(
          '4', 'Jennifer Doe', 'jennifer@doe.com', 'Female', textColor),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        border: TableBorder(
          horizontalInside: BorderSide(color: dividerColor, width: 1.0),
          bottom: BorderSide(color: dividerColor, width: 1.0),
        ),
        headingRowHeight: 80,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 48,
        columns: columns,
        rows: rows,
        dividerThickness: 0.0,
      ),
    );
  }

  DataColumn _buildFilterColumn(
    String label, {
    bool numeric = false,
    bool isDropdown = false,
    required Color textColor,
    required Color primaryColor,
  }) {
    return DataColumn(
      label: Container(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            if (!isDropdown)
              SizedBox(
                width: 100,
                child: TextField(
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Filter',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 0,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
              ),
            if (isDropdown)
              SizedBox(
                width: 100,
                height: 24,
                child: DropdownButtonFormField<String>(
                  dropdownColor:
                      Provider.of<ThemeProvider>(context).themeMode ==
                              ThemeMode.dark
                          ? Provider.of<ThemeProvider>(context).cardColor
                          : Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  value: null,
                  hint: Text('Filter',
                      style: TextStyle(
                          fontSize: 14, color: textColor.withOpacity(0.5))),
                  items: const ['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: textColor)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
              ),
          ],
        ),
      ),
      numeric: numeric,
    );
  }

  DataRow _buildAdminDataRow(
    String id,
    String name,
    String email,
    String gender,
    Color textColor,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: TextStyle(color: textColor))),
        DataCell(Text(name, style: TextStyle(color: textColor))),
        DataCell(Text(email, style: TextStyle(color: textColor))),
        DataCell(Text(gender, style: TextStyle(color: textColor))),
      ],
    );
  }
}
