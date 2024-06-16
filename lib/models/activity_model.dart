class Activity {
  final String id;
  final String createdAt;
  final String createdAtUserTimezone;
  final String stravaId;
  final String name;
  final double distance;
  final int movingTime;
  final int elapsedTime;
  final double totalElevationGain;
  final String type;
  final String sportType;
  final String startDate;
  final String startDateLocal;
  final String startDateUserTimezone;
  final String timezone;
  final int utcOffset;
  final String? locationCity;
  final String? locationState;
  final String? locationCountry;
  final String? workoutType;
  final int achievementCount;
  final int kudosCount;
  final int commentCount;
  final int athleteCount;
  final int photoCount;
  final String visibility;
  final bool manual;
  final bool isPrivate;
  final bool hasHeartrate;
  final double averageHeartrate;
  final int maxHeartrate;
  final int calories;
  final Map<String, dynamic> map;
  final double? averageSpeed;
  final double? maxSpeed;
  final double? averageCadence;
  final double? averageTemp;
  final double? averageWatts;
  final double? weightedAverageWatts;
  final double? kilojoules;
  final bool? deviceWatts;
  final double elevHigh;
  final double elevLow;
  final String deviceName;
  final List<double> startLatlng;
  final List<double> endLatlng;
  final bool isValid;
  final String? invalidMesssage;
  final String userId;
  final int weekUserTimezone;
  final int yearUserTimezone;
  final double calculatedMet;
  final int calculatedPoints;

  Activity({
    required this.id,
    required this.createdAt,
    required this.createdAtUserTimezone,
    required this.stravaId,
    required this.name,
    required this.distance,
    required this.movingTime,
    required this.elapsedTime,
    required this.totalElevationGain,
    required this.type,
    required this.sportType,
    required this.startDate,
    required this.startDateLocal,
    required this.startDateUserTimezone,
    required this.timezone,
    required this.utcOffset,
    required this.locationCity,
    required this.locationState,
    required this.locationCountry,
    required this.workoutType,
    required this.achievementCount,
    required this.kudosCount,
    required this.commentCount,
    required this.athleteCount,
    required this.photoCount,
    required this.visibility,
    required this.manual,
    required this.isPrivate,
    required this.hasHeartrate,
    required this.averageHeartrate,
    required this.maxHeartrate,
    required this.calories,
    required this.map,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.averageCadence,
    required this.averageTemp,
    required this.averageWatts,
    required this.weightedAverageWatts,
    required this.kilojoules,
    required this.deviceWatts,
    required this.elevHigh,
    required this.elevLow,
    required this.deviceName,
    required this.startLatlng,
    required this.endLatlng,
    required this.isValid,
    required this.invalidMesssage,
    required this.userId,
    required this.weekUserTimezone,
    required this.yearUserTimezone,
    required this.calculatedMet,
    required this.calculatedPoints,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      createdAt: json['created_at'],
      createdAtUserTimezone: json['created_at_user_timezone'],
      stravaId: json['strava_id'],
      name: json['name'],
      distance: json['distance'].toDouble(),
      movingTime: json['moving_time'],
      elapsedTime: json['elapsed_time'],
      totalElevationGain: json['total_elevation_gain'].toDouble(),
      type: json['type'],
      sportType: json['sport_type'],
      startDate: json['start_date'],
      startDateLocal: json['start_date_local'],
      startDateUserTimezone: json['start_date_user_timezone'],
      timezone: json['timezone'],
      utcOffset: json['utc_offset'],
      locationCity: json['location_city'],
      locationState: json['location_state'],
      locationCountry: json['location_country'],
      workoutType: json['workout_type'],
      achievementCount: json['achievement_count'],
      kudosCount: json['kudos_count'],
      commentCount: json['comment_count'],
      athleteCount: json['athlete_count'],
      photoCount: json['photo_count'],
      visibility: json['visibility'],
      manual: json['manual'],
      isPrivate: json['is_private'],
      hasHeartrate: json['has_heartrate'],
      averageHeartrate: json['average_heartrate'].toDouble(),
      maxHeartrate: json['max_heartrate'],
      calories: json['calories'],
      map: Map<String, dynamic>.from(json['map']),
      averageSpeed: json['average_speed'] != null
          ? json['average_speed'].toDouble()
          : null,
      maxSpeed: json['max_speed'] != null ? json['max_speed'].toDouble() : null,
      averageCadence: json['average_cadence'] != null
          ? json['average_cadence'].toDouble()
          : null,
      averageTemp:
          json['average_temp'] != null ? json['average_temp'].toDouble() : null,
      averageWatts: json['average_watts'] != null
          ? json['average_watts'].toDouble()
          : null,
      weightedAverageWatts: json['weighted_average_watts'] != null
          ? json['weighted_average_watts'].toDouble()
          : null,
      kilojoules:
          json['kilojoules'] != null ? json['kilojoules'].toDouble() : null,
      deviceWatts: json['device_watts'],
      elevHigh: json['elev_high'] != null ? json['elev_high'].toDouble() : 0.0,
      elevLow: json['elev_low'] != null ? json['elev_low'].toDouble() : 0.0,
      deviceName: json['device_name'] ?? '',
      startLatlng: List<double>.from(json['start_latlng']),
      endLatlng: List<double>.from(json['end_latlng']),
      isValid: json['is_valid'],
      invalidMesssage: json['invalid_messsage'],
      weekUserTimezone: json['week_user_timezone'],
      yearUserTimezone: json['year_user_timezone'],
      userId: json['userId'],
      calculatedMet: json['calculated_met'].toDouble(),
      calculatedPoints: json['calculated_points'],
    );
  }
}
