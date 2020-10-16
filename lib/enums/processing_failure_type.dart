import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'processing_failure_type.g.dart';

class ProcessingFailureType extends EnumClass {
  static Serializer<ProcessingFailureType> get serializer =>
      _$processingFailureTypeSerializer;
  static const ProcessingFailureType on_profile_pic = _$on_profile_pic;
  static const ProcessingFailureType on_delete_profile_pic =
      _$on_delete_profile_pic;
  static const Map<ProcessingFailureType, int> _$indexMap = {
    on_profile_pic: 0,
    on_delete_profile_pic: 1
  };

  const ProcessingFailureType._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<ProcessingFailureType> get values => _$values;
  static ProcessingFailureType valueOf(String name) => _$valueOf(name);

  Object toJson() =>
      serializers.serializeWith(ProcessingFailureType.serializer, this);
}
