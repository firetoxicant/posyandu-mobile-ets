import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/jadwal_provider.dart';
import '../providers/user_provider.dart';

class JadwalPosyanduScreen extends StatefulWidget {
  const JadwalPosyanduScreen({super.key});

  @override
  State<JadwalPosyanduScreen> createState() => _JadwalPosyanduScreenState();
}

class _JadwalPosyanduScreenState extends State<JadwalPosyanduScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final poskoId = context.read<UserProvider>().currentUser?.poskoId ?? '';
      context.read<JadwalProvider>().fetchJadwal(poskoId);
    });
  }

  void _tampilkanFormTambah(BuildContext context, String poskoId) {
    final kegiatanCtrl = TextEditingController();
    final lokasiCtrl = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Tambah Jadwal Posyandu'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: kegiatanCtrl,
                      decoration: const InputDecoration(labelText: 'Nama Kegiatan (misal: Imunisasi)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: lokasiCtrl,
                      decoration: const InputDecoration(labelText: 'Lokasi (misal: Balai RW 01)'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(selectedDate == null 
                            ? 'Pilih Tanggal' 
                            : DateFormat('dd MMM yyyy').format(selectedDate!)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month, color: Colors.blue),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(), // Jadwal tidak bisa di masa lalu
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              setStateDialog(() => selectedDate = date);
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                ElevatedButton(
                  onPressed: () async {
                    if (kegiatanCtrl.text.isNotEmpty && selectedDate != null) {
                      bool sukses = await context.read<JadwalProvider>().tambahJadwal(
                        poskoId: poskoId,
                        tanggal: selectedDate!,
                        kegiatan: kegiatanCtrl.text.trim(),
                        lokasi: lokasiCtrl.text.trim(),
                      );
                      if (sukses) {
                        context.read<JadwalProvider>().fetchJadwal(poskoId);
                      }
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(sukses ? 'Jadwal ditambahkan' : 'Gagal menambah jadwal'))
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final poskoId = context.read<UserProvider>().currentUser?.poskoId ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Posyandu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormTambah(context, poskoId),
        child: const Icon(Icons.add),
      ),
      body: Consumer<JadwalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.listJadwal.isEmpty) return const Center(child: Text('Belum ada jadwal.'));

          return ListView.builder(
            itemCount: provider.listJadwal.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final jadwal = provider.listJadwal[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.blue, size: 40),
                  title: Text(jadwal.kegiatan, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${DateFormat('dd MMMM yyyy').format(jadwal.tanggal)}'),
                      Text('Lokasi: ${jadwal.lokasi}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.hapusJadwal(jadwal.id, poskoId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}