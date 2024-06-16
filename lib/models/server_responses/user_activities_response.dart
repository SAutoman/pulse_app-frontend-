import 'package:pulse_mate_app/models/activity_model.dart';

class UserActivitiesResponse {
  final int count;
  final List<Activity> activities;

  UserActivitiesResponse({
    required this.count,
    required this.activities,
  });

  factory UserActivitiesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> activityList = json['activities'];
    final List<Activity> activities = activityList
        .map((activityJson) => Activity.fromJson(activityJson))
        .toList();

    return UserActivitiesResponse(
      count: json['count'],
      activities: activities,
    );
  }
}
