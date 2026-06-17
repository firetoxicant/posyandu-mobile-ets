import 'package:cloud_firestore/cloud_firestore.dart';
class JadwalModel {
  final String id;
  final String kegiatan;
  final DateTime tanggal;
  final String lokasi;
  final String poskoId;
  String? namaPosko; // Tambahkan field ini

  JadwalModel({
    required this.id,
    required this.kegiatan,
    required this.tanggal,
    required this.lokasi,
    required this.poskoId,
    this.namaPosko,
  });

  factory JadwalModel.fromMap(Map<String, dynamic> data, String documentId) {
    return JadwalModel(
      id: documentId,
      kegiatan: data['kegiatan'] ?? '',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      lokasi: data['lokasi'] ?? '',
      poskoId: data['poskoId'] ?? '',
    );
  }
}