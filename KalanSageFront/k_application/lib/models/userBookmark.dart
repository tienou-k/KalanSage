class UserBookmark {
  final int id;
  final int userId;
  final int moduleId;
  final String titre;
  final String description;
  final double prix;
  final String imageUrl;
  final DateTime bookmarkDate;


  UserBookmark(
      {required this.id,
      required this.userId,
      required this.moduleId,
      required this.titre,
      required this.description,
      required this.prix,
      required this.imageUrl,
      required this.bookmarkDate});

  factory UserBookmark.fromJson(Map<String, dynamic> json) {
    return UserBookmark(
      id: json['id'],
      userId: json['userId'],
      moduleId: json['moduleId'],
      titre: json['titre'],
      description: json['description'],
      prix: json['prix'],
      imageUrl: json['imageUrl'],
      bookmarkDate: DateTime.parse(json['bookmarkDate']),
    );
  }
}
