import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/actions/conversations/store_selected_conversation.dart';
import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/conversations/conversation_summary.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/models/problems/create_conversation_problem.dart';
import 'package:crowdleague/models/problems/delete_profile_pic_problem.dart';
import 'package:crowdleague/models/problems/disregard_conversations_problem.dart';
import 'package:crowdleague/models/problems/disregard_messages_problem.dart';
import 'package:crowdleague/models/problems/disregard_profile_pics_problem.dart';
import 'package:crowdleague/models/problems/disregard_profile_problem.dart';
import 'package:crowdleague/models/problems/observe_messages_problem.dart';
import 'package:crowdleague/models/problems/observe_processing_failures_problem.dart';
import 'package:crowdleague/models/problems/observe_profile_pics_problem.dart';
import 'package:crowdleague/models/problems/observe_profile_problem.dart';
import 'package:crowdleague/models/problems/retrieve_leaguers_problem.dart';
import 'package:crowdleague/models/problems/save_message_problem.dart';
import 'package:crowdleague/models/problems/update_leaguer_problem.dart';
import 'package:crowdleague/utils/redux/firestore_subscriptions.dart';
import 'package:redux/redux.dart';

class DatabaseService {
  /// The [FirebaseFirestore] instance, the current implementation of the database
  final FirebaseFirestore _firestore;

  /// The [FirestoreSubscriptions] object holds the subscriptions to the
  /// firestore streams, used to cancel streams when we want to stop listening
  /// to events in the firestore
  final FirestoreSubscriptions _firestoreSubscriptions =
      FirestoreSubscriptions();

  /// The [_storeController] is connected to the redux [Store] and is used
  /// by the [DatabaseService] to add actions to the stream where they will
  /// be dispatched by the store
  final StreamController<ReduxAction> _storeController =
      StreamController<ReduxAction>();

  /// The stream of the [_storeController] is used just once on app load, to
  /// connect the [_storeController] to the redux [Store]
  Stream<ReduxAction> get storeStream => _storeController.stream;

  DatabaseService(FirebaseFirestore firestore) : _firestore = firestore;

  //////////////////////////////////////////////////////////////////////////////
  /// PROCESSING FAILURES
  //////////////////////////////////////////////////////////////////////////////

  /// Connect to the [FirebaseFirestore], and add any new [ProcessingFailure]s to the
  /// app state via [StoreProcessingFailures] actions
  ///
  /// Also display any new [ProcessingFailure]s via [AddProblem] actions
  void observeProcessingFailures(String userId) async {
    try {
      _firestoreSubscriptions.processingFailures =
          _firestore.connectToProcessingFailures(userId, _storeController);
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: ObserveProcessingFailuresProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// CONVERSATIONS
  //////////////////////////////////////////////////////////////////////////////

  /// Returns a [Future] of either [StoreSelectedConversation] or [AddProblem]
  Future<ReduxAction> createConversation(
      String userId, BuiltList<Leaguer> leaguers) async {
    try {
      final displayNames = <String>[];
      final photoURLs = <String>[];
      final uids = <String>[];
      for (final leaguer in leaguers) {
        displayNames.add(leaguer.displayName);
        photoURLs.add(leaguer.photoURL);
        uids.add(leaguer.uid);
      }

      final docRef =
          await _firestore.collection('/conversations/').add(<String, dynamic>{
        'createdBy': userId,
        'createdOn': FieldValue.serverTimestamp(),
        'displayNames': displayNames,
        'photoURLs': photoURLs,
        'uids': uids
      });

      return StoreSelectedConversation(
          summary: ConversationSummary(
              conversationId: docRef.id,
              displayNames: BuiltList(displayNames),
              photoURLs: BuiltList(photoURLs),
              uids: BuiltList(uids)));
    } catch (error, trace) {
      return AddProblem(
        problem: CreateConversationProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString(),
        ),
      );
    }
  }

  /// We listen for changes in the conversations collection and try to convert
  /// each updated collection to a [StoreConversationSummaries] action.
  ///
  /// The action is added to the [_storeController] or if there was a problem,
  /// an [AddProblem] action is added.
  void observeConversations(String userId) {
    try {
      _firestoreSubscriptions.conversations =
          _firestore.connectToConversations(userId, _storeController);
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: CreateConversationProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  void disregardConversations() {
    try {
      _firestoreSubscriptions.conversations?.cancel();
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: DisregardConversationsProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  void saveMessage(Store<AppState> store) async {
    try {
      // the message saved to firestore will be put in the app state via the
      // observeMessages function
      await _firestore
          .collection(
              '/conversations/${store.state.messagesPage.summary.conversationId}/messages/')
          .add(<String, dynamic>{
        'authorId': store.state.user.id,
        'text': store.state.messagesPage.messageText,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (error, trace) {
      store.dispatch(
        AddProblem(
          problem: SaveMessageProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  /// We listen for changes in the messages collection and add the updated
  /// entries to the stream connected to the store.
  void observeMessages(String conversationId) {
    try {
      _firestoreSubscriptions.messages =
          _firestore.connectToMessages(conversationId, _storeController);
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: ObserveMessagesProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  /// cancels the subscription or dispatches an AddProblem action
  void disregardMessages(Store<AppState> store) async {
    try {
      await _firestoreSubscriptions.messages?.cancel();
    } catch (error, trace) {
      store.dispatch(
        AddProblem(
          problem: DisregardMessagesProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  Future<void> leaveConversation(String userId, String conversationId) {
    return _firestore
        .doc('/conversations/$conversationId/leave/$userId')
        .set(<String, dynamic>{'timestamp': FieldValue.serverTimestamp()});
  }

  Future<ReduxAction> get retrieveNewConversationSuggestions async {
    try {
      final collection = await _firestore.collection('leaguers');
      final snapshot = await collection.get();
      final leaguers = snapshot.docs
          .map<Leaguer>((user) => Leaguer(
              uid: user.id,
              displayName: user.data()['displayName'] as String ?? user.id,
              photoURL: user.data()['photoURL'] as String ??
                  'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y'))
          .toBuiltList();

      return UpdateNewConversationPage(suggestions: leaguers);
    } catch (error, trace) {
      return AddProblem(
        problem: RetrieveLeaguersProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString(),
        ),
      );
    }
  }

  Future<ReduxAction> updateLeaguer(String userId, String picId) async {
    try {
      final docRef = await _firestore.doc('/leaguers/$userId');
      final picURL =
          'https://storage.googleapis.com/crowdleague-profile-pics/$userId/${picId}_200x200';
      await docRef.update(<String, dynamic>{'photoURL': picURL});
      return null;
    } catch (error, trace) {
      return AddProblem(
        problem: UpdateLeaguerProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString(),
        ),
      );
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// PROFILE
  //////////////////////////////////////////////////////////////////////////////

  void observeProfilePics(String userId) {
    try {
      // - create a stream from the firestore
      // - listen to the stream and add events to the stream_controller
      // - store the subscription so the stream from the firestore can be
      // cancelled
      _firestoreSubscriptions.profilePics =
          _firestore.connectToProfilePics(userId, _storeController);
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: ObserveProfilePicsProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  /// cancels the subscription or dispatches an AddProblem action
  void disregardProfilePics() async {
    try {
      await _firestoreSubscriptions.profilePics?.cancel();
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: DisregardProfilePicsProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  ///
  void observeProfile(String userId) {
    try {
      _firestoreSubscriptions.profile =
          _firestore.connectToProfile(userId, _storeController);
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: ObserveProfileProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  /// cancels the subscription or dispatches an AddProblem action
  void disregardProfile() async {
    try {
      await _firestoreSubscriptions.profile?.cancel();
    } catch (error, trace) {
      _storeController.add(
        AddProblem(
          problem: DisregardProfileProblem.by(
            (b) => b
              ..message = error.toString()
              ..trace = trace.toString(),
          ),
        ),
      );
    }
  }

  /// ... or dispatches an AddProblem action
  Future<ReduxAction> deleteProfilePic(String userId, String picId) async {
    try {
      await _firestore.doc('leaguers/$userId/profile_pics/$picId').delete();
      return null;
    } catch (error, trace) {
      return AddProblem(
        problem: DeleteProfilePicProblem.by(
          (b) => b
            ..message = error.toString()
            ..trace = trace.toString(),
        ),
      );
    }
  }
}
