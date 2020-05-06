import 'package:crowdleague/models/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/models/actions/leaguers/retrieve_leaguers.dart';
import 'package:crowdleague/models/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/services/leaguers_service.dart';
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
    {LeaguersService leaguersService}) {
  return [
    TypedMiddleware<AppState, RetrieveLeaguers>(
      _retrieveLeaguers(leaguersService),
    ),
  ];
}

void Function(
        Store<AppState> store, RetrieveLeaguers action, NextDispatcher next)
    _retrieveLeaguers(LeaguersService leaguersService) {
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
