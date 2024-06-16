import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/ranking_league_model.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/models/server_responses/users_ranking_response.dart';

import 'package:pulse_mate_app/models/user_model.dart';

class RankingProvider extends ChangeNotifier {
  List<User> usersRanking = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  List<User> rankingTop3 = [];
  List<User> rankingOthers = [];
  bool firstLoadDone = false;
  Reward? rankingReward;
  List<RankingLeague> allRankingLeagues = [];

  //********* Functions */
  Future<void> getRanking(User user) async {
    print('++ API CALL: Get ranking');

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';
    final url = Uri.parse(
        'http://192.168.147.232:3000/users/ranking?rankingLeagueId=${user.currentLeague.id}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      final userLoginResponse =
          UsersRankingResponse.fromJson(jsonDecode(response.body));
      usersRanking = userLoginResponse.userList;

      //Update tops
      if (usersRanking.length >= 3) {
        rankingTop3 = usersRanking.sublist(0, 3);
        rankingOthers = usersRanking.sublist(3);
      } else {
        rankingTop3 = List.from(
            usersRanking); // Copy all elements to top3 if less than 3 elements
      }

      firstLoadDone = true;
      notifyListeners();
    } else {
      print('Error in log in');
      print(response.body);
    }
  }

  void getAllRankingLeagues() async {
    final foundLeagues = await ApiDatabase().fetchAllLeaguesWithCategories();
    allRankingLeagues = foundLeagues;
    notifyListeners();
  }

  //Get current uer ranking position
  int getCurrentUserRanking(User currentUser) {
    for (int i = 0; i < usersRanking.length; i++) {
      if (usersRanking[i].id == currentUser.id) {
        return i + 1;
      }
    }
    return -1;
  }

  //Get current uer ranking position
  int getPointToNextUser(User currentUser) {
    int currentUserIndex = -1;
    for (int i = 0; i < usersRanking.length; i++) {
      if (usersRanking[i].id == currentUser.id) {
        currentUserIndex = i;
      }
    }

    if (currentUserIndex > 0) {
      final currentUserScore = usersRanking[currentUserIndex].currentWeekScore;
      final nextUserScore = usersRanking[currentUserIndex - 1].currentWeekScore;
      return nextUserScore - currentUserScore;
    } else {
      return -1;
    }
  }

  //Get ranking reward
  // Future<void> getReward({
  //   required int year,
  //   required int weekNumber,
  //   required String tMateAppToken,
  //   required User user,
  // }) async {
  //   print('++ API CALL: Get ranking reward');
  //   print('$weekNumber ${user.currentLeague.category.name} ${user.currentLeague.level}');
  //   final url = Uri.parse(
  //       'http://192.168.147.232:3000/rewards?category=${user.currentLeague.category.name}&league=${user.}&weekNumber=$weekNumber&year=$year');

  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-token': tMateAppToken,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final rewardResponse = RewardResponse.fromJson(jsonDecode(response.body));
  //     rankingReward = rewardResponse.reward;
  //     notifyListeners();
  //   } else {
  //     print('Error finding the reward or not existing');
  //     print(response.body);
  //   }
  // }
}
