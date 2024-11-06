class UserModel {
  final int id;
  final String name;
  final String lastname;
  final String username;
  final String email;
  final String phone;
  final String? role;
  final String imagePath;
  final String dateInscription;

  UserModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phone,
    this.role,
    required this.imagePath,
    required this.dateInscription,
  });

  // Convert JSON data from the API into a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['nom'] ?? '',
      lastname: json['prenom'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['telephone'] ?? '',
      role: json['role'] ?? '',
      imagePath: json['imagePath'] ?? '',
      dateInscription: json['dateInscription'] ?? '',
    );
  }

  // Convert UserModel into JSON to send to the API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': name,
      'email': email,
      'telephone': phone,
      'role': role,
      'imagePath': imagePath,
    };
  }
}
