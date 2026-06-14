import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/balita_provider.dart';
import 'providers/posko_provider.dart';
import 'providers/pemeriksaan_provider.dart';
import 'providers/jadwal_provider.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BalitaProvider()),
        ChangeNotifierProvider(create: (_) => PoskoProvider()),
        ChangeNotifierProvider(create: (_) => PemeriksaanProvider()),
        ChangeNotifierProvider(create: (_) => JadwalProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posyandu App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4FC3F7), // Biru Muda Elegan
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4FC3F7)),
      ),
      home: const LoginScreen(), // Awal mula aplikasi
    );
  }
}