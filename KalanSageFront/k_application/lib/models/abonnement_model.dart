class Abonnement {
  final int idAbonnement;
  final String typeAbonnement;
  final String description;
  final double prix; 
  final DateTime dateExpiration;
  final bool statut;

  Abonnement({
    required this.idAbonnement,
    required this.typeAbonnement,
    required this.description,
    required this.prix,
    required this.dateExpiration,
    required this.statut,
  });

  factory Abonnement.fromJson(Map<String, dynamic> json) {
    print('Parsing Abonnement from JSON: $json'); // Debug line

    return Abonnement(
      idAbonnement: json['idAbonnement'] ?? 0,
      typeAbonnement: json['typeAbonnement'] ?? '',
      description: json['description'] ?? '',
      prix: (json['prix'] is num)
          ? (json['prix'] as num).toDouble()
          : 0.0, // This is correct
      dateExpiration: json['dateExpiration'] != null
          ? DateTime.parse(json['dateExpiration'])
          : DateTime.now(),
      statut: json['statut'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAbonnement': idAbonnement,
      'typeAbonnement': typeAbonnement,
      'description': description,
      'prix': prix,
      'dateExpiration': dateExpiration.toIso8601String(),
      'statut': statut,
    };
  }
}
