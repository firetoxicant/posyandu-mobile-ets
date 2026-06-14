import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posko_provider.dart';

class ManajemenPoskoScreen extends StatefulWidget {
  const ManajemenPoskoScreen({super.key});

  @override
  State<ManajemenPoskoScreen> createState() => _ManajemenPoskoScreenState();
}

class _ManajemenPoskoScreenState extends State<ManajemenPoskoScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil data posko dari Firebase saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PoskoProvider>().fetchPosko();
    });
  }

  // Fungsi untuk menampilkan Form Tambah Posko (Pop-up Dialog)
  void _tampilkanFormTambah(BuildContext context) {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Posko Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Posko'),
              ),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat Posko'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (namaController.text.isNotEmpty && alamatController.text.isNotEmpty) {
                  final provider = context.read<PoskoProvider>();
                  bool sukses = await provider.tambahPosko(
                    namaController.text.trim(),
                    alamatController.text.trim(),
                  );
                  
                  if (!context.mounted) return;
                  Navigator.pop(context); // Tutup dialog

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(sukses ? 'Posko berhasil ditambah' : 'Gagal menambah posko'),
                      backgroundColor: sukses ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Posko'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      // Floating button untuk tambah data
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormTambah(context),
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // Memantau perubahan data pada PoskoProvider
      body: Consumer<PoskoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.listPosko.isEmpty) {
            return const Center(child: Text('Belum ada data posko. Silakan tambah.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.listPosko.length,
            itemBuilder: (context, index) {
              final posko = provider.listPosko[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(Icons.home_work, color: Color(0xFF1E88E5)),
                  ),
                  title: Text(posko.namaPosko, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(posko.alamat),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Konfirmasi hapus
                      bool confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Hapus Posko?'),
                          content: const Text('Data posko yang dihapus tidak bisa dikembalikan.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ) ?? false;

                      if (confirm && context.mounted) {
                        provider.hapusPosko(posko.id);
                      }
                    },
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