import 'package:flutter/material.dart';
import '../models/posyandu_models.dart';
import '../widgets/custom_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboardPage(context),
      _buildRiwayatPage(context),
      _buildProfilePage(context),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Posyandu Dashboard')),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          } else {
            _onItemTapped(index);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildDashboardPage(BuildContext context) {
    final nextSchedule = sampleUser.riwayatIbu.isNotEmpty
        ? sampleUser.riwayatIbu.first.jadwalSelanjutnya
        : 'Belum tersedia';

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${sampleUser.nama}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Pantau riwayat posyandu dan kesehatan balita Anda',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Jadwal Posyandu selanjutnya',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              nextSchedule,
                              style: TextStyle(
                                color: Color(0xFF2196F3),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Ibu Hamil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _infoRow('Nama', sampleUser.nama),
                    _infoRow(
                      'TTL',
                      '${sampleUser.tempatLahir}, ${sampleUser.tanggalLahir}',
                    ),
                    _infoRow('Alamat', sampleUser.alamat),
                    _infoRow('Telepon', sampleUser.telepon),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      context,
                      Icons.favorite,
                      'Riwayat Ibu',
                      '/riwayat_ibu',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _actionCard(
                      context,
                      Icons.child_care,
                      'Riwayat Balita',
                      '/riwayat_balita',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      context,
                      Icons.pets,
                      'Data Balita',
                      '/data_balita',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _actionCard(
                      context,
                      Icons.person,
                      'Profil',
                      '/profile',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Data Balita Anda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              sampleUser.balita.isEmpty
                  ? CustomCard(child: Text('Belum ada data balita'))
                  : Container(
                      height: 320,
                      child: ListView.builder(
                        itemCount: sampleUser.balita.length,
                        itemBuilder: (context, index) {
                          final balita = sampleUser.balita[index];
                          return CustomCard(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                balita.nama,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    'TTL: ${balita.tempatLahir}, ${balita.tanggalLahir}',
                                  ),
                                  Text('Status Gizi: ${balita.statusGizi}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRiwayatPage(BuildContext context) {
    final items = [
      {
        'icon': Icons.favorite,
        'title': 'Riwayat Ibu Hamil',
        'route': '/riwayat_ibu',
      },
      {
        'icon': Icons.child_care,
        'title': 'Riwayat Balita',
        'route': '/riwayat_balita',
      },
    ];
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CustomCard(
                margin: EdgeInsets.only(bottom: 14),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[50],
                    child: Icon(
                      item['icon'] as IconData,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () =>
                      Navigator.pushNamed(context, item['route'] as String),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Ibu Hamil',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _infoRow('Nama', sampleUser.nama),
                    _infoRow(
                      'TTL',
                      '${sampleUser.tempatLahir}, ${sampleUser.tanggalLahir}',
                    ),
                    _infoRow('Alamat', sampleUser.alamat),
                    _infoRow('Telepon', sampleUser.telepon),
                    SizedBox(height: 20),
                    Text(
                      'Ringkasan Balita',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      sampleUser.balita.isNotEmpty
                          ? '${sampleUser.balita.length} anak terdaftar'
                          : 'Belum ada data balita',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(
    BuildContext context,
    IconData icon,
    String label,
    String routeName,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Icon(icon, color: Color(0xFF2196F3), size: 24),
            ),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
