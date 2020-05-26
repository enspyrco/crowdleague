import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/conversations/store_conversations.dart';
import 'package:crowdleague/actions/conversations/store_messages.dart';
import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/extensions/add_problem_extensions.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';

import 'extensions.dart';

extension ConnectAndConvert on Firestore {
  StreamSubscription<QuerySnapshot> connectToConversations(
      String userId, StreamController<ReduxAction> controller) {
    return collection('/conversations/')
        .where('uids', arrayContains: userId)
        .snapshots()
        .listen((querySnapshot) {
      final summaries = querySnapshot.documents.map<
          ConversationSummary>((docSnapshot) => ConversationSummary((b) => b
        ..conversationId = docSnapshot.documentID
        ..displayNames.replace(List<String>.from(
            docSnapshot.data['displayNames'] as List<dynamic>))
        ..photoURLs.replace(
            List<String>.from(docSnapshot.data['photoURLs'] as List<dynamic>))
        ..uids.replace(
            List<String>.from(docSnapshot.data['uids'] as List<dynamic>))));

      final action = StoreConversations((b) => b..summaries.replace(summaries));
      controller.add(action);
    });
  }

  StreamSubscription<QuerySnapshot> connectToMessages(
      String conversationId, StreamController<ReduxAction> controller) {
    return collection('/conversations/$conversationId/messages/')
        .snapshots()
        .listen((querySnapshot) {
      controller.add(StoreMessages(
        (b) => b
          ..messages = ListBuilder<Message>(querySnapshot.documents
              .map<Message>((docSnapshot) => Message(
                  (b) => b..text = docSnapshot.data['text'] as String))),
      ));
    }, onError: (dynamic error, StackTrace trace) {
      controller.add(
          AddProblemObject.from(error, trace, ProblemType.observeMessages));
    });
  }

  /// Takes a subscription and a controller and listens to the firestore
  /// - the subscription is later used to cancel listening to the firestore
  /// - the controller is later used to get a stream that is listened to in middleware
  ///
  /// We use a stream controller so we can add extra things to the stream
  /// (such as AddProblem actions) outside of where the firestore stream is
  /// listened to (such as in a catch block)
  StreamSubscription<QuerySnapshot> connectToProfilePics(
      String userId, StreamController<ReduxAction> controller) {
    return collection('/leaguers')
        .document('$userId')
        .collection('profile_pics/')
        .snapshots()
        .listen((querySnapshot) {
      try {
        final picIds = <String>[];
        for (final docSnapshot in querySnapshot.documents) {
          picIds.add(docSnapshot.documentID);
        }
        controller
            .add(StoreProfilePics((b) => b..profilePicIds.replace(picIds)));
      } catch (error, trace) {
        controller.add(AddProblemObject.from(
            error, trace, ProblemType.observeProfilePics));
      }
    }, onError: (dynamic error, StackTrace trace) {
      controller.add(
          AddProblemObject.from(error, trace, ProblemType.observeProfilePics));
    });
  }

  StreamSubscription<DocumentSnapshot> connectToProfile(
      String userId, StreamController<ReduxAction> controller) {
    return document('leaguers/$userId').snapshots().listen((docSnapshot) {
      try {
        controller.add(UpdateProfilePage(
            (b) => b..leaguer = docSnapshot.toLeaguer().toBuilder()));
      } catch (error, trace) {
        controller.add(
            AddProblemObject.from(error, trace, ProblemType.observeProfile));
      }
    });
  }
}
