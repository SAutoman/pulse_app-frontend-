import 'package:pulse_mate_app/models/activity_model.dart';

class MissionProgress {
  final String id;
  final double progressMade;
  final String createdAt;
  final String missionAttemptId;
  final String activityId;
  final Activity activity;

  MissionProgress({
    required this.id,
    required this.progressMade,
    required this.createdAt,
    required this.missionAttemptId,
    required this.activityId,
    required this.activity,
  });

  // Constructor to create a MissionProgress object from a JSON map
  factory MissionProgress.fromJson(Map<String, dynamic> json) {
    return MissionProgress(
      id: json['id'],
      progressMade: json['progress_made'].toDouble(),
      createdAt: json['created_at'],
      missionAttemptId: json['mission_attempt_id'],
      activityId: json['activity_id'],
      activity: Activity.fromJson(json['activity']),
    );
  }
}
