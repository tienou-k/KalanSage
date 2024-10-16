

class ModuleModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final int leconCount;
  final String imageUrl;
  final int quiz;
  final String iconUrl;
  int studentCount = 0;
  //
  final bool isCompleted;
  final bool isInProgress;
  late final bool isEnrolled;
   bool isBookmarked;

  ModuleModel({
    required this.id,
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
    String? title,
    double? price,
    String? description,
    int? leconCount,
    String? imageUrl,
    int? quiz,
    String? iconUrl,
    int? studentCount,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      leconCount: leconCount ?? this.leconCount,
      isCompleted: isCompleted,
      isInProgress: isInProgress,
      isBookmarked: isBookmarked,
      isEnrolled: isEnrolled,
      imageUrl: imageUrl ?? this.imageUrl,
      quiz: quiz ?? this.quiz,
      iconUrl: iconUrl ?? this.iconUrl,
    )..studentCount = studentCount ?? this.studentCount;
  }

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] != null ? json['id'] as int : 0,
      title: json['titre'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['prix'] != null ? (json['prix'] as num).toDouble() : 0.0),
      leconCount: (json['lecons'] != null && json['lecons'] is List)
          ? (json['lecons'] as List).length
          : 0,
      imageUrl: json['imageUrl'] ?? '',
      quiz: json['quiz'] != null ? json['quiz'] as int : 0,
      iconUrl: json['iconUrl'] ?? '',
      // Handle null values for booleans with null-coalescing operator
      isCompleted: json['isCompleted'] as bool? ?? false,
      isInProgress: json['isInProgress'] as bool? ?? false,
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  get image => null;

  get rating => null;

  get duration => null;
}
