class PaslonModel {
  int id;
  int teamId;
  int noUrut;
  String namaCalon;

  PaslonModel({
    required this.id,
    required this.teamId,
    required this.noUrut,
    required this.namaCalon,
  });

  factory PaslonModel.fromJson(Map<String, dynamic> json) {
    return PaslonModel(
      id: json['id'],
      teamId: json['team_id'],
      noUrut: json['no_urut'],
      namaCalon: json['nama_calon'],
    );
  }
}
