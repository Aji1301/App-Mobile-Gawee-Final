import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class SubmissionPage extends StatefulWidget {
  final Color primaryColor;
  final String jobId;

  const SubmissionPage({
    required this.primaryColor,
    required this.jobId,
    super.key
  });

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // Menggunakan parameter manual
    bool success = await ApiService.applyJobWithDetails(
      jobId: widget.jobId,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context); // Tutup BottomSheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Aplikasi Berhasil Dikirim!' : 'Gagal mengirim aplikasi.'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil data Tema saat ini
    final theme = Theme.of(context);
    // 2. Tentukan warna background (ikut tema scaffold)
    final backgroundColor = theme.scaffoldBackgroundColor;
    // 3. Tentukan warna handle bar (garis kecil di atas) agar kontras
    final handleColor = theme.brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[300];

    return Container(
      // ✅ UBAH: Jangan hardcode Colors.white, gunakan warna tema
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: 24, left: 24, right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Garis Handle di atas
          Container(
            width: 40, 
            height: 5, 
            decoration: BoxDecoration(
              color: handleColor, // ✅ UBAH: Warna dinamis
              borderRadius: BorderRadius.circular(10)
            )
          ),
          const SizedBox(height: 30),

          _buildTextField(context, label: 'User Name', controller: _nameController),
          const SizedBox(height: 20),
          _buildTextField(context, label: 'Email Address', keyboardType: TextInputType.emailAddress, controller: _emailController),
          const SizedBox(height: 20),
          _buildTextField(context, label: 'Phone number', keyboardType: TextInputType.phone, controller: _phoneController),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required String label, TextInputType keyboardType = TextInputType.text, required TextEditingController controller}) {
    final theme = Theme.of(context);
    
    // Tentukan warna border default (inactive) berdasarkan tema
    final borderColor = theme.brightness == Brightness.dark 
        ? Colors.grey.shade700 
        : const Color(0xFFEEEEEE);

    return TextField(
      controller: controller,
      // ✅ TAMBAH: Pastikan warna teks input mengikuti body text tema (Hitam di Light, Putih di Dark)
      style: theme.textTheme.bodyLarge, 
      decoration: InputDecoration(
        labelText: label,
        // ✅ UBAH: Label menggunakan hintColor tema (biasanya abu-abu yang pas untuk kedua mode)
        labelStyle: TextStyle(color: theme.hintColor),
        
        // Border saat tidak diklik
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        
        // Border saat diklik (Fokus)
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.primaryColor, width: 2),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}