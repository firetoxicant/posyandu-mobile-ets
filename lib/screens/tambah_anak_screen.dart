import 'package:flutter/material.dart';

class TambahAnakScreen extends StatefulWidget {
  @override
  _TambahAnakScreenState createState() => _TambahAnakScreenState();
}

class _TambahAnakScreenState extends State<TambahAnakScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Anak Baru'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF21CBF3)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.child_care, size: 64, color: Colors.white),
                      SizedBox(height: 12),
                      Text('Registrasi Anak Baru', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Form Fields
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap Anak',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    if (value.length < 3) {
                      return 'Nama minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _umurController,
                  decoration: InputDecoration(
                    labelText: 'Umur (bulan)',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Umur tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) > 60) {
                      return 'Umur harus 1-60 bulan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Tombol Submit
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Daftarkan Anak', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Simulasi submit berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_namaController.text berhasil didaftarkan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      
      // Kembali ke home setelah 1.5 detik
      Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    super.dispose();
  }
}