import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class RegisterOrangtuaScreen extends StatefulWidget {
  const RegisterOrangtuaScreen({super.key});

  @override
  State<RegisterOrangtuaScreen> createState() => _RegisterOrangtuaScreenState();
}

class _RegisterOrangtuaScreenState extends State<RegisterOrangtuaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final bool _obscurePassword = true;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _daftar() async {
    // 1. Validasi input form
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    
    // 2. Ambil data dari TextField
    final nama = _namaCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    // 3. Panggil fungsi dari UserProvider (Otomatis role: 'orangtua')
    bool isSuccess = await provider.registerOrangTua(nama, email, password);

    if (!mounted) return;

    // 4. Tampilkan notifikasi berdasarkan hasil
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Kembali ke halaman login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran gagal. Pastikan email valid dan belum terdaftar.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil status loading dari provider untuk mencegah double-click
    final isLoading = context.watch<UserProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Konten Utama
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        'Buat Akun',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 40),

                      // Kolom Nama Lengkap
                      TextFormField(
                        controller: _namaCtrl,
                        decoration: InputDecoration(
                          hintText: 'Nama Lengkap',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        validator: (v) {
                          if (v!.trim().isEmpty) return 'Nama Lengkap tidak boleh kosong';
                          if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Kolom Email
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        validator: (v) {
                          if (v!.trim().isEmpty) return 'Email tidak boleh kosong';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Kolom Password
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        validator: (v) {
                          if (v!.trim().isEmpty) return 'Password tidak boleh kosong';
                          if (v.trim().length < 6) return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Tombol Register
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // Jika sedang loading, tombol tidak bisa ditekan
                          onPressed: isLoading ? null : _daftar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          child: isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'BUAT AKUN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 80),

                      // Link Kembali ke Login
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Sudah punya akun? Kembali',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}