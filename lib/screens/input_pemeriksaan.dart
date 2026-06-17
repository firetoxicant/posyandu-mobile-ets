import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/balita.dart';
import '../providers/pemeriksaan_provider.dart';
import '../providers/user_provider.dart';

class InputPemeriksaanScreen extends StatefulWidget {
  final BalitaModel balita;

  const InputPemeriksaanScreen({super.key, required this.balita});

  @override
  State<InputPemeriksaanScreen> createState() => _InputPemeriksaanScreenState();
}

class _InputPemeriksaanScreenState extends State<InputPemeriksaanScreen> {
  final _beratCtrl = TextEditingController();
  final _tinggiCtrl = TextEditingController();
  final _lingkarCtrl = TextEditingController();
  final _catatanCtrl = TextEditingController();

  // State untuk checkbox
  bool _vitamin = false;
  bool _imunisasiDasar = false;
  bool _imunisasiLanjut = false;

  // State untuk dropdown
  String _statusKesehatan = 'baik';
  final List<String> _opsiKesehatan = ['baik', 'kurang baik', 'tidak baik'];

  void _simpanData() async {
    // Validasi input angka wajib
    if (_beratCtrl.text.isEmpty || _tinggiCtrl.text.isEmpty || _lingkarCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berat, Tinggi, dan Lingkar Kepala wajib diisi!')),
      );
      return;
    }

    double berat = double.tryParse(_beratCtrl.text.replaceAll(',', '.')) ?? 0;
    double tinggi = double.tryParse(_tinggiCtrl.text.replaceAll(',', '.')) ?? 0;
    double lingkar = double.tryParse(_lingkarCtrl.text.replaceAll(',', '.')) ?? 0;

    // Ambil Kredensial Kader
    final kader = context.read<UserProvider>().currentUser;
    if (kader == null) return;

    bool sukses = await context.read<PemeriksaanProvider>().tambahPemeriksaan(
      balitaId: widget.balita.id,
      kaderId: kader.id,
      poskoId: kader.poskoId ?? '',
      beratBadan: berat,
      tinggiBadan: tinggi,
      lingkarKepala: lingkar,
      pemberianVitamin: _vitamin,
      imunisasiDasar: _imunisasiDasar,
      imunisasiLanjut: _imunisasiLanjut,
      statusKesehatan: _statusKesehatan,
      catatan: _catatanCtrl.text.trim().isEmpty ? null : _catatanCtrl.text.trim(),
    );

    if (!mounted) return;

    if (sukses) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pemeriksaan berhasil disimpan'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Pemeriksaan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Anak: ${widget.balita.namaLengkap}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              // --- FORM UKURAN FISIK ---
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _beratCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Berat (kg)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _tinggiCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Tinggi (cm)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _lingkarCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Lingkar Kepala (cm)', border: OutlineInputBorder(), labelStyle: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- FORM PELAYANAN TAMBAHAN (CHECKBOX) ---
              const Text('Pelayanan Tambahan:', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('Pemberian Vitamin'),
                value: _vitamin,
                onChanged: (val) => setState(() => _vitamin = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Imunisasi Dasar'),
                value: _imunisasiDasar,
                onChanged: (val) => setState(() => _imunisasiDasar = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Imunisasi Lanjut'),
                value: _imunisasiLanjut,
                onChanged: (val) => setState(() => _imunisasiLanjut = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),

              // --- FORM STATUS KESEHATAN (DROPDOWN) ---
              DropdownButtonFormField<String>(
                value: _statusKesehatan,
                decoration: const InputDecoration(labelText: 'Status Kesehatan Balita', border: OutlineInputBorder()),
                items: _opsiKesehatan.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status.toUpperCase()));
                }).toList(),
                onChanged: (val) => setState(() => _statusKesehatan = val!),
              ),
              const SizedBox(height: 16),
              
              // --- FORM CATATAN ---
              TextField(
                controller: _catatanCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Saran / Catatan Kader (Opsional)',
                  border: OutlineInputBorder(),
                  hintText: 'Misal: Perbanyak makan sayur...',
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