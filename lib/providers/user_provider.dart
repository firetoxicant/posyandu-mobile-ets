import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  List<UserModel> _orangtuaUsers = [];
  List<UserModel> _listKader = [];

  List<UserModel> get orangtuaUsers => _orangtuaUsers;
  List<UserModel> get listKader => _listKader;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

// Fungsi login dengan email dan password
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      _isLoading = false; // Matikan loading jika sukses
      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        notifyListeners();
        return _currentUser!.role; 
      }
      
      notifyListeners();
      return null;
    } catch (e) {
      print("ERROR FIREBASE LOGIN: $e"); 
      _isLoading = false; // PERBAIKAN: Matikan loading agar tombol aktif kembali jika error
      notifyListeners();
      return null; // Mengembalikan null agar dibaca sebagai error oleh UI
    }
  }
// Fungsi untuk mendaftar orang tua (role otomatis 'orangtua')
  Future<bool> registerOrangTua(String nama, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'namaLengkap': nama,
        'email': email,
        'role': 'orangtua',
        'poskoId': null, 
      });
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("ERROR FIREBASE REGISTER: $e"); // PERBAIKAN: Sekarang error register akan terlihat di console!
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch daftar orang tua
  Future<void> fetchOrangtuaUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'orangtua')
          .get();

      _orangtuaUsers = snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error mengambil data orang tua: $e");
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // ==========================================
  // MANAJEMEN AKUN KADER OLEH ADMIN
  // ==========================================
  Future<void> fetchSemuaKader() async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'kader')
          .get();
      
      _listKader = snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Error fetching kader: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> tambahKader(String nama, String email, String password, String poskoId) async {
    try {
      FirebaseApp tempApp = await Firebase.initializeApp(
        name: 'TemporaryRegister', 
        options: Firebase.app().options
      );

      UserCredential userCredential = await FirebaseAuth.instanceFor(app: tempApp)
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'namaLengkap': nama,
        'email': email,
        'role': 'kader',
        'poskoId': poskoId, 
      });

      await tempApp.delete();
      await fetchSemuaKader();
      return true;
    } catch (e) {
      debugPrint("Error tambah kader: $e");
      return false;
    }
  }

  Future<bool> hapusKader(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await fetchSemuaKader();
      return true;
    } catch (e) {
      return false;
    }
  }
}