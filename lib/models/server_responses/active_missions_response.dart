import 'package:pulse_mate_app/models/mission_model.dart';

class ActiveMissionsResponse {
  final List<Mission> missions;

  ActiveMissionsResponse({required this.missions});

  factory ActiveMissionsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['missions'] as List;
    List<Mission> missionList = list.map((i) => Mission.fromJson(i)).toList();
    return ActiveMissionsResponse(missions: missionList);
  }

  Map<String, dynamic> toJson() {
    return {
      'missions': missions.map((mission) => mission.toJson()).toList(),
    };
  }
}
