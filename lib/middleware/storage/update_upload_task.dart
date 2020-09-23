import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/enums/storage/upload_task_update_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class UpdateUploadTaskMiddleware
    extends TypedMiddleware<AppState, UpdateUploadTask> {
  UpdateUploadTaskMiddleware()
      : super((store, action, next) async {
          next(action);

          if (action.type == UploadTaskUpdateType.failure) {
            store.dispatch(
              AddProblem.from(
                  message:
                      'There was a problem uploading file name ${action.uuid}, ${action.failure}',
                  type: ProblemType.uploadTaskFailure,
                  info: BuiltMap(
                      {'failure': action.failure, 'uuid': action.uuid}),
                  state: store.state),
            );
          }
        });
}
