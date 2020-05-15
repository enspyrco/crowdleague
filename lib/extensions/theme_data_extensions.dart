import 'package:crowdleague/models/app/theme_values.dart';
import 'package:crowdleague/models/enums/themes/theme_brightness.dart';
import 'package:flutter/material.dart';

// static functions must be called on the extension name, ie. ThemeDataExt
extension ThemeDataExt on ThemeData {
  static ThemeData fromValues(ThemeValues values) {
    if (values.themeBrightness == ThemeBrightness.light &&
        values.errorColor == null) {
      return ThemeData.from(
          colorScheme: ColorScheme.light(
              primary: Color(values.primaryColor),
              secondary: Color(values.secondaryColor)));
    }
    if (values.themeBrightness == ThemeBrightness.light &&
        values.errorColor != null) {
      return ThemeData.from(
          colorScheme: ColorScheme.light(
              primary: Color(values.primaryColor),
              secondary: Color(values.secondaryColor),
              error: Color(values.errorColor)));
    }
    if (values.themeBrightness == ThemeBrightness.dark &&
        values.errorColor == null) {
      return ThemeData.from(
          colorScheme: ColorScheme.dark(
              primary: Color(values.primaryColor),
              secondary: Color(values.secondaryColor)));
    }
    if (values.themeBrightness == ThemeBrightness.dark &&
        values.errorColor != null) {
      return ThemeData.from(
          colorScheme: ColorScheme.dark(
              primary: Color(values.primaryColor),
              secondary: Color(values.secondaryColor),
              error: Color(values.errorColor)));
    }

    // we shouldn't ever get here but makes the analyzer happy
    return null;
  }
}
