library theme_values;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/enums/themes/brightness_mode.dart';
import 'package:crowdleague/models/enums/themes/theme_brightness.dart';

part 'theme_values.g.dart';

abstract class ThemeValues implements Built<ThemeValues, ThemeValuesBuilder> {
  int get primaryColor;
  int get secondaryColor;
  @nullable
  int get errorColor;
  ThemeBrightness get themeBrightness;
  BrightnessMode get brightnessMode;

  ThemeValues._();

  factory ThemeValues([void Function(ThemeValuesBuilder) updates]) =
      _$ThemeValues;

  Object toJson() => serializers.serializeWith(ThemeValues.serializer, this);

  static ThemeValues fromJson(String jsonString) => serializers.deserializeWith(
      ThemeValues.serializer, json.decode(jsonString));

  static Serializer<ThemeValues> get serializer => _$themeValuesSerializer;
}
