import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/riwayat_ibu_screen.dart';
import 'screens/riwayat_balita_screen.dart';
import 'screens/data_balita_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(color: Colors.grey[900]);

    return MaterialApp(
      title: 'Posyandu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF2196F3),
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(secondary: Color(0xFFFF5722)),
        textTheme: TextTheme(
          headlineLarge: baseStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: baseStyle.copyWith(fontSize: 16),
          bodyMedium: baseStyle.copyWith(fontSize: 14, color: Colors.grey[700]),
          labelLarge: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF2196F3),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 10,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/riwayat_ibu': (context) => RiwayatIbuHamilScreen(),
        '/riwayat_balita': (context) => RiwayatBalitaScreen(),
        '/data_balita': (context) => DataBalitaScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


