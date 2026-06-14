class UserModel {
  String id;
  String namaLengkap;
  String email;
  String role; // "admin", "kader", "orangtua"
  String? poskoId; // Null untuk admin, wajib isi untuk kader/orangtua

  UserModel({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.role,
    this.poskoId,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      namaLengkap: data['namaLengkap'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'orangtua',
      poskoId: data['poskoId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLengkap': namaLengkap,
      'email': email,
      'role': role,
      'poskoId': poskoId,
    };
  }
}