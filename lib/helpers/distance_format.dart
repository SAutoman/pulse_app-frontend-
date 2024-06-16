String formatDistance(double meters) {
  if (meters < 1000) {
    // If less than 1 kilometer, return in meters
    return "${meters.round()} m";
  } else {
    // If 1 kilometer or more, convert to kilometers and format with 1 decimal place
    double kilometers = meters / 1000;
    return "${kilometers.toStringAsFixed(1)} km";
  }
}

String formatSpeedToPace(double metersPerSecond, String sportType) {
  if (metersPerSecond == 0) {
    return sportType == "Swim"
        ? "∞ min/100m"
        : "∞ min/km"; // Infinite time for zero speed
  }

  if (sportType == "Ride" || sportType == "VirtualRide") {
    // For riding, return the speed in km/h
    double kmPerHour = metersPerSecond * 3.6;
    return "${kmPerHour.toStringAsFixed(1)} km/h"; // Format to 2 decimal places
  }

  double pacePerUnit; // Pace per kilometer or per 100 meters

  if (sportType == "Swim") {
// For swimming, calculate the pace per 100 meters
    pacePerUnit =
        (100 / metersPerSecond) / 60; // pace in minutes per 100 meters
  } else {
// For other sports, calculate the pace per kilometer
    double kmPerHour = metersPerSecond * 3.6;
    pacePerUnit = 60 / kmPerHour; // pace in minutes per kilometer
  }

// Convert to minutes and seconds
  int totalSeconds = (pacePerUnit * 60).round();
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;

// Formatting the result to mm:ss
  String formattedPace =
      "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

  return sportType == "Swim"
      ? "$formattedPace min/100m"
      : "$formattedPace min/km";
}
