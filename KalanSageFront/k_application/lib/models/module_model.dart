class ModuleModel {
  final int id;
  final String userId;
  final String title;
  final double price;
  final String description;
  final int leconCount;
  final String imageUrl;
  final int quiz;
  final String iconUrl;
  int studentCount = 0;
  final bool isCompleted;
  final bool isInProgress;
  late final bool isEnrolled;
  bool isBookmarked;

  ModuleModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.price,
    required this.description,
    required this.leconCount,
    required this.imageUrl,
    required this.quiz,
    required this.iconUrl,
    required this.isCompleted,
    required this.isInProgress,
    required this.isBookmarked,
    required this.isEnrolled,
  });

  // Add a method to update the student count
  ModuleModel copyWith({
    int? id,
    String? userId,
    String? title,
    double? price,
    String? description,
    int? leconCount,
    String? imageUrl,
    int? quiz,
    String? iconUrl,
    int? studentCount,
    bool? isCompleted,
    bool? isInProgress,
    bool? isEnrolled,
    bool? isBookmarked,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      leconCount: leconCount ?? this.leconCount,
      isCompleted: isCompleted ?? this.isCompleted,
      isInProgress: isInProgress ?? this.isInProgress,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      imageUrl: imageUrl ?? this.imageUrl,
      quiz: quiz ?? this.quiz,
      iconUrl: iconUrl ?? this.iconUrl,
    )..studentCount = studentCount ?? this.studentCount;
  }

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      title: json['titre'] ?? '',
      description: json['description'] ?? '',
      price: (json['prix'] != null ? (json['prix'] as num).toDouble() : 0.0),
      leconCount:
          (json['lecons'] is List) ? (json['lecons'] as List).length : 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      quiz: json['quiz'] ?? 0,
      iconUrl: json['iconUrl'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      isInProgress: json['isInProgress'] ?? false,
      isEnrolled: json['isEnrolled'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  get skills => null;
}
