library storage_task_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/storage/storage_task_state.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'storage_task_info.g.dart';

abstract class StorageTaskInfo
    implements Built<StorageTaskInfo, StorageTaskInfoBuilder> {
  String get uuid;
  StorageTaskState get state;
  @nullable
  int get error;
  @nullable
  int get bytesTransferred;
  @nullable
  int get totalByteCount;

  // The session Uri, valid for approximately one week, can be used to
  // resume an upload later by passing this value into an upload.
  @nullable
  Uri get uploadSessionUri;

  StorageTaskInfo._();

  factory StorageTaskInfo([void Function(StorageTaskInfoBuilder) updates]) =
      _$StorageTaskInfo;

  Object toJson() =>
      serializers.serializeWith(StorageTaskInfo.serializer, this);

  static StorageTaskInfo fromJson(String jsonString) => serializers
      .deserializeWith(StorageTaskInfo.serializer, json.decode(jsonString));

  static Serializer<StorageTaskInfo> get serializer =>
      _$storageTaskInfoSerializer;
}
