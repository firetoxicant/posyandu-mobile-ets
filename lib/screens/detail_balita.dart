import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/balita.dart';
import '../providers/balita_provider.dart';
import '../providers/pemeriksaan_provider.dart'; 
import 'input_pemeriksaan.dart'; 

class DetailBalitaScreen extends StatefulWidget {
  final BalitaModel balita;
  final String role;

  const DetailBalitaScreen({super.key, required this.balita, required this.role});

  @override
  State<DetailBalitaScreen> createState() => _DetailBalitaScreenState();
}

class _DetailBalitaScreenState extends State<DetailBalitaScreen> {
  // Menyimpan data balita secara lokal agar UI bisa langsung direfresh setelah edit
  late BalitaModel _currentBalita;

  @override
  void initState() {
    super.initState();
    _currentBalita = widget.balita;
    
    // Tarik data riwayat pemeriksaan balita ini saat layar pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PemeriksaanProvider>().fetchRiwayatBalita(_currentBalita.id);
    });
  }

  void _tampilkanFormEdit(BuildContext context) {
    // Inisialisasi controller dengan data yang sudah ada
    final namaCtrl = TextEditingController(text: _currentBalita.namaLengkap);
    DateTime? selectedDate = _currentBalita.tanggalLahir;
    String jenisKelamin = _currentBalita.jenisKelamin;
    String? selectedOrangTuaId = _currentBalita.orangTuaId; 

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final listOrangTua = context.read<BalitaProvider>().listOrangTua;

            return AlertDialog(
              title: const Text('Edit Data Balita'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaCtrl, 
                      decoration: const InputDecoration(labelText: 'Nama Lengkap Anak')
                    ),
                    const SizedBox(height: 16),
                    
                    // Pemilih Tanggal Lahir
                    Row(
                      children: [
                        Expanded(
                          child: Text(selectedDate == null 
                            ? 'Pilih Tanggal Lahir' 
                            : 'Tgl Lahir: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month, color: Colors.blue),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2015),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setStateDialog(() => selectedDate = date);
                            }
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pemilih Jenis Kelamin
                    DropdownButtonFormField<String>(
                      value: jenisKelamin,
                      decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                      items: ['Laki-laki', 'Perempuan']
                          .toSet()
                          .map((jk) => DropdownMenuItem(value: jk, child: Text(jk)))
                          .toList(),
                      onChanged: (val) => setStateDialog(() => jenisKelamin = val!),
                    ),
                    const SizedBox(height: 8),

                    // Pemilih Orang Tua
                    DropdownButtonFormField<String>(
                      value: listOrangTua.any((o) => o.id == selectedOrangTuaId) ? selectedOrangTuaId : null,
                      decoration: const InputDecoration(labelText: 'Pilih Orang Tua'),
                      items: listOrangTua.map((ortu) => DropdownMenuItem(value: ortu.id, child: Text(ortu.namaLengkap))).toList(),
                      onChanged: (val) => setStateDialog(() => selectedOrangTuaId = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                ElevatedButton(
                  onPressed: () async {
                    if (namaCtrl.text.isNotEmpty && selectedDate != null && selectedOrangTuaId != null) {
                      
                      // 1. Buat object BalitaModel baru dengan data yang sudah di-edit
                      BalitaModel balitaUpdate = BalitaModel(
                        id: _currentBalita.id,
                        namaLengkap: namaCtrl.text.trim(),
                        tanggalLahir: selectedDate!,
                        jenisKelamin: jenisKelamin,
                        orangTuaId: selectedOrangTuaId!,
                        poskoId: _currentBalita.poskoId,
                      );

                      // 2. Panggil fungsi updateBalita 
                      bool sukses = await context.read<BalitaProvider>().updateBalita(
                        _currentBalita.id, 
                        balitaUpdate
                      );
                      
                      if (!context.mounted) return;
                      Navigator.pop(context); // Tutup dialog

                      if (sukses) {
                        // 3. Update state lokal agar UI langsung berubah
                        setState(() {
                          _currentBalita = balitaUpdate;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data berhasil diubah'), backgroundColor: Colors.green)
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal mengubah data'), backgroundColor: Colors.red)
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lengkapi form!'))
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan state dari PemeriksaanProvider
    final riwayatProvider = context.watch<PemeriksaanProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Balita'),
        actions: [
          if (widget.role == 'kader')
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Data',
            onPressed: () => _tampilkanFormEdit(context),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- KARTU INFORMASI BALITA ---
          Card(
            margin: const EdgeInsets.all(16.0),
            color: const Color(0xFFE1F5FE),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_currentBalita.namaLengkap, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Jenis Kelamin: ${_currentBalita.jenisKelamin}', style: const TextStyle(fontSize: 16)),
                  Text('Tgl Lahir: ${_currentBalita.tanggalLahir.day}/${_currentBalita.tanggalLahir.month}/${_currentBalita.tanggalLahir.year}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  if(widget.role == 'kader')
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4FC3F7), foregroundColor: Colors.white),
                    icon: const Icon(Icons.monitor_weight),
                    label: const Text('Mulai Pemeriksaan'),
                    onPressed: () async {
                      // await digunakan agar sistem menunggu form input ditutup
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InputPemeriksaanScreen(balita: _currentBalita)
                        ),
                      );

                      // Setelah form input tertutup, tarik riwayat terbaru!
                      if (!context.mounted) return;
                      context.read<PemeriksaanProvider>().fetchRiwayatBalita(_currentBalita.id);
                    },
                  )
                ],
              ),
            ),
          ),

          // --- RIWAYAT PEMERIKSAAN ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Riwayat Pemeriksaan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          
          Expanded(
            child: riwayatProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : riwayatProvider.listPemeriksaan.isEmpty
                ? const Center(child: Text('Belum ada riwayat pemeriksaan.'))
                : ListView.builder(
                    itemCount: riwayatProvider.listPemeriksaan.length,
                    itemBuilder: (context, index) {
                      final periksa = riwayatProvider.listPemeriksaan[index];
                      return ListTile(
                        leading: const Icon(Icons.history, color: Colors.blue),
                        title: Text('Tanggal: ${periksa.tanggal.day}/${periksa.tanggal.month}/${periksa.tanggal.year}'),
                        subtitle: Text('Berat: ${periksa.beratBadan} kg | Tinggi: ${periksa.tinggiBadan} cm'
                          '\nVitamin: ${periksa.pemberianVitamin ? "Ya" : "Tidak"} | Imunisasi: ${periksa.imunisasiDasar ? "Dasar" : periksa.imunisasiLanjut ? "Lanjut" : "Belum"}'
                          '\nStatus Kesehatan: ${periksa.statusKesehatan}'),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}