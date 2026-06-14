import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/balita_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ambil ID Orang Tua yang sedang login, lalu cari data anaknya
      final userId = context.read<UserProvider>().currentUser?.id ?? '';
      if (userId.isNotEmpty) {
        context.read<BalitaProvider>().fetchBalitaByOrangTua(userId);
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
                MaterialPageRoute(builder: (_) => const LoginScreen())
              );
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Kartu Sapaan
          Container(
            color: const Color(0xFFE1F5FE),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Halo,', style: TextStyle(fontSize: 16)),
                Text(user?.namaLengkap ?? 'Orang Tua', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0288D1))),
                const SizedBox(height: 8),
                const Text('Pantau terus tumbuh kembang buah hati Anda di sini.', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Daftar Anak Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          // Menampilkan Daftar Anak
          Expanded(
            child: Consumer<BalitaProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) return const Center(child: CircularProgressIndicator());
                
                if (provider.listBalita.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Belum ada data anak.\nSilakan hubungi Kader Posyandu untuk mendaftarkan anak Anda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.listBalita.length,
                  itemBuilder: (context, index) {
                    final balita = provider.listBalita[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.child_care, color: Colors.blue, size: 30),
                        ),
                        title: Text(balita.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Text('Posko ID: ${balita.poskoId}'),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                        onTap: () {
                          // Membuka halaman detail balita yang sama dengan milik kader
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetailBalitaScreen(balita: balita)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}