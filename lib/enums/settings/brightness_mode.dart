import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'brightness_mode.g.dart';

class BrightnessMode extends EnumClass {
  static const BrightnessMode light = _$light;
  static const BrightnessMode dark = _$dark;
  static const BrightnessMode system = _$system;

  const BrightnessMode._(String name) : super(name);

  static final _$indexMap =
      BuiltMap<BrightnessMode, int>({light: 0, dark: 1, system: 2});
  int get index => _$indexMap[this];

  static BuiltSet<BrightnessMode> get values => _$values;
  static BrightnessMode valueOf(String name) => _$valueOf(name);

  bool get isLight => this == BrightnessMode.light;
  bool get isDark => this == BrightnessMode.dark;
  bool get isSystem => this == BrightnessMode.system;

  static Serializer<BrightnessMode> get serializer =>
      _$brightnessModeSerializer;

  Object toJson() => serializers.serializeWith(BrightnessMode.serializer, this);
}
