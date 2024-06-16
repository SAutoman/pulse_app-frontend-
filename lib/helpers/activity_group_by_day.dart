import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulse_mate_app/models/activity_model.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:timezone/timezone.dart' as tz;

Map<String, dynamic> groupCaloriesBySportTypeAndDay(
    List<Activity> activities, String userTimezone) {
//Set the user timezone
  tz.Location userLocation = tz.getLocation(userTimezone.substring(12));

  // Step 1: Find the earliest and latest dates and unique sport types
  tz.TZDateTime? earliestDate;
  tz.TZDateTime? latestDate;
  Set<String> sportTypes = {};
  int maxPoints = 0; // Variable to track maximum calories

  for (var activity in activities) {
    tz.TZDateTime activityDate =
        tz.TZDateTime.parse(userLocation, activity.startDateUserTimezone);
    earliestDate = earliestDate == null
        ? activityDate
        : (activityDate.isBefore(earliestDate) ? activityDate : earliestDate);
    latestDate = latestDate == null
        ? activityDate
        : (activityDate.isAfter(latestDate) ? activityDate : latestDate);
    sportTypes.add(activity.type);
  }

  // Step 2: Generate list of dates between earliest and latest dates
  List<tz.TZDateTime> dateRange = [];
  tz.TZDateTime currentDate = tz.TZDateTime(
      userLocation, earliestDate!.year, earliestDate.month, earliestDate.day);
  while (currentDate.isBefore(
    tz.TZDateTime(
        userLocation, latestDate!.year, latestDate.month, latestDate.day + 1),
  )) {
    dateRange.add(currentDate);
    currentDate = currentDate.add(const Duration(days: 1));
  }

  // Step 3: Initialize the map to store results
  Map<String, Map<String, int>> pointsBySportTypeAndDay = {};

  // Format for displaying the date
  DateFormat formatter = DateFormat('dd MMM');

  for (var date in dateRange) {
    String formattedDate = formatter.format(date);

    pointsBySportTypeAndDay[formattedDate] = {};

    for (var activity in activities) {
      tz.TZDateTime activityDate =
          tz.TZDateTime.parse(userLocation, activity.startDateUserTimezone);
      if (activityDate.day == date.day &&
          activityDate.month == date.month &&
          activityDate.year == date.year) {
        int currentPoints = pointsBySportTypeAndDay[formattedDate]!.update(
          activity.type,
          (calories) => calories + activity.calculatedPoints,
          ifAbsent: () => activity.calculatedPoints,
        );
        // Update maxCalories here
        if (currentPoints > maxPoints) {
          maxPoints = currentPoints;
        }
      }
    }
  }

  // Step 4: Fill days with no activities with zeros
  for (var date in dateRange) {
    String formattedDate = formatter.format(date);

    if (pointsBySportTypeAndDay[formattedDate]!.isEmpty) {
      pointsBySportTypeAndDay[formattedDate]!['Other'] = 0;
    }
  }

  // Assign a specific color to each sport type based on the order
  Map<String, Color> colorMap = {};
  List<Color> predefinedColors = [
    kPrimaryLightColor,
    kOrangeLightColor,
    kYellowLightColor,
    kPurpleLightColor
  ];

  int colorIndex = 0;
  for (var type in sportTypes) {
    Color color;
    if (colorIndex < predefinedColors.length) {
      color = predefinedColors[colorIndex];
    } else {
      color = kGreyDarkColor;
    }
    colorMap[type] = color;
    colorIndex++;
  }

  return {
    'caloriesData': pointsBySportTypeAndDay,
    'colorMap': colorMap,
    'maxCalories': maxPoints,
  };
}
