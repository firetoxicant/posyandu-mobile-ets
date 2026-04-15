import 'package:flutter/material.dart';
import '../models/posyandu_models.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final Pemeriksaan pemeriksaan;
  final String title;

  const RiwayatDetailScreen({
    Key? key,
    required this.pemeriksaan,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                pemeriksaan.tanggal,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Status: ${pemeriksaan.status}',
                style: TextStyle(
                  fontSize: 16,
                  color: _statusColor(pemeriksaan.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              _detailRow('Tinggi Badan', '${pemeriksaan.tinggiBadan} cm'),
              _detailRow('Berat Badan', '${pemeriksaan.beratBadan} kg'),
              _detailRow('Tekanan Darah', pemeriksaan.tekananDarah),
              _detailRow(
                'Lingkar Lengan Atas',
                '${pemeriksaan.lingkarLenganAtas} cm',
              ),
              _detailRow('Catatan', pemeriksaan.catatan),
              SizedBox(height: 18),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal Posyandu Selanjutnya',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      pemeriksaan.jadwalSelanjutnya,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    if (status.toLowerCase() == 'sehat') return Colors.green;
    if (status.toLowerCase() == 'waspada') return Colors.orange;
    if (status.toLowerCase() == 'berbahaya') return Colors.red;
    return Colors.blueGrey;
  }

  Widget _detailRow(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
