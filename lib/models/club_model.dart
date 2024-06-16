import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/sport_type.dart';
import 'package:pulse_mate_app/models/user_model.dart';

class Club {
  String id;
  String name;
  String imageUrl;
  String bannerUrl;
  bool isPrivate;
  bool isCorporate;
  List<UserWithPoints>? members;
  SportType? sportType;
  String? startDate;
  String? endDate;

  Club({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isPrivate,
    required this.isCorporate,
    required this.bannerUrl,
    this.members,
    this.sportType,
    this.startDate,
    this.endDate,
  });

  factory Club.fromJson(Map<String, dynamic> json) => Club(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        bannerUrl: json['banner_url'],
        isPrivate: json['is_private'],
        isCorporate: json['is_corporate'],
        members:
            json['members']?.map<User>((json) => User.fromJson(json)).toList(),
        sportType: json['sport_type'] != null
            ? SportType.fromJson(json['sport_type'])
            : null,
        startDate: json['startDate'], // Add this line
        endDate: json['endDate'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        'is_private': isPrivate,
        'is_corporate': isCorporate,
        'banner_url': bannerUrl,
        'members': members?.map((user) => user.toJson()).toList(),
        'startDate': startDate,
        'endDate': endDate,
      };

  // Function to fetch and update the members list based on the period
  Future<void> fetchAndSetMembersPoints(String period) async {
    final response =
        await ApiDatabase().getClubMembersPointsByPeriod(id, period);
    members = response['members']
        .map<UserWithPoints>((json) => UserWithPoints.fromJson(json))
        .toList();
    startDate = response['startDate'];
    endDate = response['endDate'];
    members!.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
  }

  //Function to check if the user already is part of this club
  bool userIsPartOfClub(User user) {
    final userClubs = user.userClubs.map((e) => e.club).toList();
    final response = userClubs.any((club) => club.id == id);
    return response;
  }
}

class UserClub {
  // Assuming a basic structure for UserClub. You'll need to define it fully based on your specific needs.
  String id;
  String userId;
  String clubId;
  Club club;

  UserClub({
    required this.id,
    required this.userId,
    required this.clubId,
    required this.club,
  });

  factory UserClub.fromJson(Map<String, dynamic> json) => UserClub(
        id: json['id'],
        userId: json['user_id'],
        clubId: json['club_id'],
        club: Club.fromJson(json['club']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'clubId': clubId,
      };
}

class MissionClub {
  // Assuming a basic structure for MissionClub. You'll need to define it fully based on your specific needs.
  String id;
  String clubId;
  String missionId;

  MissionClub(
      {required this.id, required this.clubId, required this.missionId});

  factory MissionClub.fromJson(Map<String, dynamic> json) => MissionClub(
        id: json['id'],
        clubId: json['club_id'],
        missionId: json['mission_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clubId': clubId,
        'missionId': missionId,
      };
}

class UserWithPoints {
  User user;
  int totalPoints;

  UserWithPoints({required this.user, required this.totalPoints});

  factory UserWithPoints.fromJson(Map<String, dynamic> json) => UserWithPoints(
        user: User.fromJson(json['user']),
        totalPoints: json['totalPoints'],
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'totalPoints': totalPoints,
      };
}
