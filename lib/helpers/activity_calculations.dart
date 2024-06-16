import 'package:pulse_mate_app/helpers/date_format_helper.dart';
import 'package:pulse_mate_app/helpers/timezone_helpers.dart';
import 'package:pulse_mate_app/models/activity_model.dart';

String sumMovingTime(List<Activity> activities) {
  int totalSeconds =
      activities.fold(0, (int sum, activity) => sum + activity.movingTime);
  if (totalSeconds < 3600) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes}m:${seconds.toString().padLeft(2, '0')}s';
  } else {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    return '${hours}h:${minutes.toString().padLeft(2, '0')}m';
  }
}

Map<String, List<Activity>> groupActivitiesByDate(
    List<Activity> activities, String timezone) {
  Map<String, List<Activity>> groupedActivities = {};
  for (var activity in activities) {
    String dateKey = formatDayNameMonthYear(convertWithTimezoneFromString(
        activity.startDateUserTimezone, timezone));
    if (groupedActivities[dateKey] == null) {
      groupedActivities[dateKey] = [];
    }
    groupedActivities[dateKey]!.add(activity);
  }
  return groupedActivities;
}
