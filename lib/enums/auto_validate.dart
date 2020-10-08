import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/utils/serializers.dart';

part 'auto_validate.g.dart';

class AutoValidate extends EnumClass {
  static Serializer<AutoValidate> get serializer => _$autoValidateSerializer;
  static const AutoValidate disabled = _$disabled;
  static const AutoValidate always = _$always;
  static const AutoValidate onUserInteraction = _$onUserInteraction;
  static const Map<AutoValidate, int> _$indexMap = {
    disabled: 0,
    always: 1,
    onUserInteraction: 2
  };

  const AutoValidate._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<AutoValidate> get values => _$values;
  static AutoValidate valueOf(String name) => _$valueOf(name);

  Object toJson() => serializers.serializeWith(AutoValidate.serializer, this);
}
