import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pemeriksaan.dart'; 

class PemeriksaanProvider with ChangeNotifier {
  List<PemeriksaanModel> _listPemeriksaan = [];
  bool _isLoading = false;

  List<PemeriksaanModel> get listPemeriksaan => _listPemeriksaan;
  bool get isLoading => _isLoading;

  // --- CREATE: Menambah Data Pemeriksaan Baru ---
  Future<bool> tambahPemeriksaan({
    required String balitaId,
    required String kaderId,
    required String poskoId,
    required double beratBadan,
    required double tinggiBadan,
    required double lingkarKepala,
    required bool pemberianVitamin,
    required bool imunisasiDasar,
    required bool imunisasiLanjut,
    required String statusKesehatan,
    String? catatan,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('pemeriksaan').add({
        'balitaId': balitaId,
        'kaderId': kaderId,
        'poskoId': poskoId,
        'tanggal': Timestamp.now(), // Otomatis
        'beratBadan': beratBadan,
        'tinggiBadan': tinggiBadan,
        'lingkarKepala': lingkarKepala,
        'pemberianVitamin': pemberianVitamin,
        'imunisasiDasar': imunisasiDasar,
        'imunisasiLanjut': imunisasiLanjut,
        'statusKesehatan': statusKesehatan,
        'catatan': catatan, 
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stacktrace) {
      debugPrint("Error tambah pemeriksaan: $e");
      debugPrint("Stacktrace: $stacktrace");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- READ: Mengambil SEMUA Riwayat Pemeriksaan (Khusus Admin) ---
  Future<void> fetchAllRiwayat() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('pemeriksaan')
          .orderBy('tanggal', descending: true)
          .get();

        _listPemeriksaan = await Future.wait(snapshot.docs.map((doc) async {
        PemeriksaanModel periksa = PemeriksaanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        
        // Cari nama balita di koleksi 'balita'
        DocumentSnapshot balitaDoc = await FirebaseFirestore.instance
            .collection('balita')
            .doc(periksa.balitaId)
            .get();
            
        if (balitaDoc.exists) {
          periksa.namaBalita = (balitaDoc.data() as Map<String, dynamic>)['namaLengkap'];
        }
        
        return periksa;
      }).toList());
    } catch (e, stacktrace) {
      debugPrint("Error fetching all riwayat (Admin): $e");
      debugPrint("Stacktrace: $stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- READ: Mengambil Riwayat Pemeriksaan Berdasarkan Balita ---
  Future<void> fetchRiwayatBalita(String balitaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('pemeriksaan')
          .where('balitaId', isEqualTo: balitaId)
          .orderBy('tanggal', descending: true) 
          .get();

      _listPemeriksaan = snapshot.docs.map((doc) {
        return PemeriksaanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e, stacktrace) {
      debugPrint("Error fetching riwayat balita: $e");
      debugPrint("Stacktrace: $stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- READ: Mengambil Riwayat Pemeriksaan Khusus Orang Tua ---
  Future<void> fetchRiwayatOrangTua(String orangTuaId) async {
  _isLoading = true;
  notifyListeners();

  debugPrint("==> orangTuaId yang dicari: $orangTuaId");

  try {
    QuerySnapshot balitaSnapshot = await FirebaseFirestore.instance
        .collection('balita')
        .where('orangTuaId', isEqualTo: orangTuaId)
        .get();

    debugPrint("==> jumlah balita ditemukan: ${balitaSnapshot.docs.length}");

    if (balitaSnapshot.docs.isEmpty) {
      _listPemeriksaan = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    List<String> listBalitaId = balitaSnapshot.docs.map((doc) => doc.id).toList();

    // BUAT MAP UNTUK MENYIMPAN NAMA BALITA
    Map<String, String> mapNamaBalita = {};
    for (var doc in balitaSnapshot.docs) {
      mapNamaBalita[doc.id] = (doc.data() as Map<String, dynamic>)['namaLengkap'] ?? 'Nama tidak diketahui';
    }

    QuerySnapshot periksaSnapshot = await FirebaseFirestore.instance
        .collection('pemeriksaan')
        .where('balitaId', whereIn: listBalitaId)
        .orderBy('tanggal', descending: true)
        .get();

    // MASUKKAN NAMA BALITA SAAT MAPPING
    _listPemeriksaan = periksaSnapshot.docs.map((doc) {
      PemeriksaanModel periksa = PemeriksaanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      periksa.namaBalita = mapNamaBalita[periksa.balitaId]; // Set namanya di sini
      return periksa;
    }).toList();

  } catch (e, stacktrace) {
    debugPrint("Error fetching riwayat orang tua: $e");
    debugPrint("Stacktrace: $stacktrace");
  }

  _isLoading = false;
  notifyListeners();
}

  // --- READ: Mengambil Riwayat Pemeriksaan Berdasarkan Kader ---
  Future<void> fetchRiwayatKader(String kaderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('pemeriksaan')
          .where('kaderId', isEqualTo: kaderId)
          .orderBy('tanggal', descending: true)
          .get();

        _listPemeriksaan = await Future.wait(snapshot.docs.map((doc) async {
          PemeriksaanModel periksa = PemeriksaanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          
          // Cari nama balita di koleksi 'balita'
          DocumentSnapshot balitaDoc = await FirebaseFirestore.instance
              .collection('balita')
              .doc(periksa.balitaId)
              .get();
              
          if (balitaDoc.exists) {
            periksa.namaBalita = (balitaDoc.data() as Map<String, dynamic>)['namaLengkap'];
          }
          
          return periksa;
        }).toList());
    } catch (e, stacktrace) {
      debugPrint("Error fetching riwayat kader: $e");
      debugPrint("Stacktrace: $stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- DELETE: Menghapus Data Pemeriksaan (Opsional: Hanya untuk Admin/Kader) ---
  Future<bool> hapusPemeriksaan(String pemeriksaanId) async {
    try {
      await FirebaseFirestore.instance.collection('pemeriksaan').doc(pemeriksaanId).delete();
      
      // Hapus data dari list lokal agar UI langsung update tanpa perlu fetch ulang
      _listPemeriksaan.removeWhere((item) => item.id == pemeriksaanId);
      notifyListeners();
      
      return true;
    } catch (e, stacktrace) {
      debugPrint("Error menghapus pemeriksaan: $e");
      debugPrint("Stacktrace: $stacktrace");
      return false;
    }
  }
}