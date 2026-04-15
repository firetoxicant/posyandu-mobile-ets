class IbuHamil {
  final String nama;
  final String tempatLahir;
  final String tanggalLahir;
  final String alamat;
  final String telepon;
  final String email;
  final List<Balita> balita;
  final List<Pemeriksaan> riwayatIbu;

  IbuHamil({
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.telepon,
    required this.email,
    required this.balita,
    required this.riwayatIbu,
  });
}

class Balita {
  final String nama;
  final String tempatLahir;
  final String tanggalLahir;
  final String ibuKandung;
  final String alamat;
  final String statusGizi;
  final List<Pemeriksaan> riwayat;

  Balita({
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.ibuKandung,
    required this.alamat,
    required this.statusGizi,
    required this.riwayat,
  });
}

class Pemeriksaan {
  final String tanggal;
  final String jenis;
  final double tinggiBadan;
  final double beratBadan;
  final String tekananDarah;
  final double lingkarLenganAtas;
  final String status;
  final String jadwalSelanjutnya;
  final String catatan;

  Pemeriksaan({
    required this.tanggal,
    required this.jenis,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.tekananDarah,
    required this.lingkarLenganAtas,
    required this.status,
    required this.jadwalSelanjutnya,
    required this.catatan,
  });
}

final IbuHamil sampleUser = IbuHamil(
  nama: 'Siti Aminah',
  tempatLahir: 'Bandung',
  tanggalLahir: '12 Mei 1995',
  alamat: 'Jl. Melati No. 12, Bandung',
  telepon: '081234567890',
  email: 'siti.aminah@example.com',
  balita: [
    Balita(
      nama: 'Alya Putri',
      tempatLahir: 'Bandung',
      tanggalLahir: '20 April 2023',
      ibuKandung: 'Siti Aminah',
      alamat: 'Jl. Melati No. 12, Bandung',
      statusGizi: 'Normal',
      riwayat: [
        Pemeriksaan(
          tanggal: '15 Maret 2024',
          jenis: 'Balita',
          tinggiBadan: 76.0,
          beratBadan: 9.4,
          tekananDarah: '90/60 mmHg',
          lingkarLenganAtas: 16.0,
          status: 'Sehat',
          jadwalSelanjutnya: '15 Mei 2024',
          catatan: 'Perkembangan tumbuh kembang normal.',
        ),
        Pemeriksaan(
          tanggal: '20 Februari 2024',
          jenis: 'Balita',
          tinggiBadan: 74.0,
          beratBadan: 9.0,
          tekananDarah: '90/60 mmHg',
          lingkarLenganAtas: 15.8,
          status: 'Sehat',
          jadwalSelanjutnya: '15 Maret 2024',
          catatan: 'Anak aktif dan nafsu makan baik.',
        ),
      ],
    ),
  ],
  riwayatIbu: [
    Pemeriksaan(
      tanggal: '12 Maret 2024',
      jenis: 'Ibu Hamil',
      tinggiBadan: 161.0,
      beratBadan: 68.0,
      tekananDarah: '112/72 mmHg',
      lingkarLenganAtas: 28.5,
      status: 'Sehat',
      jadwalSelanjutnya: '10 April 2024',
      catatan: 'Kehamilan sehat, anemia terkontrol.',
    ),
    Pemeriksaan(
      tanggal: '10 Februari 2024',
      jenis: 'Ibu Hamil',
      tinggiBadan: 161.0,
      beratBadan: 65.0,
      tekananDarah: '118/75 mmHg',
      lingkarLenganAtas: 28.0,
      status: 'Waspada',
      jadwalSelanjutnya: '12 Maret 2024',
      catatan: 'Perlu kontrol asupan zat besi.',
    ),
    Pemeriksaan(
      tanggal: '10 Januari 2024',
      jenis: 'Ibu Hamil',
      tinggiBadan: 161.0,
      beratBadan: 62.5,
      tekananDarah: '120/80 mmHg',
      lingkarLenganAtas: 27.8,
      status: 'Sehat',
      jadwalSelanjutnya: '10 Februari 2024',
      catatan: 'Kondisi umum baik, lanjutkan olahraga ringan.',
    ),
  ],
);
