import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class DeleteProfilePicMiddleware
    extends TypedMiddleware<AppState, DeleteProfilePic> {
  DeleteProfilePicMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          final reaction = await databaseService.deleteProfilePic(
              store.state.user.id, action.pic.id);

          // If deleteProfilePic completed successfully, reaction is null and
          // observeProfilePics will fire to update the list.
          // Non-null reaction means and AddProblem action needs to be dispatched
          if (reaction != null) store.dispatch(reaction);
        });
}
