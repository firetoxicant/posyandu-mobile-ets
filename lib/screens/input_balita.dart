import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/balita.dart';
import '../providers/balita_provider.dart';
import '../providers/user_provider.dart';

class InputBalitaScreen extends StatefulWidget {
  final BalitaModel? balita; // mode edit jika tidak null
  const InputBalitaScreen({super.key, this.balita});

  @override
  State<InputBalitaScreen> createState() => _InputBalitaScreenState();
}

class _InputBalitaScreenState extends State<InputBalitaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaCtrl;
  DateTime? _tanggalLahir;
  String _jenisKelamin = 'Laki-laki';
  String? _selectedParentId;

  bool get isEdit => widget.balita != null;

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.balita?.namaLengkap ?? '');
    _tanggalLahir = widget.balita?.tanggalLahir;
    _jenisKelamin = widget.balita?.jenisKelamin ?? 'Laki-laki';
    _selectedParentId = widget.balita?.orangTuaId;
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _tanggalLahir = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal lahir')),
      );
      return;
    }
    if (_selectedParentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih orang tua')),
      );
      return;
    }

    final provider = context.read<BalitaProvider>();
    final newBalita = BalitaModel(
      id: isEdit ? widget.balita!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      namaLengkap: _namaCtrl.text.trim(),
      orangTuaId: _selectedParentId!,
      tanggalLahir: _tanggalLahir!,
      jenisKelamin: _jenisKelamin,
      poskoId: provider.listBalita.firstWhere((b) => b.id == widget.balita?.id)?.poskoId ?? '',
    );

    if (isEdit) {
      provider.updateBalita(widget.balita!.id, newBalita);
    } else {
      provider.tambahBalita(
        namaLengkap: newBalita.namaLengkap,
        tanggalLahir: newBalita.tanggalLahir,
        jenisKelamin: newBalita.jenisKelamin,
        orangTuaId: newBalita.orangTuaId,
        poskoId: newBalita.poskoId,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final orangtuaList = context.watch<UserProvider>().orangtuaUsers;
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Balita' : 'Input Balita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Balita'),
                validator: (v) => v!.trim().isEmpty ? 'Harus diisi' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _jenisKelamin,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['Laki-laki', 'Perempuan'].map((jk) {
                  return DropdownMenuItem(value: jk, child: Text(jk));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _jenisKelamin = v);
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
                  child: Text(_tanggalLahir != null ? df.format(_tanggalLahir!) : 'Pilih tanggal'),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedParentId,
                decoration: const InputDecoration(labelText: 'Orang Tua'),
                items: orangtuaList.map((u) {
                  return DropdownMenuItem(value: u.id, child: Text(u.namaLengkap));
                }).toList(),
                onChanged: (v) {
                  setState(() => _selectedParentId = v);
                },
                validator: (v) => v == null ? 'Pilih orang tua' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}