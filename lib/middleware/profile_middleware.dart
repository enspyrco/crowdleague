import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/actions/profile/disregard_profile.dart';
import 'package:crowdleague/actions/profile/disregard_profile_pics.dart';
import 'package:crowdleague/actions/profile/observe_profile.dart';
import 'package:crowdleague/actions/profile/observe_profile_pics.dart';
import 'package:crowdleague/actions/profile/select_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/profile/upload_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:crowdleague/services/navigation_service.dart';
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
    DeviceService deviceService,
    NavigationService navigationService}) {
  return [
    TypedMiddleware<AppState, PickProfilePic>(
      _pickProfilePic(deviceService),
    ),
    TypedMiddleware<AppState, UploadProfilePic>(
      _uploadProfilePic(storageService),
    ),
    TypedMiddleware<AppState, ObserveProfilePics>(
      _observeProfilePics(databaseService),
    ),
    TypedMiddleware<AppState, DisregardProfilePics>(
      _disregardProfilePics(databaseService),
    ),
    TypedMiddleware<AppState, ObserveProfile>(
      _observeProfile(databaseService),
    ),
    TypedMiddleware<AppState, DisregardProfile>(
      _disregardProfile(databaseService),
    ),
    TypedMiddleware<AppState, SelectProfilePic>(
      _updateLeaguer(databaseService),
    ),
    TypedMiddleware<AppState, DeleteProfilePic>(
      _deleteProfilePic(databaseService, navigationService),
    ),
  ];
}

/// If a ProfilePic is being picked or uploaded we swallow the action and
/// don't start an upload
void Function(Store<AppState> store, PickProfilePic action, NextDispatcher next)
    _pickProfilePic(DeviceService deviceService) {
  return (Store<AppState> store, PickProfilePic action,
      NextDispatcher next) async {
    // check that we are not picking or uploading
    if (!store.state.profilePage.pickingProfilePic &&
        store.state.profilePage.uploadingProfilePicId == null) {
      next(action);

      final filePath = await deviceService.pickProfilePic();
      store.dispatch(UpdateProfilePage((b) => b..pickingProfilePic = false));
      if (filePath != null) {
        store.dispatch(UploadProfilePic((b) => b..filePath = filePath));
      }
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

void Function(
        Store<AppState> store, ObserveProfilePics action, NextDispatcher next)
    _observeProfilePics(DatabaseService databaseService) {
  return (Store<AppState> store, ObserveProfilePics action,
      NextDispatcher next) async {
    next(action);

    // The database service has a stream controller whose stream is connected
    // to the store on app load.
    // Here we ask the database service to connect the stream controller to the
    // database.
    databaseService.observeProfilePics(store.state.user.id);
  };
}

void Function(
        Store<AppState> store, DisregardProfilePics action, NextDispatcher next)
    _disregardProfilePics(DatabaseService databaseService) {
  return (Store<AppState> store, DisregardProfilePics action,
      NextDispatcher next) async {
    next(action);

    databaseService.disregardProfilePics();
  };
}

void Function(Store<AppState> store, ObserveProfile action, NextDispatcher next)
    _observeProfile(DatabaseService databaseService) {
  return (Store<AppState> store, ObserveProfile action,
      NextDispatcher next) async {
    next(action);

    // The database service's stream controller is connected to the store on
    // app load.
    // Here we ask the database service to connect the stream controller to the
    // database.
    databaseService.observeProfile(store.state.user.id);
  };
}

void Function(
        Store<AppState> store, DisregardProfile action, NextDispatcher next)
    _disregardProfile(DatabaseService databaseService) {
  return (Store<AppState> store, DisregardProfile action,
      NextDispatcher next) async {
    next(action);

    databaseService.disregardProfile();
  };
}

void Function(
        Store<AppState> store, SelectProfilePic action, NextDispatcher next)
    _updateLeaguer(DatabaseService databaseService) {
  return (Store<AppState> store, SelectProfilePic action,
      NextDispatcher next) async {
    next(action);

    final reaction =
        await databaseService.updateLeaguer(store.state.user.id, action.picId);

    if (reaction != null) store.dispatch(reaction);
  };
}

void Function(
        Store<AppState> store, DeleteProfilePic action, NextDispatcher next)
    _deleteProfilePic(
        DatabaseService databaseService, NavigationService navigationService) {
  return (Store<AppState> store, DeleteProfilePic action,
      NextDispatcher next) async {
    next(action);

    final confirmed = await navigationService.displayConfirmation(
        'Are you sure you want to delete your profile pic?');

    if (confirmed) {
      final reaction = await databaseService.deleteProfilePic(
          store.state.user.id, action.pic.id);

      // If deleteProfilePic completed successfully, reaction is null and
      // observeProfilePics will fire to update the list.
      // Non-null reaction means and AddProblem action needs to be dispatched
      if (reaction != null) store.dispatch(reaction);
    } else {
      // action.pic.id
      store.dispatch(UpdateProfilePage(
          (b) => b..removeDeletingState = action.pic.toBuilder()));
    }
  };
}
