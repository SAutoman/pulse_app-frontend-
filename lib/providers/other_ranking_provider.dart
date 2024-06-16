import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/models/server_responses/reward_response.dart';
import 'package:pulse_mate_app/models/server_responses/users_ranking_response.dart';

import 'package:pulse_mate_app/models/user_model.dart';

class OtherRankingProvider extends ChangeNotifier {
  List<User> usersRanking = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  List<User> rankingTop3 = [];
  List<User> rankingOthers = [];
  bool firstLoadDone = false;
  bool isLoading = false;

  Reward? rankingReward;

  //********* Functions */
  Future<void> getRanking(String rankingLeagueId) async {
    rankingTop3 = [];
    rankingOthers = [];
    print('++ API CALL: Get OTHER ranking');
    isLoading = true;
    notifyListeners();

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';
    final url = Uri.parse(
        'http://192.168.147.232:3000/users/ranking?rankingLeagueId=$rankingLeagueId');

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
      isLoading = false;
      notifyListeners();
    } else {
      print('Error in log in');
      print(response.body);
    }
  }

  //Get ranking reward
  Future<void> getReward({
    required String category,
    required int league,
    required int weekNumber,
    required String tMateAppToken,
  }) async {
    print('++ API CALL: Get ranking reward');
    final url = Uri.parse(
        'http://192.168.147.232:3000/rewards?category=${category}&league=${league}&weekNumber=$weekNumber');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      final rewardResponse = RewardResponse.fromJson(jsonDecode(response.body));
      rankingReward = rewardResponse.reward;
      notifyListeners();
    } else {
      print('Error finding the reward or not existing');
      print(response.body);
    }
  }
}
