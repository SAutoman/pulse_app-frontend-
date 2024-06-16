import 'package:flutter/material.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/database/api_calls.dart';

class CurrentUserProvider extends ChangeNotifier {
  final ApiDatabase apiDatabase = ApiDatabase();

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  Future<List<Activity>> fetchActivitiesByEpochRange(
      String userId, int fromEpoch, int toEpoch) async {
    _activities =
        await apiDatabase.getActivitiesByEpochRange(userId, fromEpoch, toEpoch);
    notifyListeners();
    return _activities;
  }
}
