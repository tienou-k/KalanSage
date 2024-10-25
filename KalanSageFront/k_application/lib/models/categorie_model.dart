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
      case 'Design':
        return 'assets/icons/art_design.svg';
        case 'Marketing':
        return 'assets/icons/marketing.svg';
        case 'Communication':
        return 'assets/icons/com.svg';
        case 'Finance':
        return 'assets/icons/finanace.svg';
        case 'Redaction de contenu':
        return 'assets/icons/content.svg';
        case 'Photographie':
        return 'assets/icons/photo.svg';
        case 'Reseau':
        return 'assets/icons/reseau.svg';
      default:
        return 'assets/icons/default_icon.svg';
    }
  }
}