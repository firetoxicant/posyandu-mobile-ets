import 'package:flutter/material.dart';
import '../models/posyandu_models.dart';
import 'riwayat_detail_screen.dart';

class RiwayatBalitaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pemeriksaan Balita')),
      body: SafeArea(
        child: sampleUser.balita.isEmpty
            ? Center(
                child: Text(
                  'Belum ada data balita',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: sampleUser.balita.length,
                itemBuilder: (context, index) {
                  final balita = sampleUser.balita[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        balita.nama,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...balita.riwayat.map((pemeriksaan) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            title: Text(
                              pemeriksaan.tanggal,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 6),
                                Text('Status: ${pemeriksaan.status}'),
                                Text(
                                  'Berat: ${pemeriksaan.beratBadan} kg, Tinggi: ${pemeriksaan.tinggiBadan} cm',
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RiwayatDetailScreen(
                                    pemeriksaan: pemeriksaan,
                                    title:
                                        'Pemeriksaan Balita - ${balita.nama}',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
