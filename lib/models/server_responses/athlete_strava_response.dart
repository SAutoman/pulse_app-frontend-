class AthleteStravaResponse {
  AthleteStravaResponse({
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
    required this.friend,
    required this.follower,
    required this.blocked,
    required this.canFollow,
    required this.followerCount,
    required this.friendCount,
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
  final dynamic friend;
  final dynamic follower;
  final bool? blocked;
  final bool? canFollow;
  final int? followerCount;
  final int? friendCount;
  final int? mutualFriendCount;
  final int? athleteType;
  final String? datePreference;
  final String? measurementPreference;

  factory AthleteStravaResponse.fromJson(Map<String, dynamic> json) {
    return AthleteStravaResponse(
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
      friend: json["friend"],
      follower: json["follower"],
      blocked: json["blocked"],
      canFollow: json["can_follow"],
      followerCount: json["follower_count"],
      friendCount: json["friend_count"],
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
        "friend": friend,
        "follower": follower,
        "blocked": blocked,
        "can_follow": canFollow,
        "follower_count": followerCount,
        "friend_count": friendCount,
        "mutual_friend_count": mutualFriendCount,
        "athlete_type": athleteType,
        "date_preference": datePreference,
        "measurement_preference": measurementPreference,
      };
}
