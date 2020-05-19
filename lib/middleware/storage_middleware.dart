import 'package:crowdleague/actions/storage/upload_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:redux/redux.dart';

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
    {StorageService storageService}) {
  return [
    TypedMiddleware<AppState, UploadProfilePic>(
      _uploadProfilePic(storageService),
    ),
  ];
}

void Function(
        Store<AppState> store, UploadProfilePic action, NextDispatcher next)
    _uploadProfilePic(StorageService storageService) {
  return (Store<AppState> store, UploadProfilePic action,
      NextDispatcher next) async {
    next(action);

    final stream =
        storageService.uploadProfilePic(store.state.user.id, action.filePath);

    stream.listen((event) {
      store.dispatch(event);
    });
  };
}
