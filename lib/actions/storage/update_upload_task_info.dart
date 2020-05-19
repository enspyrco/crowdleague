library update_upload_task_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/storage/update_upload_task_type.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'update_upload_task_info.g.dart';

/// Either converted from a [FirebaseStorage.StorageTaskEvent] or created
/// directly (eg. the first event has type [UpdateUploadTaskType.setup] and has
/// the uuid that is used to identify the upload task in each subsequent event)
abstract class UpdateUploadTaskInfo extends Object
    with ReduxAction
    implements Built<UpdateUploadTaskInfo, UpdateUploadTaskInfoBuilder> {
  // Used to link the file in storage, the task info in memory and the db entry
  String get uuid;

  // Each StorageTaskEvent has the equivalent of the following members
  UpdateUploadTaskType get type;
  @nullable
  int get error;
  @nullable
  int get bytesTransferred;
  @nullable
  int get totalByteCount;
  @nullable
  Uri get uploadSessionUri;

  // Each StorageTaskEvent also has the following members that have (for now)
  // not been added to the conversion
  // final StorageReference ref;
  // final StorageMetadata storageMetadata;

  UpdateUploadTaskInfo._();

  factory UpdateUploadTaskInfo(
          [void Function(UpdateUploadTaskInfoBuilder) updates]) =
      _$UpdateUploadTaskInfo;

  Object toJson() =>
      serializers.serializeWith(UpdateUploadTaskInfo.serializer, this);

  static UpdateUploadTaskInfo fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateUploadTaskInfo.serializer, json.decode(jsonString));

  static Serializer<UpdateUploadTaskInfo> get serializer =>
      _$updateUploadTaskInfoSerializer;

  @override
  String toString() => 'UPDATE_UPLOAD_TASK_INFO';
}
