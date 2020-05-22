import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/retrieve_profile_leaguer.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/storage/upload_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
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
List<Middleware<AppState>> createProfileMiddleware(
    {DatabaseService databaseService,
    StorageService storageService,
    DeviceService deviceService}) {
  return [
    TypedMiddleware<AppState, RetrieveProfileLeaguer>(
      _retrieveProfileLeaguer(databaseService),
    ),
    TypedMiddleware<AppState, PickProfilePic>(
      _pickProfilePic(deviceService),
    ),
    TypedMiddleware<AppState, UploadProfilePic>(
      _uploadProfilePic(storageService),
    ),
  ];
}

void Function(Store<AppState> store, RetrieveProfileLeaguer action,
        NextDispatcher next)
    _retrieveProfileLeaguer(DatabaseService databaseService) {
  return (Store<AppState> store, RetrieveProfileLeaguer action,
      NextDispatcher next) async {
    next(action);

    final reaction = await databaseService.retrieveLeaguer(store.state.user.id);

    store.dispatch(reaction);
  };
}

void Function(Store<AppState> store, PickProfilePic action, NextDispatcher next)
    _pickProfilePic(DeviceService deviceService) {
  return (Store<AppState> store, PickProfilePic action,
      NextDispatcher next) async {
    next(action);

    final filePath = await deviceService.pickProfilePic();
    if (filePath == null) {
      store.dispatch(UpdateProfilePage((b) => b..pickingProfilePic = false));
    } else {
      store.dispatch(UpdateProfilePage((b) => b..pickingProfilePic = false));
      store.dispatch(UploadProfilePic((b) => b..filePath = filePath));
    }
  };
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
