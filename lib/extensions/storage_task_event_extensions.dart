import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_update_type.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'storage_task_snapshot_extensions.dart';

extension ConvertToReduxAction on StorageTaskEvent {
  UpdateUploadTask toUpdateUploadTask() {
    UploadTaskUpdateType convertedType;
    switch (type) {
      case StorageTaskEventType.resume:
        convertedType = UploadTaskUpdateType.resume;
        break;
      case StorageTaskEventType.progress:
        convertedType = UploadTaskUpdateType.progress;
        break;
      case StorageTaskEventType.pause:
        convertedType = UploadTaskUpdateType.pause;
        break;
      case StorageTaskEventType.success:
        convertedType = UploadTaskUpdateType.success;
        break;
      case StorageTaskEventType.failure:
        convertedType = UploadTaskUpdateType.failure;
        break;
    }

    return UpdateUploadTask((b) => b
      ..type = convertedType
      ..failure = snapshot.getUploadFailure()?.toBuilder()
      ..bytesTransferred = snapshot.bytesTransferred
      ..totalByteCount = snapshot.totalByteCount
      ..uploadSessionUri = snapshot.uploadSessionUri
      ..uuid = snapshot.storageMetadata.name);
  }
}
