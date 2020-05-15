import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/app/theme_values.dart';
import 'package:crowdleague/models/enums/themes/brightness_mode.dart';
import 'package:crowdleague/models/enums/themes/theme_brightness.dart';

part 'theme_option.g.dart';

class ThemeOption extends EnumClass {
  static Serializer<ThemeOption> get serializer => _$themeOptionSerializer;
  static const ThemeOption crowdleague_light = _$crowdleague_light;
  static const ThemeOption crowdleague_dark = _$crowdleague_dark;
  static const ThemeOption greyscale_light = _$greyscale_light;
  static const ThemeOption greyscale_dark = _$greyscale_dark;

  // a map to allow .index calls
  static const Map<ThemeOption, int> _indexMap = {
    crowdleague_light: 0,
    crowdleague_dark: 1,
    greyscale_light: 2,
    greyscale_dark: 3
  };
  int get index => _indexMap[this];

  // a map to allow .themeValues calls
  static final BuiltMap<ThemeOption, ThemeValues> _themeValuesMap =
      BuiltMap(<ThemeOption, ThemeValues>{
    crowdleague_light: ThemeValues((b) => b
      ..themeBrightness = ThemeBrightness.light
      ..brightnessMode = BrightnessMode.light
      ..primaryColor = 0xFF992222
      ..secondaryColor = 0xFFDD5555),
    crowdleague_dark: ThemeValues((b) => b
      ..themeBrightness = ThemeBrightness.dark
      ..brightnessMode = BrightnessMode.dark
      ..primaryColor = 0xFF992222
      ..secondaryColor = 0xFFDD5555),
    greyscale_light: ThemeValues((b) => b
      ..themeBrightness = ThemeBrightness.light
      ..brightnessMode = BrightnessMode.light
      ..primaryColor = 0xFFAAAAAA
      ..secondaryColor = 0xFF999999),
    greyscale_dark: ThemeValues((b) => b
      ..themeBrightness = ThemeBrightness.dark
      ..brightnessMode = BrightnessMode.dark
      ..primaryColor = 0xFFAAAAAA
      ..secondaryColor = 0xFF999999),
  });
  ThemeValues get themeValues => _themeValuesMap[this];

  const ThemeOption._(String name) : super(name);

  static BuiltSet<ThemeOption> get values => _$values;
  static ThemeOption valueOf(String name) => _$valueOf(name);

  Object toJson() => serializers.serializeWith(ThemeOption.serializer, this);
}
