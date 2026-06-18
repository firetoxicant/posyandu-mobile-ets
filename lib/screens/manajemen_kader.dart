import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/posko_provider.dart';
import '../models/user.dart'; // Pastikan model UserModel di-import

class ManajemenKaderScreen extends StatefulWidget {
  const ManajemenKaderScreen({super.key});

  @override
  State<ManajemenKaderScreen> createState() => _ManajemenKaderScreenState();
}

class _ManajemenKaderScreenState extends State<ManajemenKaderScreen> {
  String? _selectedFilterPoskoId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchSemuaKader();
      context.read<PoskoProvider>().fetchPosko();
    });
  }

  // --- FORM 1: TAMBAH KADER ---
  void _tampilkanFormTambah(BuildContext context) {
    final namaCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String? selectedPoskoId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
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
                      Navigator.pop(context);

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
          },
        );
      },
    );
  }

  // --- FORM 2: EDIT/UPDATE KADER (BARU) ---
  void _tampilkanFormEdit(BuildContext context, UserModel kader) {
    // Isi otomatis textfield dengan nama kader yang lama
    final namaCtrl = TextEditingController(text: kader.namaLengkap);
    // Isi otomatis dropdown dengan id posko yang lama
    String? selectedPoskoId = kader.poskoId; 

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final poskoList = context.read<PoskoProvider>().listPosko;

            return AlertDialog(
              title: const Text('Edit Data Kader'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaCtrl,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Pindahkan ke Posko'),
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
                    if (namaCtrl.text.isNotEmpty && selectedPoskoId != null) {
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Memperbarui data kader...')),
                      );

                      // Panggil fungsi update di provider
                      bool sukses = await context.read<UserProvider>().updateKader(
                            kader.id,
                            namaCtrl.text.trim(),
                            selectedPoskoId!,
                          );

                      if (!context.mounted) return;
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(sukses ? 'Data kader berhasil diperbarui' : 'Gagal memperbarui data'),
                          backgroundColor: sukses ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final poskoProvider = context.watch<PoskoProvider>();

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
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFilterPoskoId,
              decoration: const InputDecoration(
                labelText: 'Filter Berdasarkan Posko',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.filter_alt, color: Color(0xFF1E88E5)),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Semua Posko'),
                ),
                ...poskoProvider.listPosko.map((posko) {
                  return DropdownMenuItem<String>(
                    value: posko.id,
                    child: Text(posko.namaPosko),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilterPoskoId = value;
                });
              },
            ),
          ),

          // Daftar Kader
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userProvider.listKader.isEmpty) {
                  return const Center(child: Text('Belum ada data Kader.'));
                }

                final kaderTerfilter = _selectedFilterPoskoId == null
                    ? userProvider.listKader
                    : userProvider.listKader
                        .where((kader) => kader.poskoId == _selectedFilterPoskoId)
                        .toList();

                if (kaderTerfilter.isEmpty) {
                  return const Center(child: Text('Tidak ada data Kader di posko ini.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kaderTerfilter.length,
                  itemBuilder: (context, index) {
                    final kader = kaderTerfilter[index];

                    final infoPosko = poskoProvider.listPosko.firstWhere(
                      (p) => p.id == kader.poskoId,
                    );
                    
                    String namaPoskoKader = infoPosko != dynamic ? infoPosko.namaPosko : 'Tanpa Posko';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.medical_services, color: Colors.white),
                        ),
                        title: Text(kader.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${kader.email}\nPosko: $namaPoskoKader'),
                        isThreeLine: true,
                        // --- PERUBAHAN: Mengubah trailing menjadi Row agar muat dua tombol ---
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol Edit (Biru)
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _tampilkanFormEdit(context, kader),
                            ),
                            // Tombol Hapus (Merah)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                userProvider.hapusKader(kader.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}