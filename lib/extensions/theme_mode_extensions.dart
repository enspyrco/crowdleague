import 'package:crowdleague/enums/settings/brightness_mode.dart';
import 'package:flutter/material.dart';

extension ThemeModeExt on ThemeMode {
  static ThemeMode from(BrightnessMode brightness) {
    return (brightness.isLight)
        ? ThemeMode.light
        : (brightness.isDark)
            ? ThemeMode.dark
            : ThemeMode.system;
  }
}
