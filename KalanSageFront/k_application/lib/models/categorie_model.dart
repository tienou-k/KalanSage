

class CategorieModel {
  final int id;
  final String nomCategorie;
  final String description;

  CategorieModel({
    required this.id,
    required this.nomCategorie,
    required this.description,
  });

  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      id: json['idCategorie'],
      nomCategorie: json['nomCategorie'],
      description: json['description'],
    );
  }
}
