import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

import 'package:crowdleague/extensions/extensions.dart';

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
  // get the index of the profile pic
  final index = state.profilePage.profilePics.indexOf(action.pic);

  // update the item in the list to have the deleting state
  return state.rebuild((b) => b
    ..profilePage.profilePics[index] =
        b.profilePage.profilePics[index].rebuild((b) => b..deleting = true));
}

/// [UpdateProfilePage] holds values to be set or null
/// Only non-null values are used as updates
AppState _updateProfilePage(AppState state, UpdateProfilePage action) {
  final stateBuilder = state.toBuilder();

  // if the update included removing a 'delete' state, update the list item
  // - this is done separately with an initial null check to avoid iterating
  // over the list each time the reducer is run
  if (action.removeDeletingState != null) {
    stateBuilder.profilePage.profilePics.updateWhere(
        (pic) => pic == action.removeDeletingState, (b) => b..deleting = false);
  }

  if (action.selectingProfilePic != null) {
    if (action.selectingProfilePic &&
        state.profilePage.profilePics.length < 2) {
      // if there are not two or more pics to select from, don't respond to action
    } else {
      stateBuilder.profilePage.selectingProfilePic = action.selectingProfilePic;
    }
  }

  // update each member of state.profilePage if the action has a value
  stateBuilder.update((b) => b
    ..profilePage.pickingProfilePic =
        action.pickingProfilePic ?? b.profilePage.pickingProfilePic
    ..profilePage.uploadingProfilePicId =
        action.uploadingProfilePicId ?? b.profilePage.uploadingProfilePicId
    ..profilePage.userId = action.userId ?? b.profilePage.userId
    ..profilePage.leaguerPhotoURL =
        action.leaguerPhotoURL ?? b.profilePage.leaguerPhotoURL);

  return stateBuilder.build();
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
    for (final profilePic in action.profilePics) {
      if (uploadId == profilePic.id) {
        mapBuilder.removeWhere((upId, _) => upId == uploadId);
        if (state.profilePage.uploadingProfilePicId == uploadId) {
          appStateBuilder.profilePage.uploadingProfilePicId = null;
        }
      }
    }
  }

  // add the profile pics to the app state
  appStateBuilder.profilePage.profilePics = action.profilePics.toBuilder();

  return appStateBuilder.build();
}
