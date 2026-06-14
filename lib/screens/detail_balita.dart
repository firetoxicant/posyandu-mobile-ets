import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Tambahan package chart
import '../models/balita.dart';
import '../models/pemeriksaan.dart';
import '../providers/pemeriksaan_provider.dart';
import '../providers/user_provider.dart';
import 'input_pemeriksaan.dart';

class DetailBalitaScreen extends StatefulWidget {
  final BalitaModel balita;

  const DetailBalitaScreen({super.key, required this.balita});

  @override
  State<DetailBalitaScreen> createState() => _DetailBalitaScreenState();
}

class _DetailBalitaScreenState extends State<DetailBalitaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PemeriksaanProvider>().fetchRiwayat(widget.balita.id);
    });
  }

  // Fungsi untuk menggambar grafik berdasarkan data
  Widget _buildGrafikPertumbuhan(List<PemeriksaanModel> riwayat) {
    if (riwayat.length < 2) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Grafik akan muncul setelah ada minimal 2 data pemeriksaan.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    // Urutkan data dari yang terlama ke terbaru untuk sumbu X grafik
    List<PemeriksaanModel> sortedRiwayat = List.from(riwayat);
    sortedRiwayat.sort((a, b) => a.tanggal.compareTo(b.tanggal));

    // Siapkan titik kordinat (X: Index, Y: Berat Badan)
    List<FlSpot> spots = [];
    for (int i = 0; i < sortedRiwayat.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedRiwayat[i].beratBadan));
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 20, left: 10, top: 20, bottom: 10),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < sortedRiwayat.length) {
                    // Tampilkan format bulan saja di sumbu X agar rapi (misal: "Jan")
                    return Text(DateFormat('MMM').format(sortedRiwayat[value.toInt()].tanggal), style: const TextStyle(fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = context.read<UserProvider>().currentUser?.role;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tumbuh Kembang Anak'),
        backgroundColor: const Color(0xFF4FC3F7),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: role == 'kader'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InputPemeriksaanScreen(balita: widget.balita),
                  ),
                );
              },
              icon: const Icon(Icons.add_chart),
              label: const Text('Input Pemeriksaan'),
              backgroundColor: const Color(0xFF4FC3F7),
            )
          : null,
      body: Consumer<PemeriksaanProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kartu Profil Anak
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.balita.namaLengkap, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Jenis Kelamin: ${widget.balita.jenisKelamin}'),
                  ],
                ),
              ),

              // Menampilkan Grafik Garis Pertumbuhan
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text('Grafik Berat Badan (kg)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              _buildGrafikPertumbuhan(provider.riwayatPemeriksaan),

              // Daftar Riwayat Pemeriksaan
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 8),
                child: Text('Riwayat Pemeriksaan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: provider.riwayatPemeriksaan.isEmpty
                    ? const Center(child: Text('Belum ada riwayat pemeriksaan.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.riwayatPemeriksaan.length,
                        itemBuilder: (context, index) {
                          final riwayat = provider.riwayatPemeriksaan[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFB3E5FC),
                                child: Icon(Icons.monitor_weight, color: Colors.blue),
                              ),
                              title: Text(DateFormat('dd MMMM yyyy').format(riwayat.tanggal), style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Berat: ${riwayat.beratBadan} kg | Tinggi: ${riwayat.tinggiBadan} cm\nCatatan: ${riwayat.catatan.isEmpty ? "-" : riwayat.catatan}'),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}