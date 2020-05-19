library storage_task_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'storage_task_info.g.dart';

abstract class StorageTaskInfo
    implements Built<StorageTaskInfo, StorageTaskInfoBuilder> {
  String get uuid;
  int get error;
  int get bytesTransferred;
  int get totalByteCount;
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
