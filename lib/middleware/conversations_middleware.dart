import 'package:crowdleague/models/actions/conversations/create_conversation.dart';
import 'package:crowdleague/services/conversations_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

typedef CreateConversationMiddleware = void Function(
    Store<AppState> store, CreateConversation action, NextDispatcher next);

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createConversationsMiddleware(
    {ConversationsService conversationsService}) {
  return [
    TypedMiddleware<AppState, CreateConversation>(
      _createConversation(conversationsService),
    ),
  ];
}

CreateConversationMiddleware _createConversation(
    ConversationsService conversationService) {
  return (Store<AppState> store, CreateConversation action,
      NextDispatcher next) async {
    next(action);

    /// [createConversation] returns a [Future] of either
    /// a [StoreSelectedConversation] or [AddProblem]
    store.dispatch(await conversationService.createConversation(
        store.state.user.id,
        store.state.newConversationsPage.selectionsVM.selections));
  };
}
