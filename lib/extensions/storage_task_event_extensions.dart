import 'package:crowdleague/actions/storage/update_upload_task_info.dart';
import 'package:crowdleague/enums/storage/update_upload_task_type.dart';
import 'package:firebase_storage/firebase_storage.dart';

extension ConvertToReduxAction on StorageTaskEvent {
  UpdateUploadTaskInfo toUpdateUploadTaskInfo() {
    UpdateUploadTaskType convertedType;
    switch (type) {
      case StorageTaskEventType.resume:
        convertedType = UpdateUploadTaskType.resume;
        break;
      case StorageTaskEventType.progress:
        convertedType = UpdateUploadTaskType.progress;
        break;
      case StorageTaskEventType.pause:
        convertedType = UpdateUploadTaskType.pause;
        break;
      case StorageTaskEventType.success:
        convertedType = UpdateUploadTaskType.success;
        break;
      case StorageTaskEventType.failure:
        convertedType = UpdateUploadTaskType.failure;
        break;
    }

    return UpdateUploadTaskInfo((b) => b
      ..type = convertedType
      ..error = snapshot.error
      ..bytesTransferred = snapshot.bytesTransferred
      ..totalByteCount = snapshot.totalByteCount
      ..uploadSessionUri = snapshot.uploadSessionUri
      ..uuid = snapshot.storageMetadata.name);
  }
}
