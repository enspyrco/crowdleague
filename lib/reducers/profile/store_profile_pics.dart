import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreProfilePicsReducer extends TypedReducer<AppState, StoreProfilePics> {
  StoreProfilePicsReducer()
      : super((state, action) {
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
          appStateBuilder.profilePage.profilePics =
              action.profilePics.toBuilder();

          return appStateBuilder.build();
        });
}
