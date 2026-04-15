import 'package:flutter/material.dart';
import '../models/posyandu_models.dart';

class DataBalitaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Balita')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: sampleUser.balita.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada data balita saat ini',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: sampleUser.balita.length,
                  itemBuilder: (context, index) {
                    final balita = sampleUser.balita[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
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
                            _infoRow(
                              'Tempat, Tanggal Lahir',
                              '${balita.tempatLahir}, ${balita.tanggalLahir}',
                            ),
                            _infoRow('Ibu Kandung', balita.ibuKandung),
                            _infoRow('Alamat', balita.alamat),
                            _infoRow('Status Gizi', balita.statusGizi),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.grey[700])),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
