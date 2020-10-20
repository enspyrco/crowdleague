import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'theme_brightness.g.dart';

class ThemeBrightness extends EnumClass {
  static const ThemeBrightness light = _$light;
  static const ThemeBrightness dark = _$dark;

  const ThemeBrightness._(String name) : super(name);

  static final _$indexMap = BuiltMap<ThemeBrightness, int>({light: 0, dark: 1});
  int get index => _$indexMap[this];

  static BuiltSet<ThemeBrightness> get values => _$values;
  static ThemeBrightness valueOf(String name) => _$valueOf(name);

  static Serializer<ThemeBrightness> get serializer =>
      _$themeBrightnessSerializer;

  Object toJson() =>
      serializers.serializeWith(ThemeBrightness.serializer, this);
}
