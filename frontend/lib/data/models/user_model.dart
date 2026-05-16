class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["user"]["_id"],

      name: json["user"]["name"],

      email: json["user"]["email"],

      token: json["token"],
    );
  }
}
