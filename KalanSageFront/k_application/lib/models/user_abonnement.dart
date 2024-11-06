// user_abonnement.dart
import 'package:k_application/models/user_model.dart';

import 'abonnement_model.dart';

class UserAbonnement {
  final int id;
  final String startDate;
  final String? endDate;
  final UserModel user;
  final Abonnement abonnement;
  final bool active;

  UserAbonnement({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.user,
    required this.abonnement,
    required this.active,
  });

  factory UserAbonnement.fromJson(Map<String, dynamic> json) {
    return UserAbonnement(
      id: json['id'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      user: UserModel.fromJson(json['user']),
      abonnement: Abonnement.fromJson(json['abonnement']),
      active: json['active'],
    );
  }
}
