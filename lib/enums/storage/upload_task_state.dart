import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'upload_task_state.g.dart';

class UploadTaskState extends EnumClass {
  static const UploadTaskState setup = _$setup;
  static const UploadTaskState inProgress = _$inProgress;
  static const UploadTaskState processing = _$processing;
  static const UploadTaskState processingComplete = _$processingComplete;
  static const UploadTaskState paused = _$paused;
  static const UploadTaskState running = _$running;
  static const UploadTaskState success = _$success;
  static const UploadTaskState canceled = _$canceled;
  static const UploadTaskState error = _$error;

  const UploadTaskState._(String name) : super(name);

  static final _$indexMap = BuiltMap<UploadTaskState, int>({
    setup: 0,
    inProgress: 1,
    processing: 2,
    processingComplete: 3,
    paused: 4,
    running: 5,
    success: 6,
    canceled: 7,
    error: 8,
  });
  int get index => _$indexMap[this];

  static BuiltSet<UploadTaskState> get values => _$values;
  static UploadTaskState valueOf(String name) => _$valueOf(name);

  static Serializer<UploadTaskState> get serializer =>
      _$uploadTaskStateSerializer;

  Object toJson() =>
      serializers.serializeWith(UploadTaskState.serializer, this);
}
