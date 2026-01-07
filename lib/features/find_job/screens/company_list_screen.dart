import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import '../../recent_job/screens/recent_job_page.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  List<Map<String, dynamic>> _companies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  void _fetchCompanies() async {
    // Ambil semua data job
    final jobs = await ApiService.getCompanies();
    
    // Proses Manual: Kelompokkan berdasarkan nama perusahaan
    final Map<String, Map<String, dynamic>> grouped = {};
    
    for (var job in jobs) {
      final name = job['company_name'];
      if (!grouped.containsKey(name)) {
        grouped[name] = {
          'name': name,
          'location': job['location'],
          'count': 0
        };
      }
      grouped[name]!['count'] += 1;
    }

    if (mounted) {
      setState(() {
        _companies = grouped.values.toList();
        _isLoading = false;
      });
    }
  }

  // Helper Logo
  String _getLogoPath(String companyName) {
    if (companyName.contains('Cosax')) return 'assets/images/logo 4.png';
    if (companyName.contains('Google')) return 'assets/images/google_logo.png';
    return 'assets/images/logo 1.png'; // Default
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorPurpleText = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Company List", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar (Visual Saja)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)]),
              child: const TextField(
                decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Type Company Name", border: InputBorder.none),
              ),
            ),
          ),

          // List Companies
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator(color: colorPurpleText))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: _companies.length,
                  itemBuilder: (context, index) {
                    final company = _companies[index];
                    return _buildCompanyCard(context, company, colorPurpleText);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, Map<String, dynamic> company, Color colorPurpleText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        elevation: 1,
        child: InkWell(
          onTap: () {
            // Navigasi ke Recent Job yang difilter perusahaan ini
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => RecentJobScreen(companyName: company['name']))
            );
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey[200]!)),
                  child: Image.asset(_getLogoPath(company['name']), fit: BoxFit.contain),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorPurpleText)),
                      Text(company['location'], style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 6),
                      Text("${company['count']} Jobs Available", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}