class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
  });

  Map<String, String> toJson() {
    return {
      "id": id.toString(),
      "name": name,
      "username": username,
      "email": email,
      "role": role,
    };
  }
}
