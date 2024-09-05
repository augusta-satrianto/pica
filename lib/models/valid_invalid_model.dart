class VerifikasiModel {
  int id;
  String name;
  String telepon;

  VerifikasiModel({
    required this.id,
    required this.name,
    required this.telepon,
  });

  factory VerifikasiModel.fromJson(Map<String, dynamic> json) {
    return VerifikasiModel(
      id: json['id'],
      name: json['pendukung'] != null ? json['pendukung']['nama'] : json['nkk'],
      telepon: json['telp_admin'],
    );
  }
}
