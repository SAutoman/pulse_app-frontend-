class AthleteGarminResponse {
  AthleteGarminResponse({
    required this.id,
    required this.username,
    required this.resourceState,
    required this.firstname,
    required this.lastname,
    required this.bio,
    required this.city,
    required this.state,
    required this.country,
    required this.sex,
    required this.premium,
    required this.summit,
    required this.createdAt,
    required this.updatedAt,
    required this.badgeTypeId,
    required this.weight,
    required this.profileMedium,
    required this.profile,
    required this.blocked,
    required this.mutualFriendCount,
    required this.athleteType,
    required this.datePreference,
    required this.measurementPreference,
  });

  final int id;
  final dynamic username;
  final int? resourceState;
  final String? firstname;
  final String? lastname;
  final dynamic bio;
  final dynamic city;
  final dynamic state;
  final dynamic country;
  final String? sex;
  final bool? premium;
  final bool? summit;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? badgeTypeId;
  final double? weight;
  final String? profileMedium;
  final String? profile;
  final bool? blocked;
  final int? mutualFriendCount;
  final int? athleteType;
  final String? datePreference;
  final String? measurementPreference;

  factory AthleteGarminResponse.fromJson(Map<String, dynamic> json) {
    return AthleteGarminResponse(
      id: json["id"],
      username: json["username"],
      resourceState: json["resource_state"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      bio: json["bio"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      sex: json["sex"],
      premium: json["premium"],
      summit: json["summit"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      badgeTypeId: json["badge_type_id"],
      weight: json["weight"],
      profileMedium: json["profile_medium"],
      profile: json["profile"],

      blocked: json["blocked"],
      mutualFriendCount: json["mutual_friend_count"],
      athleteType: json["athlete_type"],
      datePreference: json["date_preference"],
      measurementPreference: json["measurement_preference"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "resource_state": resourceState,
        "firstname": firstname,
        "lastname": lastname,
        "bio": bio,
        "city": city,
        "state": state,
        "country": country,
        "sex": sex,
        "premium": premium,
        "summit": summit,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "badge_type_id": badgeTypeId,
        "weight": weight,
        "profile_medium": profileMedium,
        "profile": profile,
        "blocked": blocked,
        "mutual_friend_count": mutualFriendCount,
        "athlete_type": athleteType,
        "date_preference": datePreference,
        "measurement_preference": measurementPreference,
      };
}
