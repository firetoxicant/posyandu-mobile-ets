import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'login.dart';
import 'manajemen_posko.dart';
import 'manajemen_kader.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
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
            const Text(
              'Menu Utama',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // --- Tombol Menuju Manajemen Posko ---
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: const Color(0xFFE3F2FD),
                foregroundColor: const Color(0xFF1E88E5),
                alignment: Alignment.centerLeft,
              ),
              icon: const Icon(Icons.home_work, size: 30),
              label: const Text('Manajemen Posko', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManajemenPoskoScreen()),
                );
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: const Color(0xFFFFF3E0), // Warna orange muda
                foregroundColor: Colors.orange[800],
                alignment: Alignment.centerLeft,
              ),
              icon: const Icon(Icons.medical_information, size: 30),
              label: const Text('Manajemen Akun Kader', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManajemenKaderScreen()),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Nanti Anda bisa tambahkan tombol lain di sini
            // (Misal: Manajemen Kader, Riwayat Pemeriksaan, dll)
          ],
        ),
      ),
    );
  }
}