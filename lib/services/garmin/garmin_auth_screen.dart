import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pulse_mate_app/models/server_responses/athlete_garmin_response.dart';

class GarminHelpers  {
  static Future<AthleteGarminResponse?> getProfileInfo(
      String accessToken) async {
    final url = Uri.parse(
        'https://healthapi.garmin.com/wellness-api/rest/user/profile');

    
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final AthleteGarminResponse athleteGarminResponse =
          AthleteGarminResponse.fromJson(jsonDecode(response.body));

      return athleteGarminResponse;
    }
    return null;
    //TODO:Validar que el response este OK, si no hacer algo
  }
}
