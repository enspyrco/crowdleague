import 'package:crowdleague/actions/profile/retrieve_profile_leaguer.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createProfileMiddleware(
    {DatabaseService databaseService}) {
  return [
    TypedMiddleware<AppState, RetrieveProfileLeaguer>(
      _retrieveProfileLeaguer(databaseService),
    ),
  ];
}

void Function(Store<AppState> store, RetrieveProfileLeaguer action,
        NextDispatcher next)
    _retrieveProfileLeaguer(DatabaseService databaseService) {
  return (Store<AppState> store, RetrieveProfileLeaguer action,
      NextDispatcher next) async {
    next(action);

    final reaction = await databaseService.retrieveLeaguer(store.state.user.id);

    store.dispatch(reaction);
  };
}
