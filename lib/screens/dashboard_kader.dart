import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'login.dart';
import 'daftar_balita.dart';
import 'jadwal_posyandu.dart';

class DashboardKader extends StatelessWidget {
  const DashboardKader({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data kader yang sedang login
    final user = context.watch<UserProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kader'),
        backgroundColor: const Color(0xFF4FC3F7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UserProvider>().logout();
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (_) => const LoginScreen())
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Profil Singkat Kader
            Card(
              color: const Color(0xFFE1F5FE),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat datang,', style: TextStyle(color: Colors.grey[700])),
                    Text(
                      user?.namaLengkap ?? 'Kader', 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    // Menampilkan ID Posko tempat kader bertugas
                    Text('Menugaskan di Posko ID: ${user?.poskoId ?? "-"}',
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text('Menu Kader', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Tombol ke Manajemen Balita
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0288D1),
                alignment: Alignment.centerLeft,
                side: const BorderSide(color: Color(0xFFB3E5FC)),
              ),
              icon: const Icon(Icons.child_care, size: 30),
              label: const Text('Manajemen Data Balita', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DaftarBalitaScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            // Tombol ke Jadwal Posyandu
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0288D1),
                alignment: Alignment.centerLeft,
                side: const BorderSide(color: Color(0xFFB3E5FC)),
              ),
              icon: const Icon(Icons.calendar_month, size: 30),
              label: const Text('Jadwal Posyandu', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JadwalPosyanduScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            // 👇 Tombol Baru: Input Pemeriksaan
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0288D1),
                alignment: Alignment.centerLeft,
                side: const BorderSide(color: Color(0xFFB3E5FC)),
              ),
              icon: const Icon(Icons.monitor_weight, size: 30), // Ikon timbangan
              label: const Text('Input Pemeriksaan', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DaftarBalitaScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}