import 'package:flutter/material.dart';

import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/mission_attempt_model.dart';
import 'package:pulse_mate_app/models/mission_model.dart';

class MissionsProvider extends ChangeNotifier {
  List<Mission> missions = [];
  List<Mission> filteredMissions = [];

  List<MissionAttempt> activeMissionsAttempts = [];
  bool firstLoadMissionsDone = false;
  bool firstLoadAttemptsDone = false;

  List<MissionAttempt> inactiveMissionsAttempts = [];
  bool firstLoadInactiveAttemptsDone = false;

  //********* Missions */
  Future<void> loadActiveMissions(String userId) async {
    missions = await ApiDatabase().getActiveMissions(userId);

    await loadActiveMissionAttempts(userId);
    await filterMisions();
    await loadInactiveMissionAttempts(userId);

    firstLoadMissionsDone = true;
    notifyListeners();
  }

  Future<void> filterMisions() async {
    Set<String> attemptedMissionsIds =
        activeMissionsAttempts.map((attempt) => attempt.missionId).toSet();
    filteredMissions = missions;
    filteredMissions
        .removeWhere((mission) => attemptedMissionsIds.contains(mission.id));

    notifyListeners();
  }

  //********* Mission Attempts */
  Future<void> loadActiveMissionAttempts(String userId) async {
    activeMissionsAttempts =
        await ApiDatabase().getMissionAttempts(userId, true);

    firstLoadAttemptsDone = true;
    notifyListeners();
  }

  Future<void> loadInactiveMissionAttempts(String userId) async {
    inactiveMissionsAttempts =
        await ApiDatabase().getMissionAttempts(userId, false);

    firstLoadInactiveAttemptsDone = true;
    notifyListeners();
  }

  Future<void> createMissionAttempt(
      String userId, String missionId, String userTimezone) async {
    final missionAttempt = await ApiDatabase()
        .createMissionAttempt(userId, missionId, userTimezone);

    notifyListeners();
  }
}
