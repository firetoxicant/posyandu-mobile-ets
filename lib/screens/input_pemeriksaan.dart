import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/balita.dart';
import '../providers/pemeriksaan_provider.dart';

class InputPemeriksaanScreen extends StatefulWidget {
  final BalitaModel balita;

  const InputPemeriksaanScreen({super.key, required this.balita});

  @override
  State<InputPemeriksaanScreen> createState() => _InputPemeriksaanScreenState();
}

class _InputPemeriksaanScreenState extends State<InputPemeriksaanScreen> {
  final _beratCtrl = TextEditingController();
  final _tinggiCtrl = TextEditingController();
  final _catatanCtrl = TextEditingController();

  void _simpanData() async {
    // Validasi agar tidak kosong
    if (_beratCtrl.text.isEmpty || _tinggiCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berat dan Tinggi badan wajib diisi!')),
      );
      return;
    }

    // Ubah text menjadi angka (double)
    double berat = double.tryParse(_beratCtrl.text.replaceAll(',', '.')) ?? 0;
    double tinggi = double.tryParse(_tinggiCtrl.text.replaceAll(',', '.')) ?? 0;

    bool sukses = await context.read<PemeriksaanProvider>().tambahPemeriksaan(
      balitaId: widget.balita.id,
      beratBadan: berat,
      tinggiBadan: tinggi,
      catatan: _catatanCtrl.text.trim(),
    );

    if (!mounted) return;

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pemeriksaan berhasil disimpan'), backgroundColor: Colors.green));
      Navigator.pop(context); // Kembali ke halaman riwayat
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Pemeriksaan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Anak: ${widget.balita.namaLengkap}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              TextField(
                controller: _beratCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Berat Badan (kg)',
                  border: OutlineInputBorder(),
                  suffixText: 'kg',
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _tinggiCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tinggi Badan (cm)',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _catatanCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan / Keluhan (Opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF4FC3F7),
                  foregroundColor: Colors.white,
                ),
                onPressed: _simpanData,
                child: const Text('SIMPAN PEMERIKSAAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}