import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/actions/leaguers/retrieve_leaguers.dart';
import 'package:crowdleague/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createLeaguersMiddleware(
    {DatabaseService databaseService}) {
  return [
    TypedMiddleware<AppState, RetrieveLeaguers>(
      _retrieveLeaguers(databaseService),
    ),
  ];
}

void Function(
        Store<AppState> store, RetrieveLeaguers action, NextDispatcher next)
    _retrieveLeaguers(DatabaseService leaguersService) {
  return (Store<AppState> store, RetrieveLeaguers action,
      NextDispatcher next) async {
    next(action);

    //
    store.dispatch(UpdateNewConversationPage(
        (b) => b..state = NewConversationPageLeaguersState.waiting));
    store.dispatch(await leaguersService.retrieveLeaguers);
    store.dispatch(UpdateNewConversationPage(
        (b) => b..state = NewConversationPageLeaguersState.ready));
  };
}
