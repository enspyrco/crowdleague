import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/store_profile_leaguer.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

final profileReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, StoreProfileLeaguer>(_storeProfileLeaguer),
  TypedReducer<AppState, PickProfilePic>(_setPickingProfilePic),
  TypedReducer<AppState, UpdateProfilePage>(_updateProfilePage),
];

AppState _storeProfileLeaguer(AppState state, StoreProfileLeaguer action) {
  return state.rebuild((b) => b..profilePage.leaguer.replace(action.leaguer));
}

AppState _setPickingProfilePic(AppState state, PickProfilePic action) {
  return state.rebuild((b) => b..profilePage.pickingProfilePic = true);
}

AppState _updateProfilePage(AppState state, UpdateProfilePage action) {
  return state.rebuild((b) => b
    ..profilePage.pickingProfilePic =
        action.pickingProfilePic ?? b.profilePage.pickingProfilePic
    ..profilePage.profilePicUploadId =
        action.profilePicUploadId ?? b.profilePage.profilePicUploadId);
}
