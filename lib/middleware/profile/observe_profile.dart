import 'package:crowdleague/actions/profile/observe_profile.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class ObserveProfileMiddleware
    extends TypedMiddleware<AppState, ObserveProfile> {
  ObserveProfileMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          // The database service's stream controller is connected to the store on
          // app load.
          // Here we ask the database service to connect the stream controller to the
          // database.
          databaseService.observeProfile(store.state.user.id);
        });
}
