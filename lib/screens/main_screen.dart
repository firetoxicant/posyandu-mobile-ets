import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'dashboard_admin.dart'; // Sesuaikan nama file dashboard Anda
import 'dashboard_kader.dart'; // Sesuaikan nama file dashboard Anda
import 'dashboard_orangtua.dart'; // Sesuaikan nama file dashboard Anda
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    
    // Jika data user belum siap, tampilkan loading
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Konfigurasi Layar (Screens) Berdasarkan Role
    List<Widget> screens = [];
    List<BottomNavigationBarItem> navItems = [];

    if (user.role == 'admin') {
      screens = [
        const DashboardAdmin(), // Ganti dengan layar Dashboard Admin Anda
        const Center(child: Text('Halaman Kelola Data (Rekomendasi)')), // Buat layar Kelola Data nanti
        const ProfileScreen(),
      ];
      navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Kelola Data'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    } else if (user.role == 'kader') {
      screens = [
        const DashboardKader(),
        const Center(child: Text('Halaman Riwayat Pemeriksaan Kader')), // Buat layar Riwayat Kader
        const ProfileScreen(),
      ];
      navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    } else {
      // Default: Orang Tua
      screens = [
        const DashboardOrangTua(),
        const Center(child: Text('Halaman Riwayat Anak')), // Buat layar Riwayat Anak
        const ProfileScreen(),
      ];
      navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.child_care), label: 'Riwayat Anak'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    }

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navItems,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}