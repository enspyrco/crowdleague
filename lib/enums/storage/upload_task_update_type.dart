import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/app/serializers.dart';

part 'upload_task_update_type.g.dart';

class UploadTaskUpdateType extends EnumClass {
  static Serializer<UploadTaskUpdateType> get serializer =>
      _$uploadTaskUpdateTypeSerializer;
  static const UploadTaskUpdateType setup = _$setup;
  static const UploadTaskUpdateType resume = _$resume;
  static const UploadTaskUpdateType progress = _$progress;
  static const UploadTaskUpdateType pause = _$pause;
  static const UploadTaskUpdateType success = _$success;
  static const UploadTaskUpdateType failure = _$failure;
  static const Map<UploadTaskUpdateType, int> _$indexMap = {
    setup: 0,
    resume: 1,
    progress: 2,
    pause: 3,
    success: 4,
    failure: 5,
  };

  const UploadTaskUpdateType._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<UploadTaskUpdateType> get values => _$values;
  static UploadTaskUpdateType valueOf(String name) => _$valueOf(name);

  Object toJson() =>
      serializers.serializeWith(UploadTaskUpdateType.serializer, this);
}
