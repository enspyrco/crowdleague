import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/conversations/store_conversations.dart';
import 'package:crowdleague/actions/conversations/store_messages.dart';
import 'package:crowdleague/actions/functions/store_processing_failures.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/functions/processing_failure.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';

import 'extensions.dart';

extension ConnectAndConvert on Firestore {
  StreamSubscription<QuerySnapshot> connectToProcessingFailures(
      String userId, StreamController<ReduxAction> controller) {
    return collection('users/$userId/processing_failures')
        .snapshots()
        .listen((querySnapshot) {
      for (final change in querySnapshot.documentChanges) {
        if (change.type == DocumentChangeType.added) {
          final failure = change.document.toProcessingFailure();
          final action = AddProblem.from(
              message: failure.message,
              type: ProblemType.processingFailure,
              info: {'id': failure.id});

          controller.add(action);
        }
      }

      // convert the query snapshot to a list of ProcessingFailure
      final failures = querySnapshot.documents.map<ProcessingFailure>(
          (docSnapshot) => docSnapshot.toProcessingFailure());

      final action =
          StoreProcessingFailures((b) => b..failures.replace(failures));
      controller.add(action);
    });
  }

  StreamSubscription<QuerySnapshot> connectToConversations(
      String userId, StreamController<ReduxAction> controller) {
    return collection('/conversations/')
        .where('uids', arrayContains: userId)
        .snapshots()
        .listen((querySnapshot) {
      final summaries = querySnapshot.documents.map<ConversationSummary>(
          (docSnapshot) => docSnapshot.toConversationSummary());

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
      controller.add(AddProblem.from(
        message: error.toString(),
        traceString: trace.toString(),
        type: ProblemType.observeMessages,
      ));
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
        final picIds = <ProfilePic>[];
        for (final docSnapshot in querySnapshot.documents) {
          picIds.add(ProfilePic((b) => b
            ..id = docSnapshot.documentID
            ..deleting = docSnapshot.data['deleting'] as bool ?? false
            ..url =
                'https://storage.googleapis.com/crowdleague-profile-pics/$userId/${docSnapshot.documentID}_200x200'));
        }
        controller.add(StoreProfilePics((b) => b..profilePics.replace(picIds)));
      } catch (error, trace) {
        controller.add(AddProblem.from(
          message: error.toString(),
          type: ProblemType.observeProfilePics,
          traceString: trace.toString(),
        ));
      }
    }, onError: (dynamic error, StackTrace trace) {
      controller.add(AddProblem.from(
        message: error.toString(),
        type: ProblemType.observeProfilePics,
        traceString: trace.toString(),
      ));
    });
  }

  /// Connects a stream from the firestore (specifically from the 'leaguers/$userId' doc)
  /// to a [StreamController<ReduxAction>] by listening to the firestore stream
  /// and adding all events to the controller
  StreamSubscription<DocumentSnapshot> connectToProfile(
      String userId, StreamController<ReduxAction> controller) {
    return document('leaguers/$userId').snapshots().listen((docSnapshot) {
      try {
        final leaguer = docSnapshot.toLeaguer();
        controller.add(UpdateProfilePage((b) => b
          ..userId = leaguer.uid
          ..leaguerPhotoURL = leaguer.photoUrl));
      } catch (error, trace) {
        controller.add(AddProblem.from(
          message: error.toString(),
          type: ProblemType.observeProfile,
          traceString: trace.toString(),
        ));
      }
    });
  }
}
