import 'package:crowdleague/actions/profile/observe_profile_pics.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class ObserveProfilePicsMiddleware
    extends TypedMiddleware<AppState, ObserveProfilePics> {
  ObserveProfilePicsMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          // The database service has a stream controller whose stream is connected
          // to the store on app load.
          // Here we ask the database service to connect the stream controller to the
          // database.
          databaseService.observeProfilePics(store.state.user.id);
        });
}
