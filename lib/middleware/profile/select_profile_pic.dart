import 'package:crowdleague/actions/profile/select_profile_pic.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class SelectProfilePicMiddleware
    extends TypedMiddleware<AppState, SelectProfilePic> {
  SelectProfilePicMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          final reaction = await databaseService.updateLeaguer(
              store.state.user.id, action.picId);

          if (reaction != null) store.dispatch(reaction);
        });
}
