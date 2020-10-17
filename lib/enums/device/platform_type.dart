import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'platform_type.g.dart';

/// Enum class for platform values
class PlatformType extends EnumClass {
  static const PlatformType checking = _$checking;
  static const PlatformType android = _$android;
  static const PlatformType ios = _$ios;
  static const PlatformType macOS = _$macOS;

  const PlatformType._(String name) : super(name);

  static final _$indexMap =
      BuiltMap<PlatformType, int>({checking: 0, android: 1, ios: 2, macOS: 3});
  int get index => _$indexMap[this];

  static BuiltSet<PlatformType> get values => _$values;
  static PlatformType valueOf(String name) => _$valueOf(name);

  static Serializer<PlatformType> get serializer => _$platformTypeSerializer;

  Object toJson() => serializers.serializeWith(PlatformType.serializer, this);
}
