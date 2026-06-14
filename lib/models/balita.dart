import 'package:cloud_firestore/cloud_firestore.dart';

class BalitaModel {
  String id;
  String namaLengkap;
  DateTime tanggalLahir;
  String jenisKelamin; // "Laki-laki" atau "Perempuan"
  String orangTuaId; // Menyimpan ID akun orang tua agar saling terhubung
  String poskoId; // Agar balita hanya muncul di posko tempat ia didaftarkan

  BalitaModel({
    required this.id,
    required this.namaLengkap,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.orangTuaId,
    required this.poskoId,
  });

  factory BalitaModel.fromMap(Map<String, dynamic> data, String documentId) {
    return BalitaModel(
      id: documentId,
      namaLengkap: data['namaLengkap'] ?? '',
      tanggalLahir: (data['tanggalLahir'] as Timestamp).toDate(),
      jenisKelamin: data['jenisKelamin'] ?? 'Laki-laki',
      orangTuaId: data['orangTuaId'] ?? '',
      poskoId: data['poskoId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLengkap': namaLengkap,
      'tanggalLahir': Timestamp.fromDate(tanggalLahir),
      'jenisKelamin': jenisKelamin,
      'orangTuaId': orangTuaId,
      'poskoId': poskoId,
    };
  }
}