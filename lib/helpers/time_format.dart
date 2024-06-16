String formatMinutesToHours(double minutes) {
  // Calculate hours
  int hours = minutes ~/ 60;
  // Calculate remaining minutes without the fractional part
  int remainingMinutes = minutes % 60 ~/ 1;

  // Build the output string conditionally
  String timeString = '';
  if (hours > 0) {
    timeString += "${hours}h";
  }
  if (remainingMinutes > 0) {
    // Add a colon only if hours are present
    timeString += "${hours > 0 ? ':' : ''}${remainingMinutes}m";
  }

  // Handle case where all are zero
  if (timeString.isEmpty) {
    timeString = "0m";
  }

  return timeString;
}
