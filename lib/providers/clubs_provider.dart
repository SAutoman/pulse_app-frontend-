import 'package:flutter/material.dart';
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/club_model.dart';

class ClubsProvider extends ChangeNotifier {
  List<Club> clubs = [];
  List<Club> filteredClubs = [];
  Map<String, dynamic> clubMembersPoints = {};

  bool isLoading = false;

  ApiDatabase apiDatabase = ApiDatabase();

  //Get avaiable clubs
  Future<void> getAvailableClubs(List<Club> joinedClubs) async {
    isLoading = true;
    notifyListeners();

    final availableClubs = await apiDatabase.getAvailableClubs();
    clubs = availableClubs;

    //Filter out clubs where the user is already part of
    filterClubs(joinedClubs);

    isLoading = false;
    notifyListeners();
  }

  //Filter out clubs based on the user
  void filterClubs(List<Club> joinedClubs) {
    //Filter out clubs where the user is already part of
    filteredClubs = clubs
        .where((club) =>
            !joinedClubs.any((joinedClub) => joinedClub.id == club.id))
        .toList();

    notifyListeners();
  }

  //Join a club
  Future<bool> joinUserToClub(String userId, String clubId) async {
    final response = await apiDatabase.joinAClub(userId, clubId);
    print(response);
    return response;
  }
}
