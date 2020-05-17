import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/conversations/store_conversation_summaries.dart';
import 'package:crowdleague/actions/conversations/store_messages.dart';
import 'package:crowdleague/extensions/add_problem_extensions.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/enums/problem_type.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:redux/redux.dart';

class ConversationsService {
  final Firestore firestore;

  ConversationsService({this.firestore});

  StreamSubscription<QuerySnapshot> messagesSubscription;

  /// Returns a [Future] of either [StoreSelectedConversation] or [AddProblem]
  Future<ReduxAction> createConversation(
      String userId, BuiltList<Leaguer> leaguers) async {
    try {
      final displayNames = <String>[];
      final photoURLs = <String>[];
      final uids = <String>[];
      for (final leaguer in leaguers) {
        displayNames.add(leaguer.displayName);
        photoURLs.add(leaguer.photoUrl);
        uids.add(leaguer.uid);
      }

      final docRef =
          await firestore.collection('conversations').add(<String, dynamic>{
        'createdBy': userId,
        'createdOn': FieldValue.serverTimestamp(),
        'displayNames': displayNames,
        'photoURLs': photoURLs,
        'uids': uids
      });

      return StoreSelectedConversation((b) => b
        ..summary.conversationId = docRef.documentID
        ..summary.displayNames = ListBuilder(displayNames)
        ..summary.photoURLs = ListBuilder(photoURLs)
        ..summary.uids = ListBuilder(uids));
    } catch (error, trace) {
      return AddProblemObject.from(
          error, trace, ProblemType.createConversation);
    }
  }

  /// Returns a [Future] of either [StoreSelectedConversation] or [AddProblem]
  Future<ReduxAction> retrieveConversationSummaries(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('conversations')
          .where('uids', arrayContains: userId)
          .getDocuments();

      final summaries = querySnapshot.documents.map<
          ConversationSummary>((snapshot) => ConversationSummary((b) => b
        ..conversationId = snapshot.documentID
        ..displayNames.replace(
            List<String>.from(snapshot.data['displayNames'] as List<dynamic>))
        ..photoURLs.replace(
            List<String>.from(snapshot.data['photoURLs'] as List<dynamic>))
        ..uids.replace(
            List<String>.from(snapshot.data['uids'] as List<dynamic>))));

      return StoreConversationSummaries((b) => b..summaries.replace(summaries));
    } catch (error, trace) {
      return AddProblemObject.from(
          error, trace, ProblemType.createConversation);
    }
  }

  void saveMessage(Store<AppState> store) async {
    try {
      // the message saved to firestore will be put in the app state via the
      // observeMessages function
      await firestore
          .collection(
              'conversations/${store.state.conversationPage.summary.conversationId}/messages')
          .add(<String, dynamic>{
        'authorId': store.state.user.id,
        'text': store.state.conversationPage.messageText,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (error, trace) {
      store.dispatch(
          AddProblemObject.from(error, trace, ProblemType.saveMessage));
    }
  }

  ///
  void observeMessages(Store<AppState> store) {
    try {
      messagesSubscription = firestore
          .collection(
              'conversations/${store.state.conversationPage.summary.conversationId}/messages')
          .snapshots()
          .listen((querySnapshot) {
        store.dispatch(StoreMessages(
          (b) => b
            ..messages =
                ListBuilder<Message>(querySnapshot.documents.map<Message>(
              (docSnapshot) =>
                  Message((b) => b..text = docSnapshot.data['text'] as String),
            )),
        ));
      })
            ..onError((dynamic error, StackTrace trace) {
              store.dispatch(AddProblemObject.from(
                  error, trace, ProblemType.observeMessages));
            });
    } catch (error, trace) {
      store.dispatch(
          AddProblemObject.from(error, trace, ProblemType.observeMessages));
    }

    // below was me trying a few different ideas on how to setup the service
    // function, I ended passing in the store which makes things a lot easier
    // but leaving these here till I see the chosen method is working

    // return firestore
    //     .collection('conversations/$conversationId')
    //     .snapshots()
    //     .map<ReduxAction>((querySnapshot) => StoreMessages((b) => b
    //       ..messages = ListBuilder<Message>(querySnapshot.documents
    //           .map<Message>((docSnapshot) => Message(
    //               (b) => b..text = docSnapshot.data['text'] as String)))));

    // await for (QuerySnapshot querySnapshot
    //     in firestore.collection('conversations/$conversationId').snapshots()) {
    //   try {
    //     yield StoreMessages((b) => b
    //       ..messages = ListBuilder<Message>(querySnapshot.documents
    //           .map<Message>((docSnapshot) => Message(
    //               (b) => b..text = docSnapshot.data['text'] as String))));
    //   } catch (error, trace) {
    //     yield AddProblemObject.from(error, trace, ProblemType.observeMessages);
    //   }
    // }
  }

  /// cancels the subscription or dispatches an AddProblem action
  void disregardMessages(Store<AppState> store) async {
    try {
      await messagesSubscription?.cancel();
    } catch (error, trace) {
      store.dispatch(
          AddProblemObject.from(error, trace, ProblemType.disregardMessages));
    }
  }
}
