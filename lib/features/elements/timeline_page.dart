import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // Sesuaikan path ini dengan lokasi file ThemeProvider Anda

// =================================================================
// KELAS UTAMA: TimelinePage (Daftar Menu)
// =================================================================
class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Definisi Warna Dinamis
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final cardColor = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white70 : Colors.grey.shade400;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE0E0E0);
    final appBarBg = isDark
        ? themeProvider.cardColor
        : Colors.white; // AppBar beda warna dikit di dark mode

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: Text(
          'Timeline',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarBg,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container untuk menampung List Menu
          Container(
            color: cardColor,
            child: Column(
              children: [
                _buildTimelineItem(context, 'Vertical Timeline', textColor,
                    iconColor, dividerColor),
                _buildTimelineItem(context, 'Horizontal Timeline', textColor,
                    iconColor, dividerColor),
                _buildTimelineItem(context, 'Calendar Timeline', textColor,
                    iconColor, dividerColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, Color textColor,
      Color iconColor, Color dividerColor) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          trailing: Icon(
            Icons.chevron_right,
            color: iconColor,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          onTap: () {
            if (title == 'Vertical Timeline') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VerticalTimelinePage(),
                ),
              );
            } else if (title == 'Horizontal Timeline') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HorizontalTimelinePage(),
                ),
              );
            } else if (title == 'Calendar Timeline') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarTimelinePage(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Navigasi ke: $title')));
            }
          },
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: dividerColor,
          indent: 16,
        ),
      ],
    );
  }
}

// =================================================================
// KELAS KALENDER: CalendarTimelinePage
// =================================================================

class CalendarTimelinePage extends StatelessWidget {
  const CalendarTimelinePage({super.key});

  // Data Tugas
  final Map<String, List<Map<String, String>>> _calendarData = const {
    '20': [
      {'time': '10:00', 'task': 'Task 1'},
      {'time': '13:00', 'task': 'Task 2'},
      {'time': '8:00', 'task': 'Task 3'},
      {'time': '2:00', 'task': 'Task 4'},
    ],
    '21': [
      {'time': '6:00', 'task': 'Task 1'},
      {'time': '1:00', 'task': 'Task 2'},
      {'time': '1:00', 'task': 'Task 3'},
      {'time': '7:00', 'task': 'Task 4'},
    ],
    '22': [
      {'time': '23:00', 'task': 'Task 1'},
      {'time': '15:00', 'task': 'Task 2'},
      {'time': '0:00', 'task': 'Task 3'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Warna Dinamis
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBg = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final headerColor =
        isDark ? themeProvider.primaryColor : Colors.black; // Tahun/Bulan
    final lineColor = isDark ? Colors.white24 : const Color(0xFFE0E0E0);
    final dateColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: Text('Horizontal Timeline Calendar',
            style: TextStyle(color: textColor)),
        backgroundColor: appBarBg,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Tahun dan Bulan
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2016',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: headerColor,
                  ),
                ),
                Text(
                  'December',
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // Mapping data hari ke widget kolom
                  children: _calendarData.entries.map((entry) {
                    return _buildDayColumn(entry.key, entry.value, lineColor,
                        dateColor, textColor);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String day, List<Map<String, String>> tasks,
      Color lineColor, Color dateColor, Color textColor) {
    final mutableTasks = List<Map<String, String>>.from(tasks);
    mutableTasks.sort((a, b) => a['time']!.compareTo(b['time']!));

    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: lineColor, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header Tanggal
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: lineColor, width: 1.0)),
            ),
            width: double.infinity,
            child: Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: dateColor,
              ),
            ),
          ),

          // Daftar Tugas
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mutableTasks.map((task) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['time']!,
                          style: TextStyle(
                              fontSize: 14, color: textColor.withOpacity(0.7)),
                        ),
                        Text(
                          task['task']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// KELAS HORIZONTAL: HorizontalTimelinePage
// =================================================================

class HorizontalTimelinePage extends StatelessWidget {
  const HorizontalTimelinePage({super.key});

  final Map<String, List<Map<String, dynamic>>> _timelineData = const {
    '21 DEC': [
      {
        'time': '12:56',
        'title': 'Title 1',
        'subtitle': 'Subtitle 1',
        'body': 'Lorem ipsum dolor sit amet, consectetur\nadipisicing elit',
      },
      {
        'time': '13:15',
        'title': 'Title 2',
        'subtitle': 'Subtitle 2',
        'body': 'Lorem ipsum dolor sit amet, consectetur\nadipisicing elit',
      },
      {'time': '14:45', 'action': 'Do something'},
      {'time': '16:11', 'action': 'Do something else'},
    ],
    '22 DEC': [
      {'plain': 'Plain text goes here'},
    ],
    '23 DEC': [
      {
        'type': 'Card',
        'header': 'Card',
        'content': 'Card Content',
        'footer': 'Card Footer',
      },
      {'type': 'Card', 'content': 'Another Card Content'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Warna Dinamis
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBg = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.black54;
    final lineColor = isDark ? Colors.white24 : const Color(0xFFE0E0E0);
    // Bubble color: di light mode abu-abu muda, di dark mode pake cardColor
    final bubbleColor =
        isDark ? themeProvider.cardColor : const Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: Text('Horizontal Timeline', style: TextStyle(color: textColor)),
        backgroundColor: appBarBg,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _timelineData.entries.map((entry) {
              return _buildDayColumn(entry.key, entry.value, lineColor,
                  textColor, secondaryTextColor, bubbleColor);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDayColumn(
      String date,
      List<Map<String, dynamic>> items,
      Color lineColor,
      Color textColor,
      Color secondaryTextColor,
      Color bubbleColor) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: lineColor, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12.0),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: _buildItemContent(
                  item, textColor, secondaryTextColor, bubbleColor),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildItemContent(Map<String, dynamic> item, Color textColor,
      Color secondaryTextColor, Color bubbleColor) {
    if (item.containsKey('time')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['time'] as String,
            style: TextStyle(fontSize: 12, color: secondaryTextColor),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['title'] != null)
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                if (item['subtitle'] != null)
                  Text(
                    item['subtitle'] as String,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                if (item['body'] != null)
                  Text(
                    item['body'] as String,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                if (item['action'] != null)
                  Text(
                    item['action'] as String,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
              ],
            ),
          ),
        ],
      );
    } else if (item.containsKey('plain')) {
      return Text(
        item['plain'] as String,
        style: TextStyle(fontSize: 14, color: textColor),
      );
    } else if (item.containsKey('type') && item['type'] == 'Card') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item['header'] != null)
            Text(
              item['header'] as String,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          Container(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['content'] != null)
                  Text(
                    item['content'] as String,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                if (item['footer'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      item['footer'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }
    return Container();
  }
}

// =================================================================
// KELAS KONTEN: VerticalTimelinePage
// =================================================================

class VerticalTimelinePage extends StatelessWidget {
  const VerticalTimelinePage({super.key});

  final double _dotRadius = 5.0;

  // --- Data Timeline (Sama seperti sebelumnya) ---
  final List<Map<String, String>> _defaultTimelineData = const [
    {'date': '21 DEC', 'content': 'Some text goes here'},
    {'date': '22 DEC', 'content': 'Another text goes here'},
    {'date': '23 DEC', 'content': 'Lorem ipsum dolor sit amet...'},
    {'date': '24 DEC', 'content': 'One more text here'},
  ];

  final List<Map<String, String>> _sideBySideTimelineData = const [
    {'date': '21 DEC', 'content': 'Some text goes here'},
    {'date': '22 DEC', 'content': 'Another text goes here'},
    {'date': '23 DEC', 'content': 'Just plain text'},
    {'date': '24 DEC', 'content': 'One more text here'},
  ];

  final List<Map<String, dynamic>> _forcedSidesTimelineData = const [
    {'date': '21 DEC', 'content': 'Some text goes here', 'side': 'right'},
    {'date': '22 DEC', 'content': 'Another text goes here', 'side': 'right'},
    {'date': '23 DEC', 'content': 'Just plain text', 'side': 'left'},
    {'date': '24 DEC', 'content': 'One more text here', 'side': 'left'},
  ];

  final List<Map<String, dynamic>> _richContentTimelineData = const [
    {
      'date': '21 DEC',
      'items': [
        {
          'time': '12:56',
          'title': 'Item Title',
          'subtitle': 'Item Subtitle',
          'body': 'Lorem ipsum...'
        },
        {
          'time': '15:07',
          'title': 'Item Title',
          'subtitle': 'Item Subtitle',
          'body': 'Lorem ipsum...'
        },
      ],
    },
    {
      'date': '22 DEC',
      'items': [
        {
          'time': '12:56',
          'title': 'Item Title',
          'subtitle': 'Item Subtitle',
          'body': 'Lorem ipsum...'
        },
        {
          'time': '15:07',
          'title': 'Item Title',
          'subtitle': 'Item Subtitle',
          'body': 'Lorem ipsum...'
        },
      ],
    },
    {
      'date': '23 DEC',
      'items': [
        {'plain': 'Plain text goes here'},
        {
          'header': 'Card Header',
          'content': 'Card Content',
          'footer': 'Card Footer'
        },
        {'content': 'Another Card Content'},
        {'item': 'Item 1'},
        {'item': 'Item 2'},
        {'item': 'Item 3'},
      ],
    },
  ];

  final List<Map<String, String>> _insideContentBlockData = const [
    {'date': '21 DEC', 'content': 'Some text goes here'},
    {'date': '22 DEC', 'content': 'Another text goes here'},
    {'date': '23 DEC', 'content': 'Lorem ipsum dolor sit amet...'},
    {'date': '24 DEC', 'content': 'One more text here'},
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    // 2. Definisi Warna Dinamis
    final scaffoldColor = isDark
        ? themeProvider.scaffoldColorDark
        : themeProvider.scaffoldColorLight;
    final appBarBg = isDark ? themeProvider.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.black54;
    final lineColor = isDark ? Colors.white24 : const Color(0xFFE0E0E0);
    final dotColor = isDark ? Colors.white54 : const Color(0xFFE0E0E0);
    // Warna untuk bubble/card content
    final contentBgColor = isDark ? themeProvider.cardColor : Colors.white;
    // Warna untuk border card (sedikit transparan di dark mode)
    final borderColor =
        isDark ? Colors.white12 : const Color(0xFFE0E0E0).withOpacity(0.5);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: Text('Vertical Timeline', style: TextStyle(color: textColor)),
        backgroundColor: appBarBg,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('Default', textColor),
            _buildTimelineList(
                items: _defaultTimelineData,
                type: 'default',
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                lineColor: lineColor,
                dotColor: dotColor,
                contentBgColor: contentBgColor,
                borderColor: borderColor),

            const SizedBox(height: 30),

            _buildSectionTitle('Side By Side', textColor),
            _buildTimelineList(
                items: _sideBySideTimelineData,
                type: 'side_by_side',
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                lineColor: lineColor,
                dotColor: dotColor,
                contentBgColor: contentBgColor,
                borderColor: borderColor),

            const SizedBox(height: 30),

            _buildSectionTitle('Only Tablet Side By Side', textColor),
            _buildTimelineList(
                items: _sideBySideTimelineData,
                type: 'default',
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                lineColor: lineColor,
                dotColor: dotColor,
                contentBgColor: contentBgColor,
                borderColor: borderColor),

            const SizedBox(height: 30),

            _buildSectionTitle('Forced Sides', textColor),
            _buildTimelineList(
                items: _forcedSidesTimelineData,
                type: 'forced_sides',
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                lineColor: lineColor,
                dotColor: dotColor,
                contentBgColor: contentBgColor,
                borderColor: borderColor),

            const SizedBox(height: 30),

            // --- Rich Content Timeline ---
            _buildSectionTitle('Rich Content', textColor),
            _buildRichContentTimeline(textColor, secondaryTextColor, lineColor,
                dotColor, contentBgColor, borderColor),

            const SizedBox(height: 30),

            // --- Inside Content Block ---
            _buildInsideContentBlock(textColor, secondaryTextColor, lineColor,
                dotColor, contentBgColor, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildTimelineList({
    required List<Map<String, dynamic>> items,
    required String type,
    required Color textColor,
    required Color secondaryTextColor,
    required Color lineColor,
    required Color dotColor,
    required Color contentBgColor,
    required Color borderColor,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (type == 'default') {
          return _buildDefaultItem(
              items[index],
              index == items.length - 1,
              textColor,
              secondaryTextColor,
              lineColor,
              dotColor,
              contentBgColor,
              borderColor);
        } else if (type == 'side_by_side') {
          return _buildSideBySideItem(
              items[index] as Map<String, String>,
              index,
              textColor,
              secondaryTextColor,
              lineColor,
              dotColor,
              contentBgColor,
              borderColor);
        } else if (type == 'forced_sides') {
          return _buildForcedSidesItem(
              items[index],
              index,
              textColor,
              secondaryTextColor,
              lineColor,
              dotColor,
              contentBgColor,
              borderColor);
        }
        return Container();
      },
    );
  }

  // --- Widget Rich Content Timeline ---
  Widget _buildRichContentTimeline(
      Color textColor,
      Color secondaryTextColor,
      Color lineColor,
      Color dotColor,
      Color contentBgColor,
      Color borderColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _richContentTimelineData.length,
      itemBuilder: (context, index) {
        final dateEntry = _richContentTimelineData[index];
        final isLastDate = index == _richContentTimelineData.length - 1;
        final List items = dateEntry['items'] as List;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Kolom Kiri
              SizedBox(
                width: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      dateEntry['date'] as String,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: _dotRadius * 2,
                      height: _dotRadius * 2,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: dotColor),
                    ),
                    if (!isLastDate)
                      Expanded(child: Container(width: 2.0, color: lineColor)),
                  ],
                ),
              ),
              // Kolom Tengah
              Container(
                width: 1.0,
                color: lineColor,
                margin: const EdgeInsets.only(right: 12.0),
              ),
              // Kolom Kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map<Widget>((item) {
                    Widget contentWidget;
                    final itemMap = item as Map<String, dynamic>;

                    if (itemMap.containsKey('time')) {
                      contentWidget = _buildRichContentItem(itemMap, textColor,
                          secondaryTextColor, contentBgColor, borderColor);
                    } else if (itemMap.containsKey('header') ||
                        itemMap.containsKey('content')) {
                      contentWidget = _buildCardContentItem(
                          itemMap, textColor, secondaryTextColor);
                    } else if (itemMap.containsKey('item')) {
                      contentWidget =
                          _buildListItem(itemMap['item'] as String, textColor);
                    } else if (itemMap.containsKey('plain')) {
                      contentWidget = Text(itemMap['plain'] as String,
                          style: TextStyle(color: textColor));
                    } else {
                      contentWidget = Container();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: contentWidget,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRichContentItem(Map<String, dynamic> item, Color textColor,
      Color secondaryTextColor, Color contentBgColor, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item['time'] != null)
          Text(
            item['time'] as String,
            style: TextStyle(fontSize: 12, color: secondaryTextColor),
          ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: contentBgColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item['title'] != null)
                Text(
                  item['title'] as String,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor),
                ),
              if (item['subtitle'] != null)
                Text(
                  item['subtitle'] as String,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
              if (item['body'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    item['body'] as String,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardContentItem(
      Map<String, dynamic> item, Color textColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item['header'] != null)
          Text(
            item['header'] as String,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
          ),
        const SizedBox(height: 4),
        if (item['content'] != null)
          Text(item['content'] as String,
              style: TextStyle(fontSize: 14, color: textColor)),
        const SizedBox(height: 4),
        if (item['footer'] != null)
          Text(
            item['footer'] as String,
            style: TextStyle(fontSize: 12, color: secondaryTextColor),
          ),
      ],
    );
  }

  Widget _buildListItem(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: textColor)),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _buildDefaultItem(
      Map<String, dynamic> item,
      bool isLast,
      Color textColor,
      Color secondaryTextColor,
      Color lineColor,
      Color dotColor,
      Color contentBgColor,
      Color borderColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                item['date']! as String,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        _buildTimelineConnector(
            isLast: isLast,
            type: 'default',
            lineColor: lineColor,
            dotColor: dotColor),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _buildContentBubble(item['content']! as String, textColor,
                contentBgColor, borderColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSideBySideItem(
      Map<String, String> item,
      int index,
      Color textColor,
      Color secondaryTextColor,
      Color lineColor,
      Color dotColor,
      Color contentBgColor,
      Color borderColor) {
    bool isRightSide = index % 2 == 0;
    bool isLast = index == _sideBySideTimelineData.length - 1;

    Widget contentBubble = Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: _buildContentBubble(
          item['content']!, textColor, contentBgColor, borderColor),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: !isRightSide
              ? Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: contentBubble,
                  ),
                )
              : Container(),
        ),
        Column(
          children: <Widget>[
            _buildTimelineConnector(
                isLast: isLast,
                type: 'side_by_side',
                lineColor: lineColor,
                dotColor: dotColor),
            Text(
              item['date']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: secondaryTextColor),
            ),
            if (!isLast) Container(height: 25.0, width: 2.0, color: lineColor),
            if (isLast) const SizedBox(height: 25),
          ],
        ),
        Expanded(
          child: isRightSide
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: contentBubble,
                )
              : Container(),
        ),
      ],
    );
  }

  Widget _buildForcedSidesItem(
      Map<String, dynamic> item,
      int index,
      Color textColor,
      Color secondaryTextColor,
      Color lineColor,
      Color dotColor,
      Color contentBgColor,
      Color borderColor) {
    bool isRightForced = item['side'] == 'right';
    bool isLast = index == _forcedSidesTimelineData.length - 1;

    Widget contentBubble = Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: _buildContentBubble(
          item['content']! as String, textColor, contentBgColor, borderColor),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: !isRightForced
              ? Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: contentBubble,
                  ),
                )
              : Container(),
        ),
        Column(
          children: <Widget>[
            _buildTimelineConnector(
                isLast: isLast,
                type: 'forced_sides_top',
                lineColor: lineColor,
                dotColor: dotColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                item['date']! as String,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
            ),
            _buildTimelineConnector(
              isLast: isLast,
              type: 'forced_sides_bottom',
              lineColor: lineColor,
              dotColor: dotColor,
            ),
          ],
        ),
        Expanded(
          child: isRightForced
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: contentBubble,
                )
              : Container(),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector(
      {required bool isLast,
      required String type,
      required Color lineColor,
      required Color dotColor}) {
    if (type == 'forced_sides_top') {
      return Column(
        children: [
          Container(height: 20.0, width: 2.0, color: lineColor),
          Container(
            width: _dotRadius * 2,
            height: _dotRadius * 2,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
        ],
      );
    }

    if (type == 'forced_sides_bottom') {
      return Column(
        children: [
          if (!isLast) Container(height: 20.0, width: 2.0, color: lineColor),
          if (isLast) const SizedBox(height: 20.0),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Container(
          width: _dotRadius * 2,
          height: _dotRadius * 2,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
        ),
        if (!isLast && type == 'default')
          Container(height: 50.0, width: 2.0, color: lineColor),
        if (!isLast && type == 'side_by_side')
          Container(height: 25.0, width: 2.0, color: lineColor),
        if (isLast && type == 'default') const SizedBox(height: 50.0),
      ],
    );
  }

  Widget _buildContentBubble(String content, Color textColor,
      Color contentBgColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: contentBgColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(content, style: TextStyle(fontSize: 14, color: textColor)),
    );
  }

  Widget _buildInsideContentBlock(
      Color textColor,
      Color secondaryTextColor,
      Color lineColor,
      Color dotColor,
      Color contentBgColor,
      Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Inside Content Block', textColor),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: contentBgColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: _buildTimelineListInsideContainer(
              textColor, secondaryTextColor, lineColor, dotColor),
        ),
      ],
    );
  }

  Widget _buildTimelineListInsideContainer(Color textColor,
      Color secondaryTextColor, Color lineColor, Color dotColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _insideContentBlockData.length,
      itemBuilder: (context, index) {
        final item = _insideContentBlockData[index];
        final isLast = index == _insideContentBlockData.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    item['date']!,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: secondaryTextColor),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: _dotRadius * 2,
                  height: _dotRadius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                if (!isLast)
                  Container(height: 50.0, width: 2.0, color: lineColor),
                if (isLast) const SizedBox(height: 50.0),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  item['content']!,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
