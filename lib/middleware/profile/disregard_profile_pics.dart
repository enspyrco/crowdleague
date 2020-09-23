import 'package:crowdleague/actions/profile/disregard_profile_pics.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

class DisregardProfilePicsMiddleware
    extends TypedMiddleware<AppState, DisregardProfilePics> {
  DisregardProfilePicsMiddleware(DatabaseService databaseService)
      : super((store, action, next) async {
          next(action);

          databaseService.disregardProfilePics();
        });
}
