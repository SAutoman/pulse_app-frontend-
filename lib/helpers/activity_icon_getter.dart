import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

IconData getActivityIcon(String type) {
  if (type.contains(RegExp('Swim', caseSensitive: false))) {
    return Symbols.pool;
  } else if (type.contains(RegExp('Ride', caseSensitive: false))) {
    return Symbols.pedal_bike;
  } else if (type.contains(RegExp('Walk', caseSensitive: false))) {
    return Symbols.directions_walk;
  } else if (type.contains(RegExp('Run', caseSensitive: false))) {
    return Symbols.sprint;
  } else {
    return Symbols.exercise_rounded;
  }
}
