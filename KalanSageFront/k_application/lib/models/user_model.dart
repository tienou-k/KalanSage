

class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});

  // Convert JSON data from the API into a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['nom'],
      email: json['email'],
      role: json['role'],
    );
  }

  // Convert UserModel into JSON to send to the API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': name,
      'email': email,
      'role': role,
    };
  }
}
