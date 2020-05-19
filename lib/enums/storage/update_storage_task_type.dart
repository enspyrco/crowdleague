import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/app/serializers.dart';

part 'update_storage_task_type.g.dart';

class UpdateStorageTaskType extends EnumClass {
  static Serializer<UpdateStorageTaskType> get serializer =>
      _$updateStorageTaskTypeSerializer;
  static const UpdateStorageTaskType setup = _$setup;
  static const UpdateStorageTaskType resume = _$resume;
  static const UpdateStorageTaskType progress = _$progress;
  static const UpdateStorageTaskType pause = _$pause;
  static const UpdateStorageTaskType success = _$success;
  static const UpdateStorageTaskType failure = _$failure;
  static const Map<UpdateStorageTaskType, int> _$indexMap = {
    setup: 0,
    resume: 1,
    progress: 2,
    pause: 3,
    success: 4,
    failure: 5,
  };

  const UpdateStorageTaskType._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<UpdateStorageTaskType> get values => _$values;
  static UpdateStorageTaskType valueOf(String name) => _$valueOf(name);

  Object toJson() =>
      serializers.serializeWith(UpdateStorageTaskType.serializer, this);
}
