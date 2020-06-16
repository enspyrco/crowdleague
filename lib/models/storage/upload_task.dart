library upload_task;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/storage/upload_error.dart';

part 'upload_task.g.dart';

abstract class UploadTask implements Built<UploadTask, UploadTaskBuilder> {
  String get uuid;
  String get filePath;
  UploadTaskState get state;
  @nullable
  UploadError get error;
  @nullable
  int get bytesTransferred;
  @nullable
  int get totalByteCount;

  // The session Uri, valid for approximately one week, can be used to
  // resume an upload later by passing this value into an upload.
  @nullable
  Uri get uploadSessionUri;

  UploadTask._();

  factory UploadTask([void Function(UploadTaskBuilder) updates]) = _$UploadTask;

  Object toJson() => serializers.serializeWith(UploadTask.serializer, this);

  static UploadTask fromJson(String jsonString) => serializers.deserializeWith(
      UploadTask.serializer, json.decode(jsonString));

  static Serializer<UploadTask> get serializer => _$uploadTaskSerializer;
}
