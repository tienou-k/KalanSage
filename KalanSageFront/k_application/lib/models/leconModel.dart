class LeconModel {
  final int id;
  final String title;
  final String description;
  final String duration;
  final String videoUrl;
  final int moduleId;

  LeconModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    this.videoUrl = '',
    required this.moduleId,
  });

  // Factory method to create a LeconModel from JSON (for API response)
  factory LeconModel.fromJson(Map<String, dynamic> json) {
    return LeconModel(
      id: json['id'] ?? 0,
      title: json['titre'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      moduleId: json['moduleId'] ?? 0,
    );
  }

  // Convert LeconModel to JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'videoUrl': videoUrl,
      'moduleId': moduleId,
    };
  }
}
