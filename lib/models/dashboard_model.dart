class DashboardModel {
  final ValidasiLogistik validasiLogistik;
  final ValidasiMobile validasiMobile;
  final ValidasiAPK validasiAPK;
  final ValidasiKampanye validasiKampanye;

  DashboardModel({
    required this.validasiLogistik,
    required this.validasiMobile,
    required this.validasiAPK,
    required this.validasiKampanye,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      validasiLogistik: ValidasiLogistik.fromJson(json['validasi_logistik']),
      validasiMobile: ValidasiMobile.fromJson(json['validasi_mobile']),
      validasiAPK: ValidasiAPK.fromJson(json['validasi_apk']),
      validasiKampanye: ValidasiKampanye.fromJson(json['validasi_kampanye']),
    );
  }
}

class ValidasiLogistik {
  final int total;
  final int valid;
  final int invalid;

  ValidasiLogistik(
      {required this.total, required this.valid, required this.invalid});

  factory ValidasiLogistik.fromJson(Map<String, dynamic> json) {
    return ValidasiLogistik(
      total: json['total'],
      valid: json['valid'],
      invalid: json['invalid'],
    );
  }
}

class ValidasiMobile {
  final int total;
  final int valid;
  final int invalid;

  ValidasiMobile(
      {required this.total, required this.valid, required this.invalid});

  factory ValidasiMobile.fromJson(Map<String, dynamic> json) {
    return ValidasiMobile(
      total: json['total'],
      valid: json['valid'],
      invalid: json['invalid'],
    );
  }
}

class ValidasiAPK {
  final int total;
  final int valid;
  final int invalid;

  ValidasiAPK(
      {required this.total, required this.valid, required this.invalid});

  factory ValidasiAPK.fromJson(Map<String, dynamic> json) {
    return ValidasiAPK(
      total: json['total'],
      valid: json['valid'],
      invalid: json['invalid'],
    );
  }
}

class ValidasiKampanye {
  final int total;
  final int valid;
  final int invalid;

  ValidasiKampanye(
      {required this.total, required this.valid, required this.invalid});

  factory ValidasiKampanye.fromJson(Map<String, dynamic> json) {
    return ValidasiKampanye(
      total: json['total'],
      valid: json['valid'],
      invalid: json['invalid'],
    );
  }
}
