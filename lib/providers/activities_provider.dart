import 'package:flutter/material.dart';

import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/activity_model.dart';

class ActivitiesProvider extends ChangeNotifier {
  List<Activity> userAcitivies = [];
  bool firstLoadDone = false;

  //********* Functions */
  Future<void> loadUserActivities(String userId, int year, int week) async {
    userAcitivies =
        await ApiDatabase().getActivitiesByWeekYear(userId, year, week);
    firstLoadDone = true;
    notifyListeners();
  }
}
