import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_mate_app/models/badge_model.dart';
import 'package:pulse_mate_app/models/club_model.dart';
import 'package:pulse_mate_app/models/coin_transaction_model.dart';
import 'package:pulse_mate_app/models/mission_attempt_model.dart';
import 'package:pulse_mate_app/models/mission_model.dart';
import 'package:pulse_mate_app/models/notifications_model.dart';
import 'package:pulse_mate_app/models/ranking_league_model.dart';
import 'package:pulse_mate_app/models/reward_model.dart';
import 'package:pulse_mate_app/models/server_responses/active_missions_response.dart';
import 'package:pulse_mate_app/models/server_responses/club_details_response.dart';
import 'package:pulse_mate_app/models/server_responses/clubs_response.dart';
import 'package:pulse_mate_app/models/server_responses/mission_attempts_response.dart';
import 'package:pulse_mate_app/models/server_responses/notifications_response.dart';
import 'package:pulse_mate_app/models/server_responses/user_activities_response.dart';
import 'package:pulse_mate_app/models/server_responses/user_get_response.dart';
import 'package:pulse_mate_app/models/server_responses/user_login_response.dart';
import 'package:pulse_mate_app/models/server_responses/user_signup_response.dart';
import 'package:pulse_mate_app/models/sport_type.dart';
import 'package:pulse_mate_app/models/user_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApiDatabase {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

//ACTIVITIES PROVIDER - Get Activities by Date Range (Epoch)
  Future<List<Activity>> getActivitiesByEpochRange(
      String userId, int fromEpoch, int toEpoch) async {
    print('++ API CALL: GET ACTIVITIES by epoch range');

    List<Activity> activities = [];

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/activities/$userId?fromEpoch=$fromEpoch&toEpoch=$toEpoch');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      final userActivitiesResponse =
          UserActivitiesResponse.fromJson(jsonDecode(response.body));
      activities = userActivitiesResponse.activities;
    } else {
      print('Error in activities fetch');
      print(response.body);
    }
    return activities;
  }

  //ACTIVITIES PROVIDER - Get Activities by Week and Year
  Future<List<Activity>> getActivitiesByWeekYear(
      String userId, int year, int week) async {
    print('++ API CALL: GET ACTIVITIES by week/year');

    List<Activity> activities = [];

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/activities/$userId?year=$year&week=$week');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    //try {
    if (response.statusCode == 200) {
      final userLoginResponse =
          UserActivitiesResponse.fromJson(jsonDecode(response.body));
      activities = userLoginResponse.activities;
    } else {
      print('Error in acitvities fetch');
      print(response.body);
    }
    /*} catch (e) {
      print('Error parsing activities');
      print(e.toString());
    }*/
    return activities;
  }

  //MISSION PROVIDER - Get Missions
  Future<List<Mission>> getActiveMissions(String userId) async {
    print('++ API CALL: GET ACTIVE MISSIONS');

    List<Mission> missions = [];

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url =
        Uri.parse('http://192.168.147.232:3000/missions/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    try {
      if (response.statusCode == 200) {
        final activeMissionsResponse =
            ActiveMissionsResponse.fromJson(jsonDecode(response.body));
        missions = activeMissionsResponse.missions;
      } else {
        print('Error in missions fetch');
        print(response.body);
      }
    } catch (e) {
      print('Error parsing active missions');
      print(e.toString());
    }
    return missions;
  }

  //MISSION ATTEMPTS PROVIDER - Get Mission Attempts
  Future<List<MissionAttempt>> getMissionAttempts(
      String userId, bool onlyActive) async {
    print('++ API CALL: GET ACTIVE MISSSION ATTEMPTS');

    List<MissionAttempt> missionAttempts = [];

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/mission-attempts?userId=$userId&active=$onlyActive');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    try {
      if (response.statusCode == 200) {
        final missionAttemptsResponse =
            MissionAttemptsResponse.fromJson(jsonDecode(response.body));
        missionAttempts = missionAttemptsResponse.missionAttempts;
      } else {
        print('Error in mission attempts fetch');
        print(response.body);
      }
    } catch (e) {
      print('Error parsing mission attempts');
      print(e.toString());
    }
    return missionAttempts;
  }

  //MISSION ATTEMPTS PROVIDER - Create Mission Attempts
  Future<MissionAttempt?> createMissionAttempt(
      String userId, String missionId, String userTimezone) async {
    print('++ API CALL: CREATE MISSSION ATTEMPT');

    MissionAttempt? missionAttempt = null;

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/mission-attempts?userId=$userId&missionId=$missionId&timezone=$userTimezone');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    //try {
    if (response.statusCode == 200) {
      final missionAttemptResponse =
          MissionAttempt.fromJson(jsonDecode(response.body)['missionAttempt']);
      missionAttempt = missionAttemptResponse;
    } else {
      print('Error in mission attempt creation');
      print(response.body);
    }
    /*} catch (e) {
      print('Error parsing mission attempts');
      print(e.toString());
    }*/
    return missionAttempt;
  }

  //MISSION ATTEMPTS PROVIDER - Delete Mission Attempt by ID
  Future<bool> deleteMissionAttempt(String attemptId) async {
    print('++ API CALL: DELETE MISSSION ATTEMPT');

    // MissionAttempt? missionAttempt = null;

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/mission-attempts?missionAttemptId=$attemptId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    //try {
    if (response.statusCode == 200) {
      return true;
      // final missionAttemptResponse =
      //     MissionAttempt.fromJson(jsonDecode(response.body)['missionAttempt']);
      // missionAttempt = missionAttemptResponse;
    } else {
      print('Error in mission attempt deletion');
      print(response.body);
      return false;
    }
    /*} catch (e) {
      print('Error parsing mission attempts');
      print(e.toString());
    }*/
    // return missionAttempt;
  }

  //AUTH PROVIDER - Validate login using existing token
  Future<User?> validateLoginToken() async {
    print('++ API CALL: VALIDATE USER TOKEN');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    if (tMateAppToken != null) {
      // Get device information
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceName = 'Unknown Device';
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model ?? "Unknown Android Device";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine ?? "Unknown iOS Device";
      }

      // Get app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;

      final url = Uri.parse(
          'http://192.168.147.232:3000/auth/validateLogin?app_version=$appVersion&device=$deviceName');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken,
        },
      );

      if (response.statusCode == 200) {
        try {
          final userLoginResponse =
              UserLoginResponse.fromJson(jsonDecode(response.body));
          return userLoginResponse.user;
        } catch (e) {
          print('Error: ${e.toString()}');
          return null;
        }
      } else {
        print('Error in log in');
        print(response.body);
        return null;
      }
    } else {
      print('The token does not exist in the local secure storage');
      return null;
    }
  }

  //AUTH PROVIDER - Login user with email and password
  Future<User?> loginUser(String email, String password) async {
    print('++ API CALL: LOGIN USER WITH EMAIL & PASSWORD');

    final url = Uri.parse('http://192.168.147.232:3000/auth/login');
    final body = {'email': email, 'password': password};

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('User logged in');
      final userLoginResponse =
          UserLoginResponse.fromJson(jsonDecode(response.body));

      //Save JWT token in secure storage
      await _secureStorage.write(
          key: 'tMateAppToken', value: userLoginResponse.token);
      return userLoginResponse.user;
    } else {
      print('Error in log in');
      print(jsonDecode(response.body));
      return null;
    }
  }

  //AUTH PROVIDER - Create a new user
  Future<User?> createUser(String firstName, String lastName, String email,
      String password, String country, String timezone) async {
    print('++ API CALL: CREATE A NEW USER');

    final url = Uri.parse('http://192.168.147.232:3000/auth/signup');
    final body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'country': country,
      'timezone': timezone
    };
    // final body = {
    //   'first_name': "firstName",
    //   'last_name': "lastName",
    //   'email': "email@asdf.com",
    //   'password': "password",
    //   'country': country,
    //   'timezone': timezone
    // };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('User created successfully');
      final userSignupResponse =
          UserSignupResponse.fromJson(jsonDecode(response.body));
      //Save JWT token in secure storage
      await _secureStorage.write(
          key: 'tMateAppToken', value: userSignupResponse.token);
      return userSignupResponse.user;
    } else {
      print('Error creating user');
      print(jsonDecode(response.body));
      return null;
    }
  }

  //AUTH PROVIDER - Delete an user
  Future<bool> deleteUser(User currentUser) async {
    print('++ API CALL: DELETE AN USER');

    final url = Uri.parse(
        'http://192.168.147.232:3000/users/${currentUser.id}');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json', 'x-token': tMateAppToken!},
    );

    if (response.statusCode == 200) {
      print('User account deleted');
      return true;
    } else {
      print('Error deleting the user');
      print(response.body);
      return false;
    }
  }

  //AUTH PROVIDER - Update user notifications
  Future<User?> updateNotificationsSettings(
      User currentUser, bool emailNotif, bool pushNotif) async {
    print('++ API CALL: UPDATE USER NOTIFICATIONS SETTINGS');

    final url = Uri.parse(
        'http://192.168.147.232:3000/users/${currentUser.id}');
    final body = {
      'email_notifications_allowed': emailNotif,
      'push_notifications_allowed': pushNotif,
    };
    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      print('Notifications setting updated');

      final updatedUser = currentUser.updateFields({
        'email_notifications_allowed': emailNotif,
        'push_notifications_allowed': pushNotif,
      });
      return updatedUser;
    } else {
      print('Error updating notifications settings');
      print(response.body);
      return null;
    }
  }

  //AUTH PROVIDER - Get user by ID
  Future<User?> getUserById(String userId) async {
    print('++ API CALL: GET USER BY ID');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    if (tMateAppToken != null) {
      final url =
          Uri.parse('http://192.168.147.232:3000/users/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken,
        },
      );

      if (response.statusCode == 200) {
        try {
          final userGetResponse =
              UserGetResponse.fromJson(jsonDecode(response.body));
          return userGetResponse.user;
        } catch (e) {
          print('Error: ${e.toString()}');
          return null;
        }
      } else {
        print('Error retreiveing the user');
        print(response.body);
        return null;
      }
    } else {
      print('The token does not exist in the local secure storage');
      return null;
    }
  }

  //NOTIFICATIONS PROVIDER - Get paginated notifications
  Future<NotificationsResponse?> getUserNotifcations(
      String userId, int page, int limit) async {
    print('++ API CALL: GET USER NOTIFICATIONS page:$page limit: $limit');

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/notifications?page=$page&limit=$limit');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    try {
      if (response.statusCode == 200) {
        final userNotificationsResponse =
            NotificationsResponse.fromJson(jsonDecode(response.body));

        return userNotificationsResponse;
      } else {
        print('Error in notifications fetch');
        print(response.body);
        return null;
      }
    } catch (e) {
      print('Error parsing notifications');
      print(e.toString());
      return null;
    }
  }

  //NOTIFICATIONS PROVIDER - Update notifications as READ
  Future<bool> markNotificationsAsRead(
      List<UserNotification> notifications) async {
    print(
        '++ API CALL: UPDATE NOTIFICATIONS AS READ (${notifications.length} notifications)');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');
    final url = Uri.parse(
        'http://192.168.147.232:3000/notifications/mark-read');

    final body = {
      'notificationIds': notifications.map((notif) => notif.id).toList(),
    };

    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'x-token': tMateAppToken!,
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error in settingnotifications as read');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error callling read notifications endpoint');
      print(e.toString());
      return false;
    }
  }

  //CLUBS PROVIDER - Get available clubs
  Future<List<Club>> getAvailableClubs() async {
    print('++ API CALL: GET AVAILABLE CLUBS');

    List<Club> clubs = [];

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse('http://192.168.147.232:3000/clubs');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    try {
      if (response.statusCode == 200) {
        final clubsResponse = ClubResponse.fromJson(jsonDecode(response.body));
        clubs = clubsResponse.clubs;
      } else {
        print('Error in clubs fetch');
        print(response.body);
      }
    } catch (e) {
      print('Error parsing clubs');
      print(e.toString());
    }
    return clubs;
  }

  //CLUBS PROVIDER - Join a Club
  Future<bool> joinAClub(String userId, String clubId) async {
    print('++ API CALL: JOIN A CLUB (Creates an userClub item)');

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse('http://192.168.147.232:3000/user-clubs');
    final body = {'user_id': userId, 'club_id': clubId};
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
      body: jsonEncode(body),
    );

    try {
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error in joinning a club');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error joinning a club');
      print(e.toString());
      return false;
    }
  }

  //AUTH PROVIDER - Get user by ID
  Future<List<User>> getClubDetails(String clubId) async {
    print('++ API CALL: GET CLUB DETAILS BY ID');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    if (tMateAppToken != null) {
      final url = Uri.parse(
          'http://192.168.147.232:3000/clubs/details/$clubId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken,
        },
      );

      if (response.statusCode == 200) {
        try {
          final clubDetailsResponse =
              ClubDetailsResponse.fromJson(jsonDecode(response.body));
          return clubDetailsResponse.members;
        } catch (e) {
          print('Error: ${e.toString()}');
          return [];
        }
      } else {
        print('Error retreiveing the club details');
        print(response.body);
        return [];
      }
    } else {
      print('The token does not exist in the local secure storage');
      return [];
    }
  }

  //CLUBS PROVIDER - Delete UserClub relation by user Id and club Id
  Future<bool> deleteUserClubRelationByUserAndClubId(
      String userId, String clubId) async {
    print('++ API CALL: DELETE USER CLUB RELATION');

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/user-clubs?club_id=$clubId&user_id=$userId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    //try {
    if (response.statusCode == 200) {
      return true;
      // final missionAttemptResponse =
      //     MissionAttempt.fromJson(jsonDecode(response.body)['missionAttempt']);
      // missionAttempt = missionAttemptResponse;
    } else {
      print('Error in userClub relation deletion');
      print(response.body);
      return false;
    }
    /*} catch (e) {
      print('Error parsing mission attempts');
      print(e.toString());
    }*/
    // return missionAttempt;
  }

  //SPORT TYPES PROVIDER - Get all sport types available
  Future<List<SportType>> getSportTypes() async {
    print('++ API CALL: GET SPORT TYPES');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    if (tMateAppToken != null) {
      final url = Uri.parse('http://192.168.147.232:3000/sport-types');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken,
        },
      );

      if (response.statusCode == 200) {
        try {
          var list = jsonDecode(response.body) as List;
          List<SportType> sportTypesList =
              list.map((i) => SportType.fromJson(i)).toList();

          return sportTypesList;
        } catch (e) {
          print('Error: ${e.toString()}');
          return [];
        }
      } else {
        print('Error retreiveing the sport types');
        print(response.body);
        return [];
      }
    } else {
      print('The token does not exist in the local secure storage');
      return [];
    }
  }

  //AUTH PROVIDER - Update user sport
  Future<bool> updateUserSportType(
      User currentUser, SportType sportType) async {
    print('++ API CALL: UPDATE USER SPORT TYPE');

    final url = Uri.parse(
        'http://192.168.147.232:3000/users/${currentUser.id}');
    final body = {'sport_type_id': sportType.id};
    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      print('Sport Type updated');

      return true;
    } else {
      print('Error updating user sport type');
      print(response.body);
      return false;
    }
  }

//REWARDS PROVIDER - Get Rewards
  Future<List<Reward>> getAllRewards() async {
    print('++ API CALL: FETCH REWARDS');

    final url = Uri.parse('http://192.168.147.232:3000/rewards');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': tMateAppToken!
    });

    if (response.statusCode == 200) {
      List<dynamic> rewardsJson =
          json.decode(response.body)['rewards'] as List<dynamic>;
      return rewardsJson.map((json) => Reward.fromJson(json)).toList();
    } else {
      print('Error fetching rewards');
      print(response.body);
      throw Exception('Failed to load rewards');
    }
  }

  // REWARDS PROVIDER - Redeem a reward
  Future<bool> redeemReward(String userId, String rewardId) async {
    print('++ API CALL: REDEEM REWARD');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');
    final url = Uri.parse('http://192.168.147.232:3000/rewards/redeem');

    final body = jsonEncode({'user_id': userId, 'reward_id': rewardId});

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: body);

    if (response.statusCode == 200) {
      print('Reward redeemed successfully');
      return true;
    } else {
      print('Error redeeming reward: ${response.body}');
      return false;
    }
  }

  // XXX PROVIDER - Redeem a reward
  Future<List<BadgeItem>> getBadgesByIds(List<String> badgeIds) async {
    print('++ API CALL: GET BADGES FROM ID ARRAY');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');
    final url =
        Uri.parse('http://192.168.147.232:3000/badges/get-by-ids');

    final body = jsonEncode({'badgeIds': badgeIds});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'x-token': tMateAppToken!},
      body: body,
    );
    print('zzzzzzzzzzzzzzzzzzzzzzzz');
    print(response.body);
    if (response.statusCode == 200) {
      print('Array of Badges IDs got successfully');
      List<dynamic> badgesJson = json.decode(response.body);
      print(response.body);
      return badgesJson.map((json) => BadgeItem.fromJson(json)).toList();
    } else {
      print('Error getting the Badges from ID Array: ${response.body}');
      return [];
    }
  }



  // REWARDS PROVIDER - Get user redeemed rewards
  Future<List<Reward>> getRedeemedRewardsByUser(String userId) async {
    print('++ API CALL: GET USER REDEEMED REWARDS');

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');
    final url = Uri.parse(
        'http://192.168.147.232:3000/rewards/redeemed/$userId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> rewardsJson = json.decode(response.body)['redeemedRewards'];
      return rewardsJson
          .map((json) => Reward.fromJson(json['reward']))
          .toList();
    } else {
      throw Exception('Failed to load redeemed rewards: ${response.body}');
    }
  }

  // RANKING PROVIDER - Fetch all leagues with their associated categories
  Future<List<RankingLeague>> fetchAllLeaguesWithCategories() async {
    print('++ API CALL: FETCH ALL LEAGUES WITH CATEGORIES');
    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final response = await http.get(
      Uri.parse('http://192.168.147.232:3000/ranking-leagues'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body)['leagues'];
      return jsonResponse
          .map((leagueJson) => RankingLeague.fromJson(leagueJson))
          .toList();
    } else {
      print('Error fetching leagues with categories: ${response.body}');
      throw Exception('Failed to load leagues with categories');
    }
  }

  // AUTH PROVIDER - Fetch app settings including maintenance mode and latest version
  Future<Map<String, String>> getAppSettings() async {
    print('++ API CALL: GET APP SETTINGS');

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse('http://192.168.147.232:3000/app-settings');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> settingsList = jsonDecode(response.body)['settings'];
      final Map<String, String> settings = {};
      for (var setting in settingsList) {
        settings[setting['key']] = setting['value'];
      }
      return settings;
    } else {
      print('Error fetching app settings');
      print(response.body);
      throw Exception('Failed to load app settings');
    }
  }

  //BADGES PROVIDER - Get Badges by User ID
  Future<List<BadgeItem>> getBadgesByUserId(String userId) async {
    print('++ API CALL: GET BADGES BY USER ID');

    List<BadgeItem> badges = [];

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url =
        Uri.parse('http://192.168.147.232:3000/badges/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> badgesJson = jsonDecode(response.body)['badges'];
      badges = badgesJson.map((json) => BadgeItem.fromJson(json)).toList();
    } else {
      print('Error in badges fetch');
      print(response.body);
    }
    return badges;
  }


  Future<List<BadgeItem>> getBadgesAll() async {
    List<BadgeItem> badges = [];

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url =
        Uri.parse('http://192.168.147.232:3000/badges/allbadges');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> badgesJson = jsonDecode(response.body)['badges'];
      badges = badgesJson.map((json) => BadgeItem.fromJson(json)).toList();
      print(badges);
    } else {
      print('Error in badges fetch');
      print(response.body);
    }
    return badges;
  }


  //AUTH PROVIDER - Recover Password
  Future<bool> resetPassword(
      String email, String resetToken, String newPassword) async {
    final url =
        Uri.parse('http://192.168.147.232:3000/auth/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'token': resetToken,
        'newPassword': newPassword,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Club Members Points by Period
  Future<Map<String, dynamic>> getClubMembersPointsByPeriod(
      String clubId, String period) async {
    print('++ API CALL: GET CLUB MEMBERS POINTS BY PERIOD');

    final tMateAppToken =
        await _secureStorage.read(key: 'tMateAppToken') ?? 'no token';

    final url = Uri.parse(
        'http://192.168.147.232:3000/clubs/points/$clubId?period=$period');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': tMateAppToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> membersJson = data['members'];
      return {
        'members': membersJson.cast<Map<String, dynamic>>(),
        'startDate': data['startDate'],
        'endDate': data['endDate'],
      };
    } else {
      print('Error in fetching club members points');
      print(response.body);
      return {};
    }
  }

  //AUTH PROVIDER - Update user privacy settings
  Future<User?> updatePrivacyActivitySettings(
      User currentUser, bool hasPrivateActivities) async {
    print('++ API CALL: UPDATE USER PRIVACY ACTIVITIES SETTINGS');

    final url = Uri.parse(
        'http://192.168.147.232:3000/users/${currentUser.id}');
    final body = {
      'has_private_activities': hasPrivateActivities,
    };
    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      final updatedUser = currentUser.updateFields({
        'has_private_activities': hasPrivateActivities,
      });
      return updatedUser;
    } else {
      print('Error updating notifications settings');
      print(response.body);
      return null;
    }
  }

  // COINS TRANSACTIONS PROVIDER - Fetch coin transactions by user
  Future<List<CoinTransaction>> getCoinTransactions(String userId) async {
    print('++ API CALL: FETCH COIN TRANSACTIONS');

    final url = Uri.parse(
        'http://192.168.147.232:3000/coin-transactions/user/$userId');
    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'x-token': tMateAppToken!},
    );

    if (response.statusCode == 200) {
      final List<dynamic> transactionsJson =
          jsonDecode(response.body)['transactions'];
      return transactionsJson
          .map((json) => CoinTransaction.fromJson(json))
          .toList();
    } else {
      print('Error fetching coin transactions');
      print(response.body);
      return [];
    }
  }

Future<Map<String, String>> getEvaluateDisciplineBadge(String userId, String badgeId) async {
  final url = Uri.parse('http://192.168.147.232:3000/badges/getEvaluateDisciplineBadge');



  final body = jsonEncode({'userId' : userId,'badgeId': badgeId});
  final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

  final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: body);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
  print(data['result']);
    return {
      'meetsCriteria': data['result']['meetsCriteria'].toString(),
      'consecutiveWeeks': data['result']['consecutiveWeeks'].toString(),
      'criteriaWeeks': data['result']['criteriaWeeks'].toString(),
      'type' : 'Discipline'
    };
  } else {
    throw Exception('Failed to evaluate discipline badge');
  }
}

Future<Map<String, String>> getEvaluateDistanceBadge(String userId, String badgeId) async {
  final url = Uri.parse('http://192.168.147.232:3000/badges/getEvaluateDistanceBadge');



  final body = jsonEncode({'userId' : userId,'badgeId': badgeId});
  final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

  final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'meetsCriteria': data['result']['meetsCriteria'].toString(),
      'totalDistance': data['result']['totalDistance'].toString(),
      'criteriaDistance': data['result']['criteriaDistance'].toString(),
      'type' : 'Distance'
    };
  } else {
    throw Exception('Failed to evaluate discipline badge');
  }
}


Future<Map<String, String>> getEvaluateTimeBadge(String userId, String badgeId) async {
  final url = Uri.parse('http://192.168.147.232:3000/badges/getEvaluateTimeBadge');



  final body = jsonEncode({'userId' : userId,'badgeId': badgeId});
  final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

  final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'meetsCriteria': data['result']['meetsCriteria'].toString(),
      'totalMinutes': data['result']['totalMinutes'].toString(),
      'criteriaMinutes': data['result']['criteriaMinutes'].toString(),
      'type' : 'Time'      
    };
  } else {
    throw Exception('Failed to evaluate discipline badge');
  }
}


Future<Map<String, String>> getEvaluateRankingBadge(String userId) async {
  final url = Uri.parse('http://192.168.147.232:3000/badges/getEvaluateTimeBadge');



  final body = jsonEncode({ 'userId' : userId });
  final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

  final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'meetsCriteria': data['result']['meetsCriteria'].toString(),
      'type' : 'Ranking'      
    };
  } else {
    throw Exception('Failed to evaluate discipline badge');
  }
}

Future<Map<String, String>> getEvaluateMissionBadge(String userId) async {
  final url = Uri.parse('http://192.168.147.232:3000/badges/getEvaluateMissionBadge');



  final body = jsonEncode({ 'userId' : userId });
  final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

  final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'meetsCriteria': data['result']['meetsCriteria'].toString(),
       'type' : 'Mission'       
    };
  } else {
    throw Exception('Failed to evaluate discipline badge');
  }
}

//AUTH PROVIDERS - UPDATE DEVICE HEALTH CONNECTION SETTINGS
  Future<User?> updateHealthConnection(
      User currentUser, bool isConnected) async {
    print('++ API CALL: UPDATE HEALTH CONNECTION');

    final url = Uri.parse(
        'http://192.168.147.232:3000/users/${currentUser.id}');
    final body = {
      'is_device_health_connected': isConnected,
    };
    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      print('Health connection setting updated');

      final updatedUser = currentUser.updateFields({
        'is_device_health_connected': isConnected,
      });
      return updatedUser;
    } else {
      print('Error updating health connection setting');
      print(response.body);
      return null;
    }
  }
}
