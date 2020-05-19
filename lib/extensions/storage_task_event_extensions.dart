import 'package:crowdleague/actions/storage/update_storage_task_info.dart';
import 'package:crowdleague/enums/storage/update_storage_task_type.dart';
import 'package:firebase_storage/firebase_storage.dart';

extension ConvertToReduxAction on StorageTaskEvent {
  UpdateStorageTaskInfo toReduxAction() {
    UpdateStorageTaskType convertedType;
    switch (type) {
      case StorageTaskEventType.resume:
        convertedType = UpdateStorageTaskType.resume;
        break;
      case StorageTaskEventType.progress:
        convertedType = UpdateStorageTaskType.progress;
        break;
      case StorageTaskEventType.pause:
        convertedType = UpdateStorageTaskType.pause;
        break;
      case StorageTaskEventType.success:
        convertedType = UpdateStorageTaskType.success;
        break;
      case StorageTaskEventType.failure:
        convertedType = UpdateStorageTaskType.failure;
        break;
    }

    return UpdateStorageTaskInfo((b) => b
      ..type = convertedType
      ..error = snapshot.error
      ..bytesTransferred = snapshot.bytesTransferred
      ..totalByteCount = snapshot.totalByteCount
      ..uploadSessionUri = snapshot.uploadSessionUri
      ..uuid = snapshot.storageMetadata.name);
  }
}
