import 'package:crowdleague/actions/conversations/create_conversation.dart';
import 'package:crowdleague/actions/conversations/disregard_messages.dart';
import 'package:crowdleague/actions/conversations/observe_messages.dart';
import 'package:crowdleague/actions/conversations/retrieve_conversation_items.dart';
import 'package:crowdleague/actions/conversations/save_message.dart';
import 'package:crowdleague/services/conversations_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

typedef CreateConversationMiddleware = void Function(
    Store<AppState> store, CreateConversation action, NextDispatcher next);
typedef RetrieveConversationItemsMiddleware = void Function(
    Store<AppState> store,
    RetrieveConversationItems action,
    NextDispatcher next);
typedef SaveMessageMiddleware = void Function(
    Store<AppState> store, SaveMessage action, NextDispatcher next);
typedef ObserveMessagesMiddleware = void Function(
    Store<AppState> store, ObserveMessages action, NextDispatcher next);
typedef DisregardMessagesMiddleware = void Function(
    Store<AppState> store, DisregardMessages action, NextDispatcher next);

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
    TypedMiddleware<AppState, RetrieveConversationItems>(
      _retrieveConversationItems(conversationsService),
    ),
    TypedMiddleware<AppState, SaveMessage>(
      _saveMessage(conversationsService),
    ),
    TypedMiddleware<AppState, ObserveMessages>(
      _observeMessages(conversationsService),
    ),
    TypedMiddleware<AppState, DisregardMessages>(
      _disregardMessages(conversationsService),
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

RetrieveConversationItemsMiddleware _retrieveConversationItems(
    ConversationsService conversationService) {
  return (Store<AppState> store, RetrieveConversationItems action,
      NextDispatcher next) async {
    next(action);

    ///
    store.dispatch(await conversationService
        .retrieveConversationItems(store.state.user.id));
  };
}

SaveMessageMiddleware _saveMessage(ConversationsService conversationService) {
  return (Store<AppState> store, SaveMessage action,
      NextDispatcher next) async {
    next(action);

    /// the function calls listen on the firestore and keeps the stream open
    /// until disregardMessages is called
    conversationService.saveMessage(store);
  };
}

ObserveMessagesMiddleware _observeMessages(
    ConversationsService conversationService) {
  return (Store<AppState> store, ObserveMessages action,
      NextDispatcher next) async {
    next(action);

    /// the function calls listen on the firestore and keeps the stream open
    /// until disregardMessages is called
    conversationService.observeMessages(store);
  };
}

DisregardMessagesMiddleware _disregardMessages(
    ConversationsService conversationService) {
  return (Store<AppState> store, DisregardMessages action,
      NextDispatcher next) async {
    next(action);

    /// the function calls listen on the firestore and keeps the stream open
    /// until disregardMessages is called
    conversationService.disregardMessages(store);
  };
}
