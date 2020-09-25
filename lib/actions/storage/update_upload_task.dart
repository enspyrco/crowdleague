library update_upload_task;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/storage/upload_task_update_type.dart';
import 'package:crowdleague/models/storage/upload_failure.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'update_upload_task.g.dart';

/// Either converted from a [FirebaseStorage.StorageTaskEvent] or created
/// directly (eg. the first event has type [UploadTaskUpdateType.setup] and has
/// the uuid that is used to identify the upload task in each subsequent event)
abstract class UpdateUploadTask extends Object
    with ReduxAction
    implements Built<UpdateUploadTask, UpdateUploadTaskBuilder> {
  // Used to link the file in storage, the task info in memory and the db entry
  String get uuid;

  // Each StorageTaskEvent has the equivalent of the following members
  UploadTaskUpdateType get type;

  // The local path to the file that is being uploaded
  @nullable
  String get filePath;
  @nullable
  UploadFailure get failure;
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

  UpdateUploadTask._();

  factory UpdateUploadTask(
      {@required String uuid,
      @required UploadTaskUpdateType type,
      String filePath,
      UploadFailure failure,
      int bytesTransferred,
      int totalByteCount,
      Uri uploadSessionUri}) = _$UpdateUploadTask._;

  factory UpdateUploadTask.by(
      [void Function(UpdateUploadTaskBuilder) updates]) = _$UpdateUploadTask;

  Object toJson() =>
      serializers.serializeWith(UpdateUploadTask.serializer, this);

  static UpdateUploadTask fromJson(String jsonString) => serializers
      .deserializeWith(UpdateUploadTask.serializer, json.decode(jsonString));

  static Serializer<UpdateUploadTask> get serializer =>
      _$updateUploadTaskSerializer;

  @override
  String toString() => 'UPDATE_UPLOAD_TASK';
}
