library update_storage_task_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/storage/update_storage_task_type.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'update_storage_task_info.g.dart';

/// Either converted from a [FirebaseStorage.StorageTaskEvent] or created
/// directly (eg. the first event has type [UpdateStorageTaskType.setup] and has
/// the uuid that is used to identify the upload task in each subsequent event)
abstract class UpdateStorageTaskInfo extends Object
    with ReduxAction
    implements Built<UpdateStorageTaskInfo, UpdateStorageTaskInfoBuilder> {
  // Used to link the file in storage, the task info in memory and the db entry
  String get uuid;

  // Each StorageTaskEvent has the equivalent of the following members
  UpdateStorageTaskType get type;
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

  UpdateStorageTaskInfo._();

  factory UpdateStorageTaskInfo(
          [void Function(UpdateStorageTaskInfoBuilder) updates]) =
      _$UpdateStorageTaskInfo;

  Object toJson() =>
      serializers.serializeWith(UpdateStorageTaskInfo.serializer, this);

  static UpdateStorageTaskInfo fromJson(String jsonString) =>
      serializers.deserializeWith(
          UpdateStorageTaskInfo.serializer, json.decode(jsonString));

  static Serializer<UpdateStorageTaskInfo> get serializer =>
      _$updateStorageTaskInfoSerializer;

  @override
  String toString() => 'UPDATE_STORAGE_TASK_INFO';
}
