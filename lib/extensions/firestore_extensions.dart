import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/conversations/store_conversations.dart';
import 'package:crowdleague/actions/conversations/store_messages.dart';
import 'package:crowdleague/actions/functions/store_processing_failures.dart';
import 'package:crowdleague/actions/profile/store_profile_pics.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/extensions/stream_controller_extensions.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/functions/processing_failure.dart';
import 'package:crowdleague/models/problems/connect_to_messages_problem.dart';
import 'package:crowdleague/models/problems/observe_profile_pics_problem.dart';
import 'package:crowdleague/models/problems/observe_profile_problem.dart';
import 'package:crowdleague/models/problems/processing_failure_problem.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';

import 'extensions.dart';

extension ConnectAndConvert on FirebaseFirestore {
  StreamSubscription<QuerySnapshot> connectToProcessingFailures(
      String userId, StreamController<ReduxAction> controller) {
    return collection('users/$userId/processing_failures')
        .snapshots()
        .listen((querySnapshot) {
      for (final change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final failure = change.doc.toProcessingFailure();
          controller.addProblem(
            ProcessingFailureProblem,
            failure,
            StackTrace.current,
            <String, Object>{'id': failure.id},
          );
        }
      }

      // convert the query snapshot to a list of ProcessingFailure
      final failures = querySnapshot.docs
          .map<ProcessingFailure>(
              (docSnapshot) => docSnapshot.toProcessingFailure())
          .toBuiltList();

      final action = StoreProcessingFailures(failures: failures);
      controller.add(action);
    });
  }

  StreamSubscription<QuerySnapshot> connectToConversations(
      String userId, StreamController<ReduxAction> controller) {
    return collection('/conversations/')
        .where('uids', arrayContains: userId)
        .snapshots()
        .listen((querySnapshot) {
      final summaries = querySnapshot.docs
          .map<ConversationSummary>(
              (docSnapshot) => docSnapshot.toConversationSummary())
          .toBuiltList();

      final action = StoreConversations(summaries: summaries);
      controller.add(action);
    });
  }

  StreamSubscription<QuerySnapshot> connectToMessages(
      String conversationId, StreamController<ReduxAction> controller) {
    return collection('/conversations/$conversationId/messages/')
        .snapshots()
        .listen((querySnapshot) {
      controller.add(StoreMessages(
        messages: BuiltList<Message>(querySnapshot.docs.map<Message>(
            (docSnapshot) =>
                Message(text: docSnapshot.data()['text'] as String))),
      ));
    }, onError: (dynamic error, StackTrace trace) {
      controller.addProblem(ConnectToMessagesProblem, error, trace);
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
        .doc('$userId')
        .collection('profile_pics/')
        .snapshots()
        .listen((querySnapshot) {
      try {
        final picIds = <ProfilePic>[];
        for (final docSnapshot in querySnapshot.docs) {
          picIds.add(ProfilePic(
              id: docSnapshot.id,
              deleting: docSnapshot.data()['deleting'] as bool ?? false,
              url:
                  'https://storage.googleapis.com/crowdleague-profile-pics/$userId/${docSnapshot.id}_200x200'));
        }
        controller.add(StoreProfilePics(profilePics: picIds.toBuiltList()));
      } catch (error, trace) {
        controller.addProblem(ObserveProfilePicsProblem, error, trace);
      }
    }, onError: (dynamic error, StackTrace trace) {
      controller.addProblem(ObserveProfilePicsProblem, error, trace);
    });
  }

  /// Connects a stream from the firestore (specifically from the 'leaguers/$userId' doc)
  /// to a [StreamController<ReduxAction>] by listening to the firestore stream
  /// and adding all events to the controller
  StreamSubscription<DocumentSnapshot> connectToProfile(
      String userId, StreamController<ReduxAction> controller) {
    return doc('leaguers/$userId').snapshots().listen((docSnapshot) {
      try {
        final leaguer = docSnapshot.toLeaguer();
        controller.add(UpdateProfilePage(
            userId: leaguer.uid, leaguerPhotoURL: leaguer.photoURL));
      } catch (error, trace) {
        controller.addProblem(ObserveProfileProblem, error, trace);
      }
    });
  }
}
