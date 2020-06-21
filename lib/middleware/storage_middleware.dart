import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/enums/storage/upload_task_update_type.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:redux/redux.dart';

/// Typedefs for middleware return types (makes declarations cleaner and easier
/// to read)
typedef CheckUpdateUploadTaskMiddleware = void Function(
    Store<AppState> store, UpdateUploadTask action, NextDispatcher next);

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createStorageMiddleware(
    {StorageService storageService, NavigationService navigationService}) {
  return [
    TypedMiddleware<AppState, UpdateUploadTask>(
      _checkUpdateUploadTask(navigationService),
    ),
  ];
}

///
CheckUpdateUploadTaskMiddleware _checkUpdateUploadTask(
        NavigationService navigationService) =>
    (store, action, next) async {
      next(action);
      if (action.type == UploadTaskUpdateType.failure) {
        store.dispatch(
          AddProblem.from(
              message:
                  'There was a problem uploading file name ${action.uuid}, ${action.failure}',
              type: ProblemType.uploadTaskFailure,
              info: BuiltMap({'failure': action.failure, 'uuid': action.uuid}),
              state: store.state),
        );
      }
    };
