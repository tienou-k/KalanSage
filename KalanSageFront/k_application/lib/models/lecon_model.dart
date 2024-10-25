class LeconModel {
  final int id;
  final String titre;
  final String description;
  final String contenu;
  final String videoPath;
  final int moduleId;
  final bool isLocked;
  final bool isCompleted;
  final QuizModel quiz;

  LeconModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.contenu,
    required this.videoPath,
    required this.moduleId,
    required this.isLocked,
    required this.isCompleted,
    required this.quiz,
  });

  // Factory method to create a LeconModel from JSON (for API response)
  factory LeconModel.fromJson(Map<String, dynamic> json) {
    return LeconModel(
        id: json['id'] ?? 0,
        titre: json['titre'] ?? '',
        description: json['description'] ?? '',
        contenu: json['contenu'] ?? '',
        videoPath: json['videoUrl']?.toString() ?? '',
        moduleId: json['moduleId'] ?? 0,
        quiz: QuizModel.fromJson(json['quiz']),
        isLocked: json['isLocked'] ?? false,
        isCompleted: json['isCompleted'] ?? false);
  }
}

class QuizModel {
  final int id;
  final String questions;

  QuizModel({
    required this.id,
    required this.questions,
  });

  // Factory method to create a LeconModel from JSON (for API response)
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? 0,
      questions: json['questions'] ?? '',
    );
  }
}
