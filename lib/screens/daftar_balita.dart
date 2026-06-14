import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/balita_provider.dart';
import '../providers/user_provider.dart';
import 'detail_balita.dart';

class DaftarBalitaScreen extends StatefulWidget {
  const DaftarBalitaScreen({super.key});

  @override
  State<DaftarBalitaScreen> createState() => _DaftarBalitaScreenState();
}

class _DaftarBalitaScreenState extends State<DaftarBalitaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. Ambil poskoId milik Kader yang sedang login
      final poskoId = context.read<UserProvider>().currentUser?.poskoId ?? '';
      
      // 2. Tarik data balita khusus di posko tersebut
      context.read<BalitaProvider>().fetchBalitaByPosko(poskoId);
      
      // 3. Tarik data daftar orang tua untuk pilihan di form
      context.read<BalitaProvider>().fetchOrangTua();
    });
  }

  void _tampilkanFormTambah(BuildContext context, String poskoIdKader) {
    final namaCtrl = TextEditingController();
    DateTime? selectedDate;
    String jenisKelamin = 'Laki-laki';
    String? selectedOrangTuaId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final listOrangTua = context.read<BalitaProvider>().listOrangTua;

            return AlertDialog(
              title: const Text('Tambah Data Balita'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap Anak')),
                    const SizedBox(height: 16),
                    
                    // Pemilih Tanggal Lahir
                    Row(
                      children: [
                        Expanded(
                          child: Text(selectedDate == null 
                            ? 'Pilih Tanggal Lahir' 
                            : 'Tgl Lahir: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month, color: Colors.blue),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setStateDialog(() => selectedDate = date);
                            }
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pemilih Jenis Kelamin
                    DropdownButtonFormField<String>(
                      value: jenisKelamin,
                      decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                      items: ['Laki-laki', 'Perempuan'].map((jk) => DropdownMenuItem(value: jk, child: Text(jk))).toList(),
                      onChanged: (val) => setStateDialog(() => jenisKelamin = val!),
                    ),
                    const SizedBox(height: 8),

                    // Pemilih Orang Tua
                    DropdownButtonFormField<String>(
                      value: selectedOrangTuaId,
                      decoration: const InputDecoration(labelText: 'Pilih Orang Tua'),
                      items: listOrangTua.map((ortu) => DropdownMenuItem(value: ortu.id, child: Text(ortu.namaLengkap))).toList(),
                      onChanged: (val) => setStateDialog(() => selectedOrangTuaId = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                ElevatedButton(
                  onPressed: () async {
                    if (namaCtrl.text.isNotEmpty && selectedDate != null && selectedOrangTuaId != null) {
                      bool sukses = await context.read<BalitaProvider>().tambahBalita(
                        namaLengkap: namaCtrl.text.trim(),
                        tanggalLahir: selectedDate!,
                        jenisKelamin: jenisKelamin,
                        orangTuaId: selectedOrangTuaId!,
                        poskoId: poskoIdKader,
                      );
                      
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(sukses ? 'Balita ditambahkan' : 'Gagal menyimpan'),
                          backgroundColor: sukses ? Colors.green : Colors.red,
                        )
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi form!')));
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
    final poskoIdKader = context.read<UserProvider>().currentUser?.poskoId ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Balita')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormTambah(context, poskoIdKader),
        child: const Icon(Icons.add),
      ),
      body: Consumer<BalitaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.listBalita.isEmpty) return const Center(child: Text('Belum ada data balita di posko ini.'));

          return ListView.builder(
            itemCount: provider.listBalita.length,
            itemBuilder: (context, index) {
              final balita = provider.listBalita[index];
              return ListTile(
                leading: CircleAvatar(child: Text(balita.namaLengkap[0])),
                title: Text(balita.namaLengkap),
                subtitle: Text('Kelamin: ${balita.jenisKelamin}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailBalitaScreen(balita: balita)),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.hapusBalita(balita.id, poskoIdKader),
                ),
              );
            },
          );
        },
      ),
    );
  }
}