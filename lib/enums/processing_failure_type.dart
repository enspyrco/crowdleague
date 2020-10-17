import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'processing_failure_type.g.dart';

class ProcessingFailureType extends EnumClass {
  static const ProcessingFailureType on_profile_pic = _$on_profile_pic;
  static const ProcessingFailureType on_delete_profile_pic =
      _$on_delete_profile_pic;

  const ProcessingFailureType._(String name) : super(name);

  static final _$indexMap = BuiltMap<ProcessingFailureType, int>(
      {on_profile_pic: 0, on_delete_profile_pic: 1});
  int get index => _$indexMap[this];

  static BuiltSet<ProcessingFailureType> get values => _$values;
  static ProcessingFailureType valueOf(String name) => _$valueOf(name);

  static Serializer<ProcessingFailureType> get serializer =>
      _$processingFailureTypeSerializer;

  Object toJson() =>
      serializers.serializeWith(ProcessingFailureType.serializer, this);
}
