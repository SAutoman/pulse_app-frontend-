import 'package:flutter/material.dart';
import 'package:pulse_mate_app/utils/color_schemes.dart';
import 'package:pulse_mate_app/utils/text_themes.dart';

class CustomThemes {
  static double horizontalPadding = 24.0;

  static ThemeData mainTheme = ThemeData(
    // colorScheme: lightColorScheme,
    useMaterial3: true,
    // primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorSchemeSeed: kPrimaryColor,

    //TextFields
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kGreyColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
        labelStyle: baseRegular,
        hintStyle: baseRegular.copyWith(color: kGreyDarkColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(96),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(96),
          borderSide: const BorderSide(
              width: 1, style: BorderStyle.solid, color: kPrimaryColor),
        )),
  );
}
