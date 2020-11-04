import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/storage/upload_task.dart';
import 'package:redux/redux.dart';

class UpdateUploadTaskReducer extends TypedReducer<AppState, UpdateUploadTask> {
  UpdateUploadTaskReducer()
      : super((state, action) {
          // If there was a failure, a message has been displayed via middleware so
          // we remove the UploadTask and reset the profile page uploading UI
          if (action.failure != null) {
            return state.rebuild((b) => b
              ..uploadTasksMap.remove(action.uuid)
              ..profilePage.uploadingProfilePicId = null);
          }

          final newStateBuilder = state.toBuilder();
          final taskBuilder =
              newStateBuilder.uploadTasksMap[action.uuid]?.toBuilder() ??
                  UploadTaskBuilder();

          // use the event type to set the storage task state
          switch (action.state) {
            case UploadTaskState.setup:
              taskBuilder.state = UploadTaskState.setup;
              taskBuilder.filePath = action.filePath;
              break;
            case UploadTaskState.running:
              taskBuilder.state = UploadTaskState.running;
              break;
            case UploadTaskState.paused:
              taskBuilder.state = UploadTaskState.paused;
              break;
            case UploadTaskState.success:
              taskBuilder.state = UploadTaskState.processing;
              break;
            case UploadTaskState.error:
              taskBuilder.state = UploadTaskState.error;
              break;
          }

          taskBuilder.uuid = action.uuid ?? taskBuilder.uuid;
          taskBuilder.bytesTransferred =
              action.bytesTransferred ?? taskBuilder.bytesTransferred;
          taskBuilder.totalByteCount =
              action.totalByteCount ?? taskBuilder.totalByteCount;
          taskBuilder.uploadSessionUri =
              action.uploadSessionUri ?? taskBuilder.uploadSessionUri;

          newStateBuilder.uploadTasksMap[action.uuid] = taskBuilder.build();

          return newStateBuilder.build();
        });
}
