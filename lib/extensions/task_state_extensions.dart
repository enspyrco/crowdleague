import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:firebase_storage/firebase_storage.dart';

extension Convert on TaskState {
  static final taskStateMap = <TaskState, UploadTaskState>{
    TaskState.paused: UploadTaskState.paused,
    TaskState.running: UploadTaskState.running,
    TaskState.success: UploadTaskState.success,
    TaskState.canceled: UploadTaskState.canceled,
    TaskState.error: UploadTaskState.error
  };

  UploadTaskState toUpdateUploadTask() => taskStateMap[this];
}
