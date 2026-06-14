import 'package:cloud_firestore/cloud_firestore.dart';

class JadwalModel {
  String id;
  String poskoId;
  DateTime tanggal;
  String kegiatan;
  String lokasi; // Detail lokasi jika diperlukan (misal: Balai Desa)

  JadwalModel({
    required this.id,
    required this.poskoId,
    required this.tanggal,
    required this.kegiatan,
    required this.lokasi,
  });

  factory JadwalModel.fromMap(Map<String, dynamic> data, String documentId) {
    return JadwalModel(
      id: documentId,
      poskoId: data['poskoId'] ?? '',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      kegiatan: data['kegiatan'] ?? '',
      lokasi: data['lokasi'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'poskoId': poskoId,
      'tanggal': Timestamp.fromDate(tanggal),
      'kegiatan': kegiatan,
      'lokasi': lokasi,
    };
  }
}