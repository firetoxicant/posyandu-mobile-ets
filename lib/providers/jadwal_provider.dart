import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/jadwal.dart';

class JadwalProvider with ChangeNotifier {
  List<JadwalModel> _listJadwal = [];
  bool _isLoading = false;

  List<JadwalModel> get listJadwal => _listJadwal;
  bool get isLoading => _isLoading;

  // READ: Mengambil jadwal yang akan datang untuk posko tertentu
  Future<void> fetchJadwal(String poskoId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('jadwal')
          .where('poskoId', isEqualTo: poskoId)
          .orderBy('tanggal', descending: false) // Urutkan dari yang paling dekat
          .get();

      _listJadwal = snapshot.docs.map((doc) {
        return JadwalModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching jadwal: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

// READ: Mengambil jadwal yang akan datang untuk posko tertentu beserta nama posko
  Future<void> fetchJadwalMendatang(String poskoIdUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Ambil Jadwal
      QuerySnapshot jadwalSnapshot = await FirebaseFirestore.instance
          .collection('jadwal')
          .where('poskoId', isEqualTo: poskoIdUser)
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('tanggal', descending: false)
          .get();

      _listJadwal = await Future.wait(jadwalSnapshot.docs.map((doc) async {
        JadwalModel jadwal = JadwalModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        
        // 2. Cari Nama Posko berdasarkan poskoId
        DocumentSnapshot poskoDoc = await FirebaseFirestore.instance
            .collection('posko')
            .doc(jadwal.poskoId)
            .get();
        
        if (poskoDoc.exists) {
          jadwal.namaPosko = (poskoDoc.data() as Map<String, dynamic>)['namaPosko'];
        }
        
        return jadwal;
      }).toList());
      
    } catch (e) {
      debugPrint("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // CREATE: Menambah Jadwal Baru
  Future<bool> tambahJadwal({
    required String poskoId,
    required DateTime tanggal,
    required String kegiatan,
    required String lokasi,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('jadwal').add({
        'poskoId': poskoId,
        'tanggal': Timestamp.fromDate(tanggal),
        'kegiatan': kegiatan,
        'lokasi': lokasi,
      });
      await fetchJadwal(poskoId); // Refresh daftar
      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE: Menghapus Jadwal
  Future<bool> hapusJadwal(String id, String poskoId) async {
    try {
      await FirebaseFirestore.instance.collection('jadwal').doc(id).delete();
      await fetchJadwal(poskoId);
      return true;
    } catch (e) {
      return false;
    }
  }
}