import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pemeriksaan.dart';

class PemeriksaanProvider with ChangeNotifier {
  List<PemeriksaanModel> _riwayatPemeriksaan = [];
  bool _isLoading = false;

  List<PemeriksaanModel> get riwayatPemeriksaan => _riwayatPemeriksaan;
  bool get isLoading => _isLoading;

  // READ: Mengambil riwayat pemeriksaan berdasarkan ID Balita
  Future<void> fetchRiwayat(String balitaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('pemeriksaan')
          .where('balitaId', isEqualTo: balitaId)
          .orderBy('tanggal', descending: true) // Urutkan dari yang terbaru
          .get();

      _riwayatPemeriksaan = snapshot.docs.map((doc) {
        return PemeriksaanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching riwayat pemeriksaan: $e");
      // Firebase membutuhkan 'Index' khusus jika Anda menggunakan where() dan orderBy() bersamaan.
      // Jika terjadi error, Anda harus mengklik link yang muncul di console Log/Debug untuk membuat Index.
    }

    _isLoading = false;
    notifyListeners();
  }

  // CREATE: Menyimpan hasil pengukuran baru
  Future<bool> tambahPemeriksaan({
    required String balitaId,
    required double beratBadan,
    required double tinggiBadan,
    required String catatan,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('pemeriksaan').add({
        'balitaId': balitaId,
        'tanggal': Timestamp.now(), // Gunakan waktu saat ini otomatis
        'beratBadan': beratBadan,
        'tinggiBadan': tinggiBadan,
        'catatan': catatan,
      });
      await fetchRiwayat(balitaId); // Langsung refresh data riwayat
      return true;
    } catch (e) {
      return false;
    }
  }
}