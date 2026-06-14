import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/balita.dart';
import '../models/user.dart'; // Untuk mengambil data orang tua saat form input

class BalitaProvider with ChangeNotifier {
  List<BalitaModel> _listBalita = [];
  List<UserModel> _listOrangTua = []; // Digunakan untuk pilihan dropdown saat tambah balita
  bool _isLoading = false;

  List<BalitaModel> get listBalita => _listBalita;
  List<UserModel> get listOrangTua => _listOrangTua;
  bool get isLoading => _isLoading;

  // READ: Mengambil daftar balita BERDASARKAN Posko Kader
  Future<void> fetchBalitaByPosko(String poskoId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('balita')
          .where('poskoId', isEqualTo: poskoId)
          .get();

      _listBalita = snapshot.docs.map((doc) {
        return BalitaModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching balita: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // READ: Mengambil daftar Orang Tua untuk dropdown pilihan saat Kader mendaftarkan balita
  Future<void> fetchOrangTua() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'orangtua')
          .get();

      _listOrangTua = snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching orang tua: $e");
    }
  }

  // CREATE: Tambah Balita Baru
  Future<bool> tambahBalita({
    required String namaLengkap,
    required DateTime tanggalLahir,
    required String jenisKelamin,
    required String orangTuaId,
    required String poskoId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('balita').add({
        'namaLengkap': namaLengkap,
        'tanggalLahir': Timestamp.fromDate(tanggalLahir),
        'jenisKelamin': jenisKelamin,
        'orangTuaId': orangTuaId,
        'poskoId': poskoId,
      });
      await fetchBalitaByPosko(poskoId); // Refresh data
      return true;
    } catch (e) {
      return false;
    }
  }

  // UPDATE: Memperbarui data Balita
  Future<bool> updateBalita(String id, BalitaModel balita) async {
    try {
      await FirebaseFirestore.instance.collection('balita').doc(id).update({
        'namaLengkap': balita.namaLengkap,
        'tanggalLahir': Timestamp.fromDate(balita.tanggalLahir),
        'jenisKelamin': balita.jenisKelamin,
        'orangTuaId': balita.orangTuaId,
        'poskoId': balita.poskoId,
      });
      await fetchBalitaByPosko(balita.poskoId); // Refresh data
      return true;
    } catch (e) {
      debugPrint("Error updating balita: $e");
      return false;
    }
  }

  // DELETE: Hapus Balita
  Future<bool> hapusBalita(String id, String poskoId) async {
    try {
      await FirebaseFirestore.instance.collection('balita').doc(id).delete();
      await fetchBalitaByPosko(poskoId); // Refresh data
      return true;
    } catch (e) {
      return false;
    }
  }

  // READ: Mengambil daftar balita BERDASARKAN Orang Tua (untuk tampilan ortu)
  Future<void> fetchBalitaByOrangTua(String orangTuaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('balita')
          .where('orangTuaId', isEqualTo: orangTuaId)
          .get();

      _listBalita = snapshot.docs.map((doc) {
        return BalitaModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching balita by orang tua: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}