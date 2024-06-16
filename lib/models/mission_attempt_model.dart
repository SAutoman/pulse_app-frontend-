import 'package:pulse_mate_app/models/mission_model.dart';
import 'package:pulse_mate_app/models/mission_progress.dart';

class MissionAttempt {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String startDateUserTimezone;
  final String endDateUserTimezone;
  final double progress;
  final String status;
  final String timezone;
  final String userId;
  final String missionId;
  final Mission mission;
  final List<MissionProgress> missionProgress;

  MissionAttempt({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.startDateUserTimezone,
    required this.endDateUserTimezone,
    required this.progress,
    required this.status,
    required this.timezone,
    required this.userId,
    required this.missionId,
    required this.mission,
    required this.missionProgress,
  });

  factory MissionAttempt.fromJson(Map<String, dynamic> json) {
    var list = json['mission_progress'] != null
        ? json['mission_progress'] as List
        : [];
    List<MissionProgress> missionProgressList =
        list.map((i) => MissionProgress.fromJson(i)).toList();

    return MissionAttempt(
      id: json['id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      startDateUserTimezone: json['start_date_user_timezone'],
      endDateUserTimezone: json['end_date_user_timezone'],
      progress: json['progress'].toDouble(),
      status: json['status'],
      timezone: json['timezone'],
      userId: json['user_id'],
      missionId: json['mission_id'],
      mission: Mission.fromJson(json['mission']),
      missionProgress: missionProgressList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'start_date_user_timezone': startDateUserTimezone,
      'end_date_user_timezone': endDateUserTimezone,
      'progress': progress,
      'status': status,
      'timezone': timezone,
      'user_id': userId,
      'mission_id': missionId,
      'mission': mission.toString()
    };
  }
}
