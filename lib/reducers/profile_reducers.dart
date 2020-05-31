import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

final profileReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, PickProfilePic>(_setPickingProfilePic),
  TypedReducer<AppState, UpdateProfilePage>(_updateProfilePage),
  TypedReducer<AppState, StoreProfilePics>(_storeProfilePics),
  TypedReducer<AppState, DeleteProfilePic>(_setDeletingProfilePic),
];

AppState _setPickingProfilePic(AppState state, PickProfilePic action) {
  return state.rebuild((b) => b..profilePage.pickingProfilePic = true);
}

AppState _setDeletingProfilePic(AppState state, DeleteProfilePic action) {
  return state
      .rebuild((b) => b..profilePage.deletingProfilePicIds.add(action.picId));
}

AppState _updateProfilePage(AppState state, UpdateProfilePage action) {
  return state.rebuild((b) => b
    ..profilePage.selectingProfilePic =
        action.selectingProfilePic ?? b.profilePage.selectingProfilePic
    ..profilePage.pickingProfilePic =
        action.pickingProfilePic ?? b.profilePage.pickingProfilePic
    ..profilePage.uploadingProfilePicId =
        action.uploadingProfilePicId ?? b.profilePage.uploadingProfilePicId
    ..profilePage.userId = action.userId ?? b.profilePage.userId
    ..profilePage.leaguerPhotoURL =
        action.leaguerPhotoURL ?? b.profilePage.leaguerPhotoURL);
}

AppState _storeProfilePics(AppState state, StoreProfilePics action) {
  // TODO: make this more efficient, try:
  // - find the new profile pic and just deal with it
  // - set a specific upload completed entry in the cloud function and react to that
  // - keep the upload tasks in the database and have cloud function update there
  //
  // Match profile pic id(s) against (a) appState.uploadTasksMap and
  // (b) profilePage.uploadingProfilePicId and remove if matches
  final mapBuilder = state.uploadTasksMap.toBuilder();
  final appStateBuilder = state.toBuilder();
  for (final uploadId in state.uploadTasksMap.keys) {
    for (final profilePicId in action.profilePicIds) {
      if (uploadId == profilePicId) {
        mapBuilder.removeWhere((upId, _) => upId == uploadId);
        if (state.profilePage.uploadingProfilePicId == uploadId) {
          appStateBuilder.profilePage.uploadingProfilePicId = null;
        }
      }
    }
  }

  // add the profile pics to the app state
  appStateBuilder.profilePage.profilePicIds = action.profilePicIds.toBuilder();

  return appStateBuilder.build();
}
