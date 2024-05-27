class DashboardModel {
  final Team team;
  final VerifikasiAPK verifikasiAPK;
  final VerifikasiKampanye verifikasiKampanye;
  final VerifikasiMobile verifikasiMobile;

  DashboardModel({
    required this.team,
    required this.verifikasiAPK,
    required this.verifikasiKampanye,
    required this.verifikasiMobile,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      team: Team.fromJson(json['team']),
      verifikasiAPK: VerifikasiAPK.fromJson(json['verifikasi_apk']),
      verifikasiKampanye:
          VerifikasiKampanye.fromJson(json['verifikasi_kampanye']),
      verifikasiMobile: VerifikasiMobile.fromJson(json['verifikasi_mobile']),
    );
  }
}

class Team {
  int? id;
  String? name;
  String? partai;
  String? provinsi;
  String? kabupaten;
  String? calon;
  String? status;
  String? fotoAtas;
  String? fotoBawah;
  String? visi1;
  String? visi2;
  String? visi3;
  String? visi4;
  String? visi5;
  String? misi1;
  String? misi2;
  String? misi3;
  String? misi4;
  String? misi5;
  String? colorHex;

  Team({
    this.id,
    this.name,
    this.partai,
    this.provinsi,
    this.kabupaten,
    this.calon,
    this.status,
    this.fotoAtas,
    this.fotoBawah,
    this.visi1,
    this.visi2,
    this.visi3,
    this.visi4,
    this.visi5,
    this.misi1,
    this.misi2,
    this.misi3,
    this.misi4,
    this.misi5,
    this.colorHex,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['team']['id'],
      name: json['team']['name'],
      partai: json['team']['partai'],
      provinsi: json['team']['provinsi'],
      kabupaten: json['team']['kabupaten'],
      calon: json['team']['calon'],
      status: json['team']['status'],
      fotoAtas: json['fotoAtas'],
      fotoBawah: json['fotoBawah'],
      visi1: json['team']['visi1'],
      visi2: json['team']['visi2'],
      visi3: json['team']['visi3'],
      visi4: json['team']['visi4'],
      visi5: json['team']['visi5'],
      misi1: json['team']['misi1'],
      misi2: json['team']['misi2'],
      misi3: json['team']['misi3'],
      misi4: json['team']['misi4'],
      misi5: json['team']['misi5'],
      colorHex: json['team']['colorHex'],
    );
  }
}

class VerifikasiAPK {
  final int total;
  final int valid;
  final int invalid;

  VerifikasiAPK(
      {required this.total, required this.valid, required this.invalid});

  factory VerifikasiAPK.fromJson(Map<String, dynamic> json) {
    return VerifikasiAPK(
      total: json['total'],
      valid: json['valid'],
      invalid: json['invalid'],
    );
  }
}

class VerifikasiKampanye {
  final int total;
  final int valid;
  final int invalid;

  VerifikasiKampanye(
      {required this.total, required this.valid, required this.invalid});

  factory VerifikasiKampanye.fromJson(Map<String, dynamic> json) {
    return VerifikasiKampanye(
      total: json['total'],
      valid: json['valid'],
      invalid: json['invalid'],
    );
  }
}

class VerifikasiMobile {
  final int total;
  final int valid;
  final int invalid;

  VerifikasiMobile(
      {required this.total, required this.valid, required this.invalid});

  factory VerifikasiMobile.fromJson(Map<String, dynamic> json) {
    return VerifikasiMobile(
      total: json['total'],
      valid: json['valid'],
      invalid: json['invalid'],
    );
  }
}
