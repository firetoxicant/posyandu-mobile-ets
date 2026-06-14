import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/posko_provider.dart';

class ManajemenKaderScreen extends StatefulWidget {
  const ManajemenKaderScreen({super.key});

  @override
  State<ManajemenKaderScreen> createState() => _ManajemenKaderScreenState();
}

class _ManajemenKaderScreenState extends State<ManajemenKaderScreen> {
  @override
  void initState() {
    super.initState();
    // Tarik data Kader dan Posko saat layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchSemuaKader();
      context.read<PoskoProvider>().fetchPosko();
    });
  }

  void _tampilkanFormTambah(BuildContext context) {
    final namaCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String? selectedPoskoId; // Menyimpan ID Posko yang dipilih

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Agar dropdown bisa di-update di dalam dialog
          builder: (context, setStateDialog) {
            final poskoList = context.read<PoskoProvider>().listPosko;

            return AlertDialog(
              title: const Text('Tambah Akun Kader'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaCtrl,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    ),
                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email Login'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: passCtrl,
                      decoration: const InputDecoration(labelText: 'Password (min. 6 karakter)'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    // Dropdown Pilih Posko
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Tugaskan ke Posko'),
                      value: selectedPoskoId,
                      items: poskoList.map((posko) {
                        return DropdownMenuItem(
                          value: posko.id,
                          child: Text(posko.namaPosko),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedPoskoId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (namaCtrl.text.isNotEmpty && 
                        emailCtrl.text.isNotEmpty && 
                        passCtrl.text.isNotEmpty && 
                        selectedPoskoId != null) {
                      
                      // Tampilkan loading snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuat akun kader...')),
                      );

                      bool sukses = await context.read<UserProvider>().tambahKader(
                        namaCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                        selectedPoskoId!,
                      );
                      
                      if (!context.mounted) return;
                      Navigator.pop(context); // Tutup dialog

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(sukses ? 'Kader berhasil ditambahkan' : 'Gagal menambahkan kader'),
                          backgroundColor: sukses ? Colors.green : Colors.red,
                        ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kader'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormTambah(context),
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.listKader.isEmpty) {
            return const Center(child: Text('Belum ada data Kader.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userProvider.listKader.length,
            itemBuilder: (context, index) {
              final kader = userProvider.listKader[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.medical_services, color: Colors.white),
                  ),
                  title: Text(kader.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(kader.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      userProvider.hapusKader(kader.id);
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