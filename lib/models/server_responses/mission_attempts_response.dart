import 'package:pulse_mate_app/models/mission_attempt_model.dart';

class MissionAttemptsResponse {
  final List<MissionAttempt> missionAttempts;

  MissionAttemptsResponse({required this.missionAttempts});

  factory MissionAttemptsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['missionAttempts'] as List;
    List<MissionAttempt> missionAttemptsList =
        list.map((i) => MissionAttempt.fromJson(i)).toList();
    return MissionAttemptsResponse(missionAttempts: missionAttemptsList);
  }
}
