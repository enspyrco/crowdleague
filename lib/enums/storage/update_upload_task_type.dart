import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/app/serializers.dart';

part 'update_upload_task_type.g.dart';

class UpdateUploadTaskType extends EnumClass {
  static Serializer<UpdateUploadTaskType> get serializer =>
      _$updateUploadTaskTypeSerializer;
  static const UpdateUploadTaskType setup = _$setup;
  static const UpdateUploadTaskType resume = _$resume;
  static const UpdateUploadTaskType progress = _$progress;
  static const UpdateUploadTaskType pause = _$pause;
  static const UpdateUploadTaskType success = _$success;
  static const UpdateUploadTaskType failure = _$failure;
  static const Map<UpdateUploadTaskType, int> _$indexMap = {
    setup: 0,
    resume: 1,
    progress: 2,
    pause: 3,
    success: 4,
    failure: 5,
  };

  const UpdateUploadTaskType._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<UpdateUploadTaskType> get values => _$values;
  static UpdateUploadTaskType valueOf(String name) => _$valueOf(name);

  Object toJson() =>
      serializers.serializeWith(UpdateUploadTaskType.serializer, this);
}
