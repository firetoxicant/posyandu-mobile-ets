class JadwalPosyandu {
  final String id;
  final String lokasi;
  final DateTime tanggal;
  final String jam;   // format HH:mm
  final String deskripsi;

  JadwalPosyandu({
    required this.id,
    required this.lokasi,
    required this.tanggal,
    required this.jam,
    this.deskripsi = '',
  });
}