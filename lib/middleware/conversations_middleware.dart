import 'package:crowdleague/actions/conversations/create_conversation.dart';
import 'package:crowdleague/actions/conversations/disregard_conversations.dart';
import 'package:crowdleague/actions/conversations/disregard_messages.dart';
import 'package:crowdleague/actions/conversations/leave_conversation.dart';
import 'package:crowdleague/actions/conversations/observe_conversations.dart';
import 'package:crowdleague/actions/conversations/observe_messages.dart';
import 'package:crowdleague/actions/conversations/save_message.dart';
import 'package:crowdleague/actions/problems/add_problem.dart';
import 'package:crowdleague/actions/navigation/navigator_replace_current.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

typedef CreateConversationMiddleware = void Function(
    Store<AppState> store, CreateConversation action, NextDispatcher next);
typedef ObserveConversationsMiddleware = void Function(
    Store<AppState> store, ObserveConversations action, NextDispatcher next);
typedef DisregardConversationsMiddleware = void Function(
    Store<AppState> store, DisregardConversations action, NextDispatcher next);
typedef SaveMessageMiddleware = void Function(
    Store<AppState> store, SaveMessage action, NextDispatcher next);
typedef ObserveMessagesMiddleware = void Function(
    Store<AppState> store, ObserveMessages action, NextDispatcher next);
typedef DisregardMessagesMiddleware = void Function(
    Store<AppState> store, DisregardMessages action, NextDispatcher next);
typedef LeaveConversationMiddleware = void Function(
    Store<AppState> store, LeaveConversation action, NextDispatcher next);

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
    {DatabaseService databaseService}) {
  return [
    TypedMiddleware<AppState, CreateConversation>(
      _createConversation(databaseService),
    ),
    TypedMiddleware<AppState, ObserveConversations>(
      _observeConversations(databaseService),
    ),
    TypedMiddleware<AppState, DisregardConversations>(
      _disregardConversations(databaseService),
    ),
    TypedMiddleware<AppState, SaveMessage>(
      _saveMessage(databaseService),
    ),
    TypedMiddleware<AppState, ObserveMessages>(
      _observeMessages(databaseService),
    ),
    TypedMiddleware<AppState, DisregardMessages>(
      _disregardMessages(databaseService),
    ),
    TypedMiddleware<AppState, LeaveConversation>(
      _leaveConversation(databaseService),
    ),
  ];
}

CreateConversationMiddleware _createConversation(
    DatabaseService databaseService) {
  return (Store<AppState> store, CreateConversation action,
      NextDispatcher next) async {
    next(action);

    /// [databaseService.createConversation] returns a [Future] of either
    /// a [StoreSelectedConversation] or [AddProblem]
    final reaction = await databaseService.createConversation(
        store.state.user.id,
        store.state.newConversationsPage.selectionsVM.selections);
    store.dispatch(reaction);

    // if there was no problem, navigate to Conversation Page
    if (reaction.runtimeType != AddProblem) {
      store.dispatch(
          NavigatorReplaceCurrent((b) => b..newLocation = '/conversation'));
    }
  };
}

ObserveConversationsMiddleware _observeConversations(
    DatabaseService databaseService) {
  return (Store<AppState> store, ObserveConversations action,
      NextDispatcher next) async {
    next(action);

    databaseService.observeConversations(store.state.user.id);
  };
}

DisregardConversationsMiddleware _disregardConversations(
    DatabaseService databaseService) {
  return (Store<AppState> store, DisregardConversations action,
      NextDispatcher next) async {
    next(action);

    databaseService.disregardConversations();
  };
}

SaveMessageMiddleware _saveMessage(DatabaseService databaseService) {
  return (Store<AppState> store, SaveMessage action,
      NextDispatcher next) async {
    next(action);

    /// the function calls listen on the firestore and keeps the stream open
    /// until disregardMessages is called
    databaseService.saveMessage(store);
  };
}

ObserveMessagesMiddleware _observeMessages(DatabaseService databaseService) {
  return (Store<AppState> store, ObserveMessages action,
      NextDispatcher next) async {
    next(action);

    /// the function calls listen on the firestore and keeps the stream open
    /// until disregardMessages is called
    databaseService
        .observeMessages(store.state.conversationPage.summary.conversationId);
  };
}

DisregardMessagesMiddleware _disregardMessages(
    DatabaseService databaseService) {
  return (Store<AppState> store, DisregardMessages action,
      NextDispatcher next) async {
    next(action);

    /// the function calls listen on the firestore and keeps the stream open
    /// until disregardMessages is called
    databaseService.disregardMessages(store);
  };
}

LeaveConversationMiddleware _leaveConversation(
    DatabaseService databaseService) {
  return (Store<AppState> store, LeaveConversation action,
      NextDispatcher next) async {
    next(action);

    /// returns a Future<void>, currently no need to do anything when the
    /// future completes as the list has been updated locally already
    await databaseService.leaveConversation(
        store.state.user.id, action.conversationId);
  };
}
