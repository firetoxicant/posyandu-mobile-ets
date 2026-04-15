import 'package:flutter/material.dart';
import '../models/posyandu_models.dart';
import 'riwayat_detail_screen.dart';

class RiwayatIbuHamilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pemeriksaan Ibu Hamil')),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: sampleUser.riwayatIbu.length,
          itemBuilder: (context, index) {
            final pemeriksaan = sampleUser.riwayatIbu[index];
            return Card(
              margin: EdgeInsets.only(bottom: 14),
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
                      'Tinggi: ${pemeriksaan.tinggiBadan} cm, Berat: ${pemeriksaan.beratBadan} kg',
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
                        title: 'Pemeriksaan Ibu Hamil',
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
