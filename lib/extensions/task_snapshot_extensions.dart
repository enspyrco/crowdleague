import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/extensions/task_state_extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';

extension ConvertToReduxAction on TaskSnapshot {
  UpdateUploadTask toUpdateUploadTask() {
    return UpdateUploadTask(
        state: state.toUpdateUploadTask(),
        bytesTransferred: bytesTransferred,
        uuid: metadata.name);
  }
}
