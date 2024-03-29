class AuthModel {
  int id;
  String name;
  String role;
  String token;

  AuthModel({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      name: json['name'],
      role: json['role'][0],
      token: json['token'],
    );
  }
}
