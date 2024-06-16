import 'package:flutter/material.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/sport_type.dart';

class SportTypesProvider extends ChangeNotifier {
  List<SportType> sportTypes = [];
  bool firstLoadDone = false;

  Future<void> getSportTypes() async {
    if (!firstLoadDone) {
      final sports = await ApiDatabase().getSportTypes();
      sportTypes = sports;

      firstLoadDone = true;
      notifyListeners();
    }
  }
}
