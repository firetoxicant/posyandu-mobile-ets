import 'package:cloud_firestore/cloud_firestore.dart';

class PemeriksaanModel {
  String id;
  String balitaId;
  String kaderId; 
  String poskoId;
  DateTime tanggal;
  double beratBadan;
  double tinggiBadan;
  double lingkarKepala;
  bool pemberianVitamin;
  bool imunisasiDasar;
  bool imunisasiLanjut;
  String statusKesehatan;
  String? catatan;
  String? namaBalita;

  PemeriksaanModel({
    required this.id,
    required this.balitaId,
    required this.kaderId,
    required this.poskoId,
    required this.tanggal,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarKepala,
    this.pemberianVitamin = false,
    this.imunisasiDasar = false,
    this.imunisasiLanjut = false,
    required this.statusKesehatan,
    this.catatan,
    this.namaBalita,
  });

  factory PemeriksaanModel.fromMap(Map<String, dynamic> data, String documentId) {
    // Ambil data tanggal secara aman
    DateTime tanggalValid;
    if (data['tanggal'] is Timestamp) {
      tanggalValid = (data['tanggal'] as Timestamp).toDate();
    } else if (data['tanggal'] is String) {
      // Berjaga-jaga jika di Firestore tidak sengaja tersimpan sebagai String
      tanggalValid = DateTime.tryParse(data['tanggal']) ?? DateTime.now();
    } else {
      // Jika null atau tipe lainnya, beri tanggal hari ini agar tidak crash
      tanggalValid = DateTime.now();
    }
    return PemeriksaanModel(
      id: documentId,
      balitaId: data['balitaId'] ?? '',
      kaderId: data['kaderId'] ?? '',
      poskoId: data['poskoId'] ?? '',
      tanggal: tanggalValid,
      beratBadan: (data['beratBadan'] ?? 0).toDouble(),
      tinggiBadan: (data['tinggiBadan'] ?? 0).toDouble(),
      lingkarKepala: (data['lingkarKepala'] ?? 0).toDouble(),
      pemberianVitamin: data['pemberianVitamin'] ?? false,
      imunisasiDasar: data['imunisasiDasar'] ?? false,
      imunisasiLanjut: data['imunisasiLanjut'] ?? false,
      statusKesehatan: data['statusKesehatan'] ?? 'baik',
      catatan: data['catatan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balitaId': balitaId,
      'kaderId': kaderId,
      'poskoId': poskoId,
      'tanggal': Timestamp.fromDate(tanggal),
      'beratBadan': beratBadan,
      'tinggiBadan': tinggiBadan,
      'lingkarKepala': lingkarKepala,
      'pemberianVitamin': pemberianVitamin,
      'imunisasiDasar': imunisasiDasar,
      'imunisasiLanjut': imunisasiLanjut,
      'statusKesehatan': statusKesehatan,
      'catatan': catatan,
    };
  }
}