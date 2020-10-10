library settings;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/settings/brightness_mode.dart';
import 'package:crowdleague/enums/settings/theme_brightness.dart';
import 'package:crowdleague/models/settings/theme_colors.dart';
import 'package:crowdleague/models/settings/theme_set.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'settings.g.dart';

abstract class Settings implements Built<Settings, SettingsBuilder> {
  ThemeSet get darkTheme;
  ThemeSet get lightTheme;
  BrightnessMode get brightnessMode;

  Settings._();

  static SettingsBuilder initBuilder() {
    return SettingsBuilder()
      ..darkTheme.brightness = ThemeBrightness.dark
      ..darkTheme.colors = ThemeColors.crowdleague.toBuilder()
      ..lightTheme.brightness = ThemeBrightness.light
      ..lightTheme.colors = ThemeColors.crowdleague.toBuilder()
      ..brightnessMode = BrightnessMode.light;
  }

  factory Settings(
      {@required ThemeSet darkTheme,
      @required ThemeSet lightTheme,
      @required BrightnessMode brightnessMode}) = _$Settings._;

  factory Settings.by([void Function(SettingsBuilder) updates]) = _$Settings;

  Object toJson() => serializers.serializeWith(Settings.serializer, this);

  static Settings fromJson(String jsonString) =>
      serializers.deserializeWith(Settings.serializer, json.decode(jsonString));

  static Serializer<Settings> get serializer => _$settingsSerializer;
}
