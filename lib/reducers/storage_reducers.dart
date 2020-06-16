import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/enums/storage/upload_task_update_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/storage/upload_task.dart';
import 'package:redux/redux.dart';

final storageReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, UpdateUploadTask>(_updateStorageTaskInfo),
];

AppState _updateStorageTaskInfo(AppState state, UpdateUploadTask action) {
  final newStateBuilder = state.toBuilder();
  final taskBuilder =
      newStateBuilder.uploadTasksMap[action.uuid]?.toBuilder() ??
          UploadTaskBuilder();

  // use the event type to set the storage task state
  switch (action.type) {
    case UploadTaskUpdateType.setup:
      taskBuilder.state = UploadTaskState.setup;
      taskBuilder.filePath = action.filePath;
      break;
    case UploadTaskUpdateType.resume:
      taskBuilder.state = UploadTaskState.resumed;
      break;
    case UploadTaskUpdateType.progress:
      taskBuilder.state = UploadTaskState.inProgress;
      break;
    case UploadTaskUpdateType.pause:
      taskBuilder.state = UploadTaskState.paused;
      break;
    case UploadTaskUpdateType.success:
      taskBuilder.state = UploadTaskState.processing;
      break;
    case UploadTaskUpdateType.failure:
      taskBuilder.state = UploadTaskState.failed;
      break;
  }

  // no need to preserve the previous state for errors
  taskBuilder.error = action.error?.toBuilder();

  taskBuilder.uuid = action.uuid ?? taskBuilder.uuid;
  taskBuilder.bytesTransferred =
      action.bytesTransferred ?? taskBuilder.bytesTransferred;
  taskBuilder.totalByteCount =
      action.totalByteCount ?? taskBuilder.totalByteCount;
  taskBuilder.uploadSessionUri =
      action.uploadSessionUri ?? taskBuilder.uploadSessionUri;

  newStateBuilder.uploadTasksMap[action.uuid] = taskBuilder.build();

  return newStateBuilder.build();
}
