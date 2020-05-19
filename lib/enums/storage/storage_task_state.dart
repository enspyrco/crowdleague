import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/app/serializers.dart';

part 'storage_task_state.g.dart';

class StorageTaskState extends EnumClass {
  static Serializer<StorageTaskState> get serializer =>
      _$storageTaskStateSerializer;
  static const StorageTaskState setup = _$setup;
  static const StorageTaskState inProgress = _$inProgress;
  static const StorageTaskState complete = _$complete;
  static const StorageTaskState paused = _$paused;
  static const StorageTaskState resumed = _$resumed;
  static const StorageTaskState failed = _$failed;
  static const Map<StorageTaskState, int> _$indexMap = {
    setup: 0,
    inProgress: 1,
    complete: 2,
    paused: 3,
    resumed: 4,
    failed: 5,
  };

  const StorageTaskState._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<StorageTaskState> get values => _$values;
  static StorageTaskState valueOf(String name) => _$valueOf(name);

  Object toJson() =>
      serializers.serializeWith(StorageTaskState.serializer, this);
}
