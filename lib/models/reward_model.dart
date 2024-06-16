import 'package:pulse_mate_app/models/club_model.dart';

class Reward {
  final String id;
  final String name;
  final String description;
  final int pointsCost;
  final int quantity;
  final bool isActive;
  final String imageUrl;
  final DateTime? availableFrom;
  final DateTime? availableUntil;
  final List<String> categories;
  final List<String> badgeRequirements;
  final int? maxRedemptionsPerUser;
  final bool isPublic;
  final List<Club> clubs;

  Reward(
      {required this.id,
      required this.name,
      required this.description,
      required this.pointsCost,
      required this.quantity,
      required this.isActive,
      required this.imageUrl,
      required this.availableFrom,
      required this.availableUntil,
      required this.categories,
      required this.badgeRequirements,
      this.maxRedemptionsPerUser,
      required this.isPublic,
      required this.clubs});

  // Factory constructor to create a Reward from JSON data
  factory Reward.fromJson(Map<String, dynamic> json) {
    var rewardClubsJson = json['reward_clubs'] as List<dynamic>? ?? [];
    List<Club> clubs = rewardClubsJson
        .map((clubJson) =>
            Club.fromJson(clubJson['club'] as Map<String, dynamic>))
        .toList();

    return Reward(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pointsCost: json['points_cost'] as int,
      quantity: json['quantity'] as int,
      isActive: json['is_active'] as bool,
      imageUrl: json['image_url'] as String? ?? '',
      availableFrom: json['available_from'] != null
          ? DateTime.parse(json['available_from'] as String)
          : null,
      availableUntil: json['available_until'] != null
          ? DateTime.parse(json['available_until'] as String)
          : null,
      categories: List<String>.from(json['categories']),
      badgeRequirements: List<String>.from(json['badge_requirements'] ?? []),
      maxRedemptionsPerUser: json['max_redemptions_per_user'],
      isPublic: json['is_public'] as bool,
      clubs: clubs,
    );
  }
}
