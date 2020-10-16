import 'package:crowdleague/actions/profile/disregard_profile.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class DisregardProfileMiddleware
    extends TypedMiddleware<AppState, DisregardProfile> {
  DisregardProfileMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          databaseService.disregardProfile();
        });
}
