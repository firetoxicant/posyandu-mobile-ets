import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/posko.dart';

class PoskoProvider with ChangeNotifier {
  List<PoskoModel> _listPosko = [];
  bool _isLoading = false;

  List<PoskoModel> get listPosko => _listPosko;
  bool get isLoading => _isLoading;

  // READ: Mengambil seluruh data posko dari Firestore
  Future<void> fetchPosko() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posko').get();
      _listPosko = snapshot.docs.map((doc) {
        return PoskoModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching posko: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // CREATE: Menambah data posko baru
  Future<bool> tambahPosko(String nama, String alamat) async {
    try {
      await FirebaseFirestore.instance.collection('posko').add({
        'namaPosko': nama,
        'alamat': alamat,
      });
      await fetchPosko(); // Refresh data setelah ditambah
      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE: Menghapus data posko
  Future<bool> hapusPosko(String id) async {
    try {
      await FirebaseFirestore.instance.collection('posko').doc(id).delete();
      await fetchPosko(); // Refresh data
      return true;
    } catch (e) {
      return false;
    }
  }
}