
class LeconModel {
  final int id;
  final String title;
  final String description;
  final String duration;
  final String videoPath;
  final int moduleId;
  final bool isLocked;
  final bool isCompleted; 

  LeconModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    this.videoPath = '',
    required this.moduleId,
    this.isLocked = false, 
    this.isCompleted = false,
  });

  // Factory method to create a LeconModel from JSON (for API response)
  factory LeconModel.fromJson(Map<String, dynamic> json) {
    return LeconModel(
      id: json['id'] ?? 0,
      title: json['titre'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      videoPath: json['videoUrl'] ?? '',
      moduleId: json['moduleId'] ?? 0,
      isLocked: json['isLocked'] ?? false, 
      isCompleted: json['isCompleted'] ?? false  
    );
  }

  bool get isUnlocked {
    // TODO: implement isUnlocked
    throw UnimplementedError();
  }

  // Convert LeconModel to JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': title,
      'description': description,
      'duration': duration,
      'videoUrl': videoPath,
      'moduleId': moduleId,
      'isLocked': isLocked,
      'isCompleted': isCompleted,
    };
  }
}
