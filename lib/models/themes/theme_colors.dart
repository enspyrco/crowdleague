library theme_colors;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'theme_colors.g.dart';

abstract class ThemeColors implements Built<ThemeColors, ThemeColorsBuilder> {
  int get primary;
  int get secondary;
  @nullable
  int get error;

  ThemeColors._();

  factory ThemeColors([void Function(ThemeColorsBuilder) updates]) =
      _$ThemeColors;

  static final crowdleague = ThemeColors((b) => b
    ..primary = 0xFF992222
    ..secondary = 0xFFDD5555);

  static final greyscale = ThemeColors((b) => b
    ..primary = 0xFFAAAAAA
    ..secondary = 0xFF999999);

  Object toJson() => serializers.serializeWith(ThemeColors.serializer, this);

  static ThemeColors fromJson(String jsonString) => serializers.deserializeWith(
      ThemeColors.serializer, json.decode(jsonString));

  static Serializer<ThemeColors> get serializer => _$themeColorsSerializer;
}
