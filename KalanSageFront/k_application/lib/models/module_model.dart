class ModuleModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final int lessonCount;
  final String imageUrl;
  final int quiz;
  final String iconUrl;

  ModuleModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.lessonCount,
    required this.imageUrl,
    required this.quiz,
    required this.iconUrl,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] != null ? json['id'] as int : 0,
      title: json['titre'] as String,
      description: json['description'] as String,
      price: (json['prix'] != null ? (json['prix'] as num).toDouble() : 0.0),
      lessonCount: json['leconCount'] != null ? json['leconCount'] as int : 0,
      imageUrl: json['imageUrl'] ?? '',
      quiz: json['quiz'] != null ? json['quiz'] as int : 0,
      iconUrl: json['iconUrl'] ?? '',
    );
  }
}
