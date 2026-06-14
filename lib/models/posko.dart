class PoskoModel {
  String id;
  String namaPosko;
  String alamat;

  PoskoModel({
    required this.id,
    required this.namaPosko,
    required this.alamat,
  });

  factory PoskoModel.fromMap(Map<String, dynamic> data, String documentId) {
    return PoskoModel(
      id: documentId,
      namaPosko: data['namaPosko'] ?? '',
      alamat: data['alamat'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaPosko': namaPosko,
      'alamat': alamat,
    };
  }
}