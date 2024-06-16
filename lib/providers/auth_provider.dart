// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_mate_app/database/api_calls.dart';
import 'package:pulse_mate_app/models/sport_type.dart';

import 'package:pulse_mate_app/models/user_model.dart';
import 'package:pulse_mate_app/services/garmin/garmin_auth_screen.dart';

import 'package:pulse_mate_app/services/strava/get_athlete_info.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;
  final storage = const FlutterSecureStorage();
  final apiDatabase = ApiDatabase();

  //********* Getterd and Setters */

  //********* Functions */
  Future<bool> validateLogin() async {
    currentUser = await apiDatabase.validateLoginToken();
    if (currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logOut() async {
    await storage.delete(key: 'tMateAppToken');
    currentUser = null;
  }

  Future<bool> loginUser(String email, String password) async {
    final userResult = await apiDatabase.loginUser(email, password);

    if (userResult != null) {
      currentUser = userResult;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUser(String firstName, String lastName, String email,
      String password, String country, String timezone) async {
    final userCreated = await apiDatabase.createUser(
        firstName, lastName, email, password, country, timezone);

    if (userCreated != null) {
      currentUser = userCreated;
      return true;
    } else {
      return false;
    }
  }

  Future<void> stravaAuth(
      String accessToken, String refreshToken, int expiresAt) async {
    //Gets the user ID based on the token
    final stravaAthleteInfo = await StravaHelpers.getAthleteInfo(accessToken);
    
    if (stravaAthleteInfo != null) {
      print('Profile picture: ${stravaAthleteInfo.profile}');

      final url = Uri.parse('http://192.168.147.232:3000/strava/auth');
      final body = {
        'strava_access_token': accessToken,
        'strava_refresh_token': refreshToken,
        'strava_access_expires_at': expiresAt,
        'strava_user_id': stravaAthleteInfo.id,
        if (stravaAthleteInfo.profile != null)
          'image_url': stravaAthleteInfo.profile
      };
      final tMateAppToken = await storage.read(key: 'tMateAppToken');

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-token': tMateAppToken!
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        print('Strava info saved');
        currentUser = currentUser!.updateFields({
          'strava_connected': true,
          'strava_access_token': accessToken,
          'strava_refresh_token': refreshToken,
          'strava_access_expires_at': expiresAt,
          'strava_user_id': stravaAthleteInfo.id,
          if (stravaAthleteInfo.profile != null)
            'image_url': stravaAthleteInfo.profile
        });
        notifyListeners();
        // print('Current User Token ${currentUser!.stravaAccessToken}');
      } else {
        print('Error in saving strava info');
        print(jsonDecode(response.body));
      }
    }
  }

  Future<void> garminAuth(
     String accessToken, String refreshToken, int expiresAt) async {
    //Gets the user ID based on the token
    
    final garminAthleteInfo = await GarminHelpers.getProfileInfo(accessToken);
  
    if (garminAthleteInfo != null) {
      print('Profile picture: ${garminAthleteInfo.profile}');

      final url = Uri.parse('http://192.168.147.232:3000/garmin/garmin-auth');
      final body = {
        'garmin_access_token': accessToken,
        'garmin_refresh_token': refreshToken,
        'garmin_access_expires_at': expiresAt,
        'garmin_user_id': garminAthleteInfo.id,
        if (garminAthleteInfo.profile != null)
          'image_url': garminAthleteInfo.profile
      };
      final tMateAppToken = await storage.read(key: 'tMateAppToken');

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'x-token': tMateAppToken!
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        print('Strava info saved');
        currentUser = currentUser!.updateFields({
          'garmin_connected': true,
          'garmin_access_token': accessToken,
          'garmin_refresh_token': refreshToken,
          'garmin_access_expires_at': expiresAt,
          'garmin_user_id': garminAthleteInfo.id,
          if (garminAthleteInfo.profile != null)
            'image_url': garminAthleteInfo.profile
        });
        notifyListeners();
        // print('Current User Token ${currentUser!.stravaAccessToken}');
      } else {
        print('Error in saving strava info');
        print(jsonDecode(response.body));
      }
    }
  }


  Future<void> stravaDeauth() async {
    final url = Uri.parse('http://192.168.147.232:3000/strava/deauth');
    final tMateAppToken = await storage.read(key: 'tMateAppToken');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'x-token': tMateAppToken!},
    );

    if (response.statusCode == 200) {
      print('Strava info deleted');
      currentUser = currentUser!.updateFields({
        'strava_connected': false,
        'strava_access_token': null,
        'strava_refresh_token': null,
        'strava_access_expires_at': null,
      });
      notifyListeners();
      // print('Current User Token ${currentUser!.stravaAccessToken}');
    } else {
      print('Error in saving strava info');
      print(jsonDecode(response.body));
    }
  }

  Future<void> saveFirebaseToken() async {
    //Gets the token from the firebase messaging
    final token = await FirebaseMessaging.instance.getToken();
    final settings = await FirebaseMessaging.instance.requestPermission();
    final pushAllowed =
        settings.authorizationStatus == AuthorizationStatus.authorized
            ? true
            : false;

    if (token != null) {
      //Save it into secureStorage or compare if already exists
      final existingToken = await storage.read(key: 'fcm_token');
      if (existingToken != null) {
        if (token == existingToken &&
            token == currentUser!.fcmToken &&
            pushAllowed == currentUser!.pushNotificationAllowed) {
          //Si el token ya existe y es el mismo, no es necesario guardar en la base de datos
          return;
        }
      }

      final url = Uri.parse(
          'http://192.168.147.232:3000/users/${currentUser!.id}');
      final body = {
        'push_notifications_allowed': pushAllowed,
        'fcm_token': token,
      };
      final tMateAppToken = await storage.read(key: 'tMateAppToken');

      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'x-token': tMateAppToken!
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        print('FCM token saved in database');

        //Guardar token en secure storage
        storage.write(key: 'fcm_token', value: token);

        currentUser = currentUser!.updateFields({
          'push_notifications_allowed': true,
          'fcm_token': token,
        });
        notifyListeners();
      } else {
        print('Error in saving FCM Token');
        print(response.body);
      }
    }
  }

  Future<void> updateNotificationsSettings(
      bool emailNotif, bool pushNotif) async {
    final updatedUser = await apiDatabase.updateNotificationsSettings(
        currentUser!, emailNotif, pushNotif);

    if (updatedUser != null) {
      currentUser = updatedUser;
      notifyListeners();
    }
  }

  Future<void> deleteUserAccount() async {
    final bool userDeleted = await apiDatabase.deleteUser(currentUser!);
    if (userDeleted) {
      currentUser = null;
      notifyListeners();
    }
  }

  Future<void> refreshCurrentUser() async {
    currentUser = await apiDatabase.getUserById(currentUser!.id);
    notifyListeners();
  }

  //Update user sport
  Future<bool> updateUserSport(SportType sportType) async {
    final response =
        await ApiDatabase().updateUserSportType(currentUser!, sportType);

    if (response == true) {
      currentUser!.updateUserSport(sportType);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    final url =
        Uri.parse('http://192.168.147.232:3000/auth/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetPassword(
      String email, String resetToken, String newPassword) async {
    final response =
        await apiDatabase.resetPassword(email, resetToken, newPassword);
    return response;
  }

  Future<void> updatePrivacyActivitiesSettings(
      bool hasPrivateActivities) async {
    final updatedUser = await apiDatabase.updatePrivacyActivitySettings(
        currentUser!, hasPrivateActivities);

    if (updatedUser != null) {
      currentUser = updatedUser;
      notifyListeners();
    }
  }

  Future<void> updateHealthConnection(bool isConnected) async {
    final updatedUser =
        await apiDatabase.updateHealthConnection(currentUser!, isConnected);

    if (updatedUser != null) {
      currentUser = updatedUser;
      notifyListeners();
    }
  }
}
