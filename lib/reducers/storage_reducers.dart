import 'package:crowdleague/actions/storage/update_upload_task_info.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/enums/storage/storage_task_state.dart';
import 'package:crowdleague/enums/storage/update_upload_task_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/problem.dart';
import 'package:crowdleague/models/storage/storage_task_info.dart';
import 'package:redux/redux.dart';

final storageReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, UpdateUploadTaskInfo>(_updateStorageTaskInfo),
];

AppState _updateStorageTaskInfo(AppState state, UpdateUploadTaskInfo action) {
  final newStateBuilder = state.toBuilder();
  final taskBuilder = newStateBuilder.storageTasks[action.uuid]?.toBuilder() ??
      StorageTaskInfoBuilder();

  // TODO: fix the issue with the 'info' member of Problem and add the error
  // integer, the uuid and other useful info to the problem
  if (action.type == UpdateUploadTaskType.failure) {
    final problem = Problem((b) => b
      ..type = ProblemType.uploadTaskFailure
      ..state = state.toBuilder()
      ..message = 'There was a problem uploading the file name ${action.uuid}');
    // TODO: use the error to get a meaningful error message
    action.error;
    newStateBuilder.problems.add(problem);
  }

  // use the event type to set the storage task state
  switch (action.type) {
    case UpdateUploadTaskType.setup:
      {
        taskBuilder.state = StorageTaskState.setup;
        break;
      }
    case UpdateUploadTaskType.resume:
      {
        taskBuilder.state = StorageTaskState.resumed;
        break;
      }
    case UpdateUploadTaskType.progress:
      {
        taskBuilder.state = StorageTaskState.inProgress;
        break;
      }
    case UpdateUploadTaskType.pause:
      {
        taskBuilder.state = StorageTaskState.paused;
        break;
      }
    case UpdateUploadTaskType.success:
      {
        taskBuilder.state = StorageTaskState.complete;
        break;
      }
    case UpdateUploadTaskType.failure:
      {
        taskBuilder.state = StorageTaskState.failed;
        break;
      }
  }

  taskBuilder.uuid = action.uuid ?? taskBuilder.uuid;
  taskBuilder.error = action.error ?? taskBuilder.error;
  taskBuilder.bytesTransferred =
      action.bytesTransferred ?? taskBuilder.bytesTransferred;
  taskBuilder.totalByteCount =
      action.totalByteCount ?? taskBuilder.totalByteCount;
  taskBuilder.uploadSessionUri =
      action.uploadSessionUri ?? taskBuilder.uploadSessionUri;

  newStateBuilder.storageTasks[action.uuid] = taskBuilder.build();

  return newStateBuilder.build();
}
