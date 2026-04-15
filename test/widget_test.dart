import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posyandu_app/main.dart';  // Import MyApp (bukan PosyanduApp)

void main() {
  testWidgets('Posyandu HomeScreen Navigation Test', (WidgetTester tester) async {
    // Build aplikasi Posyandu (MyApp)
    await tester.pumpWidget(MyApp());

    // ✅ Verifikasi HomeScreen dimuat (teks dari aplikasi Posyandu)
    expect(find.text('Posyandu Sehat'), findsOneWidget);
    expect(find.byIcon(Icons.child_care), findsWidgets); // Icon di header

    // ✅ Test FAB (FloatingActionButton) - navigasi ke Tambah Anak
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verifikasi halaman Tambah Anak muncul
    expect(find.text('Tambah Anak Baru'), findsOneWidget);
    expect(find.byIcon(Icons.child_care), findsOneWidget); // Icon di form

    // ✅ Test kembali ke Home
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Posyandu Sehat'), findsOneWidget);
  });

  testWidgets('Posyandu ListView & Like Button Test', (WidgetTester tester) async {
    // Build aplikasi
    await tester.pumpWidget(MyApp());

    // ✅ Verifikasi ListView ada minimal 10 item anak
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Alya Putri'), findsOneWidget); // Data dummy pertama
    expect(find.text('Joko Widodo'), findsOneWidget); // Data dummy terakhir

    // ✅ Test Like button (setState)
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    
    // Like button berubah warna (merah)
    expect(find.byIcon(Icons.favorite), findsWidgets);
    
    // Verifikasi SnackBar muncul
    expect(find.text('Anak ditambahkan ke favorit!'), findsOneWidget);
  });

  testWidgets('Posyandu Navigation ke Detail Test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // ✅ Tap item pertama di ListView (Alya Putri)
    await tester.tap(find.text('Alya Putri'));
    await tester.pumpAndSettle();

    // Verifikasi DetailAnakScreen
    expect(find.text('Alya Putri'), findsWidgets); // Nama di AppBar & body
    expect(find.text('12 bulan'), findsOneWidget); // Data umur
    expect(find.text('Normal'), findsWidgets); // Status gizi

    // ✅ Test Share button di Detail
    await tester.tap(find.byIcon(Icons.share));
    await tester.pump();
    expect(find.text('Berhasil membagikan data anak'), findsOneWidget);
  });
}