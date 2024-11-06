class LeconModel {
  final int id;
  final String titre;
  final String description;
  final String contenu;
  final String videoPath;
  final int moduleId;
  final bool isLocked;
  final bool isCompleted;
  final QuizModel? quiz;

  LeconModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.contenu,
    required this.videoPath,
    required this.moduleId,
    required this.isLocked,
    required this.isCompleted,
    this.quiz,
  });

  // Factory method to create a LeconModel from JSON (for API response)
  factory LeconModel.fromJson(Map<String, dynamic> json) {
    return LeconModel(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      contenu: json['contenu'] ?? '',
      videoPath: json['videoPath'] ?? '',
      moduleId: json['moduleId'] ?? 0,
      // Check if json['quiz'] is not null before creating QuizModel
      quiz: json['quiz'] != null ? QuizModel.fromJson(json['quiz']) : null,
      isLocked: json['isLocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'LeconModel(id: $id, titre: $titre, description: $description, '
        'contenu: $contenu, videoPath: $videoPath, moduleId: $moduleId, '
        'isLocked: $isLocked, isCompleted: $isCompleted, quiz: ${quiz?.toString()})';
  }
}

class QuizModel {
  final int id;
  final String questions;

  QuizModel({
    required this.id,
    required this.questions,
  });

  // Factory method to create a QuizModel from JSON (for API response)
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? 0,
      questions: json['questions'] ?? '',
    );
  }
}
