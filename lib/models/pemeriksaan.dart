import 'package:cloud_firestore/cloud_firestore.dart';

class PemeriksaanModel {
  String id;
  String balitaId;
  DateTime tanggal;
  double beratBadan;
  double tinggiBadan;
  String catatan;

  PemeriksaanModel({
    required this.id,
    required this.balitaId,
    required this.tanggal,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.catatan,
  });

  factory PemeriksaanModel.fromMap(Map<String, dynamic> data, String documentId) {
    return PemeriksaanModel(
      id: documentId,
      balitaId: data['balitaId'] ?? '',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      beratBadan: (data['beratBadan'] ?? 0).toDouble(),
      tinggiBadan: (data['tinggiBadan'] ?? 0).toDouble(),
      catatan: data['catatan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balitaId': balitaId,
      'tanggal': Timestamp.fromDate(tanggal),
      'beratBadan': beratBadan,
      'tinggiBadan': tinggiBadan,
      'catatan': catatan,
    };
  }
}