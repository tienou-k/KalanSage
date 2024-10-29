class UserBookmark {
  final int id;
  final int userId;
  final int moduleId;
  final DateTime bookmarkDate;

  UserBookmark(
      {required this.id,
      required this.userId,
      required this.moduleId,
      required this.bookmarkDate});

  factory UserBookmark.fromJson(Map<String, dynamic> json) {
    return UserBookmark(
      id: json['id'],
      userId: json['userId'],
      moduleId: json['moduleId'],
      bookmarkDate: DateTime.parse(json['bookmarkDate']),
    );
  }
}
