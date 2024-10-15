class CategorieModel {
  final int id;
  final String nomCategorie;
  final String description;
  int moduleCount;

  CategorieModel({
    required this.id,
    required this.nomCategorie,
    required this.description,
    required this.moduleCount,
  });

  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      id: json['idCategorie'] as int,
      nomCategorie: json['nomCategorie'] as String,
      description: json['description'] as String,
      moduleCount: json['moduleCount'] ?? 0, 
    );
  }

  String getIconPath() {
    switch (nomCategorie) {
      case 'Programming':
        return 'assets/icons/dev.svg';
      case 'Data Science':
        return 'assets/icons/science.svg';
      case 'Design Graphique':
        return 'assets/icons/photo.svg';
      default:
        return 'assets/icons/default_icon.svg';
    }
  }
}