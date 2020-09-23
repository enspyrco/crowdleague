import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';

class DeleteProfilePicMiddleware
    extends TypedMiddleware<AppState, DeleteProfilePic> {
  DeleteProfilePicMiddleware(
      DatabaseService databaseService, NavigationService navigationService)
      : super((store, action, next) async {
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
        });
}
