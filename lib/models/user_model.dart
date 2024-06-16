import 'package:pulse_mate_app/models/badge_model.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/models/ranking_league_model.dart';
import 'package:pulse_mate_app/models/sport_type.dart';

class User {
  User({
    required this.imageUrl,
    required this.isActive,
    required this.currentWeekScore,
    required this.country,
    required this.timezone,
    required this.coins,
    required this.id,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.stravaConnected,
    required this.stravaAccessToken,
    required this.stravaRefreshToken,
    required this.stravaAccessExpiresAt,
    required this.stravaUserId,
    required this.garminConnected,
    required this.garminAccessToken,
    required this.garminRefreshToken,
    required this.garminAccessExpiresAt,
    required this.garminUserId,
    required this.preferredSport,
    required this.fcmToken,
    required this.emailNotificationsAllowed,
    required this.pushNotificationAllowed,
    required this.userClubs,
    required this.sportType,
    required this.badges,
    required this.currentLeague,
    required this.isCorporate,
    required this.corpArea,
    required this.corpSubArea,
    required this.hasPrivateActivities,
    required this.isDeviceHealthConnected,
  });

  final String id;
  final DateTime? createdAt;
  final bool isActive;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool? stravaConnected;
  final String? stravaAccessToken;
  final String? stravaRefreshToken;
  final int? stravaUserId;
  final int? stravaAccessExpiresAt;
  final bool? garminConnected;
  final String? garminAccessToken;
  final String? garminRefreshToken;
  final int? garminUserId;
  final int? garminAccessExpiresAt;
  final int currentWeekScore;
  final String country;
  final String timezone;
  final int coins;
  final String imageUrl;
  String preferredSport;
  final String? fcmToken;
  final bool emailNotificationsAllowed;
  final bool pushNotificationAllowed;
  List<UserClub> userClubs;
  SportType sportType;
  List<BadgeItem> badges;
  final RankingLeague currentLeague;
  final bool isCorporate;
  final String? corpArea;
  final String? corpSubArea;
  final bool hasPrivateActivities;
  final bool isDeviceHealthConnected;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        stravaConnected: json["strava_connected"],
        stravaAccessToken: json["strava_access_token"],
        stravaRefreshToken: json["strava_refresh_token"],
        stravaAccessExpiresAt: json["strava_access_expires_at"],
        stravaUserId: json["strava_user_id"],
        garminConnected: json["garmin_connected"],
        garminAccessToken: json["garmin_access_token"],
        garminRefreshToken: json["garmin_refresh_token"],
        garminAccessExpiresAt: json["garmin_access_expires_at"],
        garminUserId: json["garmin_user_id"],
        isActive: json["is_active"],
        currentWeekScore: json["current_week_score"],
        country: json["country"],
        timezone: json["timezone"],
        coins: json["coins"],
        imageUrl: json["image_url"],
        preferredSport: json["preferred_sport"],
        fcmToken: json["fcm_token"],
        emailNotificationsAllowed: json["email_notifications_allowed"] ?? false,
        pushNotificationAllowed: json["push_notifications_allowed"] ?? false,
        userClubs: json['user_clubs'] != null
            ? List<UserClub>.from(
                json['user_clubs'].map((x) => UserClub.fromJson(x)))
            : <UserClub>[],
        sportType: SportType.fromJson(json['sport_type']),
        badges: json['user_badges'] != null
            ? List<BadgeItem>.from(
                json['user_badges'].map((x) => BadgeItem.fromJson(x['badge'])))
            : <BadgeItem>[],
        currentLeague: RankingLeague.fromJson(json['current_league']),
        isCorporate: json["is_corporate"],
        corpArea: json["corp_area"],
        corpSubArea: json["corpSubArea"],
        hasPrivateActivities: json["has_private_activities"],
        isDeviceHealthConnected: json["is_device_health_connected"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "strava_connected": stravaConnected,
        "strava_access_token": stravaAccessToken,
        "strava_refresh_token": stravaRefreshToken,
        "strava_access_expires_at": stravaAccessExpiresAt,
        "garmin_connected": garminConnected,
        "garmin_access_token": garminAccessToken,
        "garmin_refresh_token": garminRefreshToken,
        "garmin_access_expires_at": garminAccessExpiresAt,
        "is_active": isActive,
        "current_week_score": currentWeekScore,
        "country": country,
        "timezone": timezone,
        "coins": coins,
        "image_url": imageUrl,
        "preferred_sport": preferredSport,
        "fcm_token": fcmToken,
        "email_notifications_allowed": emailNotificationsAllowed,
        "push_notifications_allowed": pushNotificationAllowed,
        "user_clubs": userClubs.map((x) => x.toJson()).toList(),
        "sport_type": sportType.toJson(),
        "user_badges": badges
            .map((x) => x.toJson())
            .toList(), // Include badges in JSON serialization
        "current_league": currentLeague.toJson(),
        "is_corporate": isCorporate,
        "corp_area": corpArea,
        "corp_sub_area": corpSubArea,
        "has_private_activities": hasPrivateActivities,
        "is_device_health_connected": isDeviceHealthConnected,
      };

  User updateFields(Map<String, dynamic> updatedFields) {
    return User(
      id: updatedFields['id'] ?? id,
      createdAt: updatedFields['created_at'] ?? createdAt,
      firstName: updatedFields['first_name'] ?? firstName,
      lastName: updatedFields['last_name'] ?? lastName,
      email: updatedFields['email'] ?? email,
      password: updatedFields['password'] ?? password,
      stravaConnected: updatedFields['strava_connected'] ?? stravaConnected,
      stravaAccessToken:
          updatedFields['strava_access_token'] ?? stravaAccessToken,
      stravaRefreshToken:
          updatedFields['strava_refresh_token'] ?? stravaRefreshToken,
      stravaAccessExpiresAt:
          updatedFields['strava_access_expires_at'] ?? stravaAccessExpiresAt,
      stravaUserId: updatedFields['strava_user_id'] ?? stravaUserId,

      garminConnected: updatedFields['garmin_connected'] ?? garminConnected,
      garminAccessToken:
          updatedFields['garmin_access_token'] ?? garminAccessToken,
      garminRefreshToken:
          updatedFields['garmin_refresh_token'] ?? garminRefreshToken,
      garminAccessExpiresAt:
          updatedFields['garmin_access_expires_at'] ?? garminAccessExpiresAt,
      garminUserId: updatedFields['garmin_user_id'] ?? garminUserId,
      isActive: updatedFields['is_active'] ?? isActive,
      currentWeekScore: updatedFields['current_week_score'] ?? currentWeekScore,
      country: updatedFields['country'] ?? country,
      timezone: updatedFields['timezone'] ?? timezone,
      coins: updatedFields['coins'] ?? coins,
      imageUrl: updatedFields['image_url'] ?? imageUrl,
      preferredSport: updatedFields['preferred_sport'] ?? preferredSport,
      fcmToken: updatedFields['fcm_token'] ?? fcmToken,
      emailNotificationsAllowed: updatedFields['email_notifications_allowed'] ??
          emailNotificationsAllowed,
      pushNotificationAllowed: updatedFields['push_notifications_allowed'] ??
          pushNotificationAllowed,
      userClubs: updatedFields['user_clubs'] ?? userClubs,
      sportType: updatedFields['sport_type'] ?? sportType,
      badges: updatedFields['user_badges'] ?? badges,
      currentLeague: updatedFields['current_league'] ?? currentLeague,
      isCorporate: updatedFields['is_corporate'] ?? isCorporate,
      corpArea: updatedFields['corp_area'] ?? corpArea,
      corpSubArea: updatedFields['corp_sub_area'] ?? corpSubArea,
      hasPrivateActivities:
          updatedFields['has_private_activities'] ?? hasPrivateActivities,
      isDeviceHealthConnected: updatedFields['is_device_health_connected'] ??
          isDeviceHealthConnected,
    );
  }

  // Update user sport type
  void updateUserSport(SportType newSportType) {
    // Here you should update the sportType field and perform any other necessary updates
    sportType = newSportType;
  }
}
