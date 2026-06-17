import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/user_provider.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedPoskoId;
  bool _isUpdating = false;

  Future<void> _updatePosko(String userId, String poskoId) async {
    setState(() => _isUpdating = true);
    try {
      // Update di Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'poskoId': poskoId,
      });
      
      // Update data di UserProvider (Anda mungkin perlu menambahkan fungsi fetchUser ulang di provider)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Posko berhasil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan posko')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;

    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(user.namaLengkap, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text(user.email, style: const TextStyle(color: Colors.grey)),
          ),
          Center(
            child: Chip(label: Text(user.role.toUpperCase())),
          ),
          const Divider(height: 40, thickness: 1),

          // FITUR KHUSUS ORANG TUA
          if (user.role == 'orangtua') ...[
            const Text('Posko Anda saat ini:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            if (user.poskoId == null || user.poskoId == '')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Belum memilih posko. Silakan pilih posko terdekat untuk mendapatkan informasi jadwal dan kegiatan posyandu.'),
                  const SizedBox(height: 12),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('posko').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const LinearProgressIndicator();
                      
                      final List<DropdownMenuItem<String>> poskoItems = snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc['namaPosko'] ?? 'Posko Tanpa Nama'),
                        );
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            hint: const Text('Pilih Posko Terdekat'),
                            value: user.poskoId == '' || user.poskoId == null ? null : user.poskoId,
                            items: poskoItems,
                            onChanged: (value) {
                              setState(() {
                                _selectedPoskoId = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Konsultasikan pemilihan posko dengan kader di posko terdekat.',
                                  style: TextStyle(color: Colors.orange, fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_selectedPoskoId != null && _selectedPoskoId != user.poskoId)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isUpdating ? null : () => _updatePosko(user.id, _selectedPoskoId!),
                                child: _isUpdating 
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Simpan Pilihan Posko'),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              )
            else
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('posko').doc(user.poskoId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const LinearProgressIndicator();
                  if (!snapshot.hasData || !snapshot.data!.exists) return const Text('Posko tidak ditemukan.');

                  final poskoData = snapshot.data!.data() as Map<String, dynamic>;
                  return Text(poskoData['namaPosko'] ?? 'Nama Posko tidak tersedia', style: const TextStyle(fontSize: 16));
                },
              ),
            // Mengambil daftar Posko dari Firestore Collection 'posko'
            
            const Divider(height: 40, thickness: 1),
          ],

          // Tombol Logout untuk semua role
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar (Logout)'),
              onPressed: () {
                context.read<UserProvider>().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen())
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}