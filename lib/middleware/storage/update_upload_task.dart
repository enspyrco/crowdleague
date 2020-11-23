import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/problems/upload_task_failure_problem.dart';
import 'package:redux/redux.dart';

class UpdateUploadTaskMiddleware
    extends TypedMiddleware<AppState, UpdateUploadTask> {
  UpdateUploadTaskMiddleware()
      : super((store, action, next) async {
          next(action);

          if (action.state == UploadTaskState.error) {
            store.dispatch(
              AddProblem(
                problem: UploadTaskFailureProblem.by(
                  (b) => b
                    ..message =
                        'There was a problem uploading file name ${action.uuid}, ${action.failure}'
                    ..info = MapBuilder<String, Object>(
                        {'failure': action.failure, 'uuid': action.uuid}),
                ),
              ),
            );
          }
        });
}
