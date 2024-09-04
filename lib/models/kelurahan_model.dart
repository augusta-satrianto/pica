class KelurahanModel {
  int id;
  String code;
  String kecamatanCode;
  String name;
  String latitude;
  String longitude;

  KelurahanModel({
    required this.id,
    required this.code,
    required this.kecamatanCode,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory KelurahanModel.fromJson(Map<String, dynamic> json) {
    return KelurahanModel(
      id: json['id'],
      code: json['code'],
      kecamatanCode: json['kecamatan_code'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
