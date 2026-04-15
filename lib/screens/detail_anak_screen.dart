import 'package:flutter/material.dart';
import '../models/anak_model.dart';
import '../widgets/custom_card.dart';

class DetailAnakScreen extends StatelessWidget {
  final Anak anak;

  const DetailAnakScreen({Key? key, required this.anak}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anak.nama),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Berhasil membagikan data anak')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan foto
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [Colors.blue[300]!, Colors.blue[100]!]),
                      ),
                      child: Icon(Icons.child_care, size: 60, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.verified, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Data Utama
              CustomCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Umur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('${anak.umurBulan} bulan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Berat Badan'),
                          Text('${anak.beratBadan} kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tinggi Badan'),
                          Text('${anak.tinggiBadan} cm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status Gizi'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: anak.statusGizi == 'Normal' ? Colors.green[100] : Colors.orange[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              anak.statusGizi,
                              style: TextStyle(
                                color: anak.statusGizi == 'Normal' ? Colors.green[800] : Colors.orange[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),
              Text('Riwayat Pemeriksaan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),

              // Riwayat List
              ...List.generate(5, (index) => CustomCard(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.date_range, color: Colors.blue),
                  title: Text('Pemeriksaan ${index + 1}'),
                  subtitle: Text('Berat: ${(anak.beratBadan - index * 0.2).toStringAsFixed(1)} kg'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}