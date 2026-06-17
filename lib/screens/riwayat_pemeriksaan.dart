import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pemeriksaan_provider.dart';

class RiwayatPemeriksaanScreen extends StatefulWidget {
  final String role;
  final String userId;

  const RiwayatPemeriksaanScreen({super.key, required this.role, required this.userId});

  @override
  State<RiwayatPemeriksaanScreen> createState() => _RiwayatPemeriksaanScreenState();
}

class _RiwayatPemeriksaanScreenState extends State<RiwayatPemeriksaanScreen> {
  
  @override
  void initState() {
    super.initState();
    
    // Jalankan penarikan data sesuai dengan role yang dikirim dari MainScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PemeriksaanProvider>();
      
      if (widget.role == 'kader') {
        // Ambil data yang dikerjakan oleh kader ini saja
        provider.fetchRiwayatKader(widget.userId);
      } else if (widget.role == 'orangTua') {
        // Ambil data anak milik orang tua ini saja
        provider.fetchRiwayatOrangTua(widget.userId);
      } else if (widget.role == 'admin') {
        // Jika ada admin, panggil fungsi untuk mengambil SEMUA data
        // provider.fetchAllRiwayat(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final riwayatProvider = context.watch<PemeriksaanProvider>();

    // Sesuaikan judul AppBar berdasarkan role
    String titleText = 'Riwayat Pemeriksaan';
    if (widget.role == 'orangTua') titleText = 'Riwayat Anak Anda';
    if (widget.role == 'kader') titleText = 'Pemeriksaan Anda';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: riwayatProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : riwayatProvider.listPemeriksaan.isEmpty
              ? const Center(child: Text('Belum ada data riwayat.'))
              : ListView.builder(
                  itemCount: riwayatProvider.listPemeriksaan.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final periksa = riwayatProvider.listPemeriksaan[index];
                    
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE1F5FE),
                          child: Icon(Icons.history, color: Colors.blue),
                        ),
                        title: Text(
                          periksa.namaBalita ?? 'Memuat nama...', // Menampilkan Nama Balita
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Tgl: ${periksa.tanggal.day}/${periksa.tanggal.month}/${periksa.tanggal.year}\n'
                          'BB: ${periksa.beratBadan} kg | TB: ${periksa.tinggiBadan} cm\n'
                          'Status: ${periksa.statusKesehatan}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}