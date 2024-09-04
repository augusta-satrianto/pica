class AuthModel {
  int id;
  String name;
  String role;
  String token;
  int teamId;
  String kabupatenCode;
  String kecamatanCode;
  String kecamatanName;
  String? kelurahanCode;
  String? kelurahanName;
  String colorHex;

  AuthModel(
      {required this.id,
      required this.name,
      required this.role,
      required this.token,
      required this.teamId,
      required this.kabupatenCode,
      required this.kecamatanCode,
      required this.kecamatanName,
      this.kelurahanCode,
      this.kelurahanName,
      required this.colorHex});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      name: json['name'],
      role: json['role'][0],
      token: json['token'],
      teamId: json['team_id'],
      kabupatenCode: json['kabupaten_code'],
      kecamatanCode: json['kecamatan_code'],
      kecamatanName: json['kecamatan']['name'],
      kelurahanCode: json['kelurahan_code'],
      kelurahanName:
          json['kelurahan'] == null ? null : json['kelurahan']['name'],
      colorHex: json['team']['colorHex'],
      // colorHex: '#FF0000',
    );
  }
}
