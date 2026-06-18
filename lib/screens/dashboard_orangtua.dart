import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Wajib untuk format tanggal
import '../providers/user_provider.dart';
import '../providers/balita_provider.dart';
import '../providers/jadwal_provider.dart';
import 'login.dart';
import 'detail_balita.dart';

class DashboardOrangTua extends StatefulWidget {
  const DashboardOrangTua({super.key});

  @override
  State<DashboardOrangTua> createState() => _DashboardOrangTuaState();
}

class _DashboardOrangTuaState extends State<DashboardOrangTua> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserProvider>();
      final balitaProvider = context.read<BalitaProvider>();
      final jadwalProvider = context.read<JadwalProvider>();

      final userId = userProvider.currentUser?.id ?? '';
      
      if (userId.isNotEmpty) {
        // 1. Ambil data anak milik orang tua ini
        await balitaProvider.fetchBalitaByOrangTua(userId);
        
        // 2. Jika anak ditemukan, ambil jadwal (beserta nama posko) berdasarkan poskoId anak pertama
        final balitas = balitaProvider.listBalita;
        if (balitas.isNotEmpty) {
          jadwalProvider.fetchJadwalMendatang(balitas[0].poskoId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Orang Tua'),
        backgroundColor: const Color(0xFF4FC3F7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UserProvider>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      // Menggunakan SingleChildScrollView agar seluruh halaman bisa di-scroll
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- KARTU SAPAAN ---
            Container(
              color: const Color(0xFFE1F5FE),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Halo,', style: TextStyle(fontSize: 16)),
                  Text(
                    user?.namaLengkap ?? 'Orang Tua',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Pantau terus tumbuh kembang buah hati Anda di sini.',
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),

            // --- JADWAL POSYANDU ---
            if(user?.poskoId != null )
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Jadwal Posyandu Mendatang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Consumer<JadwalProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (provider.listJadwal.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Tidak ada jadwal mendatang.', style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true, // Wajib jika di dalam SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Scroll mengikuti halaman utama
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.listJadwal.length,
                  itemBuilder: (context, index) {
                    final jadwal = provider.listJadwal[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.calendar_month, color: Colors.blue),
                        ),
                        title: Text(
                          jadwal.kegiatan,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${jadwal.namaPosko ?? "Posko"} - ${jadwal.lokasi}\n'
                          'Tanggal: ${DateFormat('dd MMM yyyy').format(jadwal.tanggal)}',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.notifications_active, color: Colors.blue, size: 20),
                      ),
                    );
                  },
                );
              },
            ),

            // --- DAFTAR ANAK ---
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Daftar Anak Anda',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Consumer<BalitaProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (provider.listBalita.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'Belum ada data anak.\nSilakan hubungi Kader Posyandu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true, // Wajib jika di dalam SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Scroll mengikuti halaman utama
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.listBalita.length,
                  itemBuilder: (context, index) {
                    final balita = provider.listBalita[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.child_care, color: Colors.blue),
                        ),
                        title: Text(
                          balita.namaLengkap,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Posko ID: ${balita.poskoId}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailBalitaScreen(
                                balita: balita,
                                role: 'orangTua',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24), // Spasi kosong di paling bawah
          ],
        ),
      ),
    );
  }
}