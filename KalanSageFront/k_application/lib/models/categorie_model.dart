<<<<<<< HEAD


=======
>>>>>>> 6044997 (repusher)
class CategorieModel {
  final int id;
  final String nomCategorie;
  final String description;
<<<<<<< HEAD
=======
  int moduleCount;
>>>>>>> 6044997 (repusher)

  CategorieModel({
    required this.id,
    required this.nomCategorie,
    required this.description,
<<<<<<< HEAD
=======
    required this.moduleCount,
>>>>>>> 6044997 (repusher)
  });

  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
<<<<<<< HEAD
      id: json['idCategorie'],
      nomCategorie: json['nomCategorie'],
      description: json['description'],
    );
  }
}
=======
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
>>>>>>> 6044997 (repusher)
