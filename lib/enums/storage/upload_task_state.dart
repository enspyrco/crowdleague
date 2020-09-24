import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'upload_task_state.g.dart';

class UploadTaskState extends EnumClass {
  static Serializer<UploadTaskState> get serializer =>
      _$uploadTaskStateSerializer;
  static const UploadTaskState setup = _$setup;
  static const UploadTaskState inProgress = _$inProgress;
  static const UploadTaskState processing = _$processing;
  static const UploadTaskState processingComplete = _$processingComplete;
  static const UploadTaskState paused = _$paused;
  static const UploadTaskState resumed = _$resumed;
  static const UploadTaskState failed = _$failed;
  static const Map<UploadTaskState, int> _$indexMap = {
    setup: 0,
    inProgress: 1,
    processing: 2,
    processingComplete: 3,
    paused: 4,
    resumed: 5,
    failed: 6,
  };

  const UploadTaskState._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<UploadTaskState> get values => _$values;
  static UploadTaskState valueOf(String name) => _$valueOf(name);

  Object toJson() =>
      serializers.serializeWith(UploadTaskState.serializer, this);
}
