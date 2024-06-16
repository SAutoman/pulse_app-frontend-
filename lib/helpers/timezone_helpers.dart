import 'package:timezone/timezone.dart' as tz;

void testingDates() {
  const createdAtTimezone = '2023-12-12T14:24:45.653-05:00';
  DateTime flutterDate = DateTime.tryParse(createdAtTimezone)!;
  tz.TZDateTime timezoneDate = tz.TZDateTime.parse(
      tz.getLocation('America/Bogota'), '2023-12-12T14:24:45.653-05:00');

  print('Flutter date: $flutterDate');
  print('Flutter offset: ${flutterDate.timeZoneOffset}');
  print('Flutter timezone: ${flutterDate.timeZoneName}');

  print('Timezone Date: ${timezoneDate.toIso8601String()}');
  print('Timezone Date: ${timezoneDate.hour.toString()}');
}

tz.TZDateTime convertWithTimezone(DateTime date, String timezone) {
  final location = tz.getLocation(timezone.substring(12));
  return tz.TZDateTime.from(date, location);
}

tz.TZDateTime convertWithTimezoneFromString(String dateISO, String timezone) {
  final location = tz.getLocation(timezone.substring(12));
  return tz.TZDateTime.parse(location, dateISO);
}

int weekNumber(DateTime date, String timezone) {
  final location = tz.getLocation(timezone.substring(12));

  final dateTimezoned = tz.TZDateTime.from(date, location);

  final firstDayOfYear = tz.TZDateTime(location, dateTimezoned.year, 1, 1);
  final days = dateTimezoned.difference(firstDayOfYear).inDays;
  final currentWeekNumber = (days / 7).floor() + 1; // Add 1 to start from 1
  return currentWeekNumber;
}
