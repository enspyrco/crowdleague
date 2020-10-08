import 'package:crowdleague/enums/settings/theme_brightness.dart';
import 'package:crowdleague/models/settings/theme_set.dart';
import 'package:flutter/material.dart';

// static functions must be called on the extension name, ie. ThemeDataExt
extension ThemeDataExt on ThemeData {
  static ThemeData from(ThemeSet themeSet) {
    if (themeSet.brightness == ThemeBrightness.light &&
        themeSet.colors.error == null) {
      return ThemeData.from(
          colorScheme: ColorScheme.light(
        primary: Color(themeSet.colors.primary),
        secondary: Color(themeSet.colors.secondary),
      ));
    } else if (themeSet.brightness == ThemeBrightness.light &&
        themeSet.colors.error != null) {
      return ThemeData.from(
          colorScheme: ColorScheme.light(
              primary: Color(themeSet.colors.primary),
              secondary: Color(themeSet.colors.secondary),
              error: Color(themeSet.colors.error)));
    } else if (themeSet.brightness == ThemeBrightness.dark &&
        themeSet.colors.error == null) {
      return ThemeData.from(
          colorScheme: ColorScheme.dark(
        primary: Color(themeSet.colors.primary),
        secondary: Color(themeSet.colors.secondary),
      ));
    } else if (themeSet.brightness == ThemeBrightness.dark &&
        themeSet.colors.error != null) {
      return ThemeData.from(
          colorScheme: ColorScheme.dark(
              primary: Color(themeSet.colors.primary),
              secondary: Color(themeSet.colors.secondary),
              error: Color(themeSet.colors.error)));
    }
    return null;
  }
}
