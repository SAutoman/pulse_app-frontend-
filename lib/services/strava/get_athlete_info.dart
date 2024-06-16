import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pulse_mate_app/models/server_responses/athlete_strava_response.dart';

class StravaHelpers {
  static Future<AthleteStravaResponse?> getAthleteInfo(
      String accessToken) async {
    final url = Uri.parse(
        'https://www.strava.com/api/v3/athlete?access_token=$accessToken');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });
    

    if (response.statusCode == 200) {
      final AthleteStravaResponse athleteStravaResponse =
          AthleteStravaResponse.fromJson(jsonDecode(response.body));

      return athleteStravaResponse;
    }
    return null;
    //TODO:Validar que el response este OK, si no hacer algo
  }
}
