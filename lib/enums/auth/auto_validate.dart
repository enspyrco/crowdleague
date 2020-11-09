import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'auto_validate.g.dart';

class AutoValidate extends EnumClass {
  static const AutoValidate disabled = _$disabled;
  static const AutoValidate always = _$always;
  static const AutoValidate onUserInteraction = _$onUserInteraction;

  const AutoValidate._(String name) : super(name);

  static final _$indexMap = BuiltMap<AutoValidate, int>(
      {disabled: 0, always: 1, onUserInteraction: 2});
  int get index => _$indexMap[this];

  static BuiltSet<AutoValidate> get values => _$values;
  static AutoValidate valueOf(String name) => _$valueOf(name);

  static Serializer<AutoValidate> get serializer => _$autoValidateSerializer;

  Object toJson() => serializers.serializeWith(AutoValidate.serializer, this);
}
