class UserModel {
  final int id;
  final String name;
  final String email;
<<<<<<< HEAD
  final String role;
  final String imagePath;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.imagePath});
=======
  final String phone;
  final String? role;
  final String imagePath;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role,
    required this.imagePath,
  });
>>>>>>> 6044997 (repusher)

  // Convert JSON data from the API into a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
<<<<<<< HEAD
        id: json['id'],
        name: json['nom'],
        email: json['email'],
        role: json['role'],
        imagePath: json['imagePath']);
=======
      id: json['id'] ?? 0,
      name: json['nom'] ?? '',
      email: json['email'] ?? '',
      phone: json['telephone'] ?? '',
      role: json['role'] ?? '',
      imagePath: json['imagePath'] ?? '',
    )
>>>>>>> 6044997 (repusher)
  }

  // Convert UserModel into JSON to send to the API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': name,
      'email': email,
<<<<<<< HEAD
=======
      'telephone': phone, 
>>>>>>> 6044997 (repusher)
      'role': role,
      'imagePath': imagePath,
    };
  }
}
