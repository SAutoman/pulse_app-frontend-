import 'package:intl/intl.dart';
import 'package:pulse_mate_app/models/mission_model.dart';

String formatDayMonthYear(DateTime date) {
  final dateFormat = DateFormat('dd MMM yyyy');
  return dateFormat.format(date);
}

String formatDayMonthYearTime(DateTime date) {
  final dateFormat = DateFormat('dd MMM yyyy - hh:mm a');
  return dateFormat.format(date);
}

String formatOnlytime(DateTime date) {
  final dateFormat = DateFormat('hh:mm a');
  return dateFormat.format(date);
}

String formatDayNameMonthYear(DateTime date) {
  final dateFormat = DateFormat('EEE, dd MMM yyyy');
  return dateFormat.format(date);
}

String formatTimeframe(Mission mission) {
  // Parse the initial and end day strings into DateTime objects.
  DateTime initialDateTime = DateTime.parse(mission.initialDay);
  DateTime endDateTime = DateTime.parse(mission.endDay);

  // Define a function to format a single DateTime object.
  String formatDate(DateTime dateTime) {
    // Create a map of month numbers to month abbreviations.
    const months = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    // Use the map to get the month abbreviation from the DateTime object.
    String month = months[dateTime.month] ?? 'Unknown';

    // Return the formatted date string, e.g., "01 Jan".
    return '${dateTime.day.toString().padLeft(2, '0')} $month';
  }

  // Format the initial and end dates and combine them with a hyphen.
  return '${formatDate(initialDateTime)} - ${formatDate(endDateTime)}';
}
