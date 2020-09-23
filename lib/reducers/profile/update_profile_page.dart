import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// [UpdateProfilePage] holds values to be set or null
/// Only non-null values are used as updates
class UpdateProfilePageReducer
    extends TypedReducer<AppState, UpdateProfilePage> {
  UpdateProfilePageReducer()
      : super((state, action) {
          final stateBuilder = state.toBuilder();

          // if the update included removing a 'delete' state, update the list item
          // - this is done separately with an initial null check to avoid iterating
          // over the list each time the reducer is run
          if (action.removeDeletingState != null) {
            stateBuilder.profilePage.profilePics.updateWhere(
                (pic) => pic == action.removeDeletingState,
                (b) => b..deleting = false);
          }

          if (action.selectingProfilePic != null) {
            if (action.selectingProfilePic &&
                state.profilePage.profilePics.length < 2) {
              // if there are not two or more pics to select from, don't respond to action
            } else {
              stateBuilder.profilePage.selectingProfilePic =
                  action.selectingProfilePic;
            }
          }

          // update each member of state.profilePage if the action has a value
          stateBuilder.update((b) => b
            ..profilePage.pickingProfilePic =
                action.pickingProfilePic ?? b.profilePage.pickingProfilePic
            ..profilePage.uploadingProfilePicId =
                action.uploadingProfilePicId ??
                    b.profilePage.uploadingProfilePicId
            ..profilePage.userId = action.userId ?? b.profilePage.userId
            ..profilePage.leaguerPhotoURL =
                action.leaguerPhotoURL ?? b.profilePage.leaguerPhotoURL);

          return stateBuilder.build();
        });
}
