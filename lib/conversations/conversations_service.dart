import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crowdleague/conversations/models/conversation.dart';
import 'package:crowdleague/conversations/models/view/conversation_view_model.dart';
import 'package:crowdleague/utils/cache/player_cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'models/message.dart';
import '../players/models/player.dart';
import '../utils/globals.dart';

class ConversationsService {
  ConversationsService({
    required FirebaseAuth auth,
    required FirebaseStorage storage,
    required FirebaseFunctions cloudFunctions,
    required FirebaseFirestore firestore,
    required PlayerCache playerCache,
  })  : _firestore = firestore,
        _auth = auth,
        _cloudFunctions = cloudFunctions,
        _playerCache = playerCache {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${jsonEncode(message.notification?.toMap())}');
      }
    });
  }

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _cloudFunctions;
  final PlayerCache _playerCache;

  final _numUnreadMessagesStreamController = StreamController<int>.broadcast();
  Stream<int> get numUnreadMessagesStream =>
      _numUnreadMessagesStreamController.stream;

  /// Counts unread messages across all conversations and emits the count.
  /// A message is unread if the current user is not in the readBy list
  /// and is not the sender.
  Future<void> readAndEmitUnreadMessages() async {
    if (_auth.currentUser == null) return;

    final userId = _auth.currentUser!.uid;

    // Get all conversations the user is part of
    final conversationsSnapshot = await _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .get();

    int unreadCount = 0;

    // For each conversation, count unread messages
    for (final conversationDoc in conversationsSnapshot.docs) {
      final messagesSnapshot = await _firestore
          .collection('conversations')
          .doc(conversationDoc.id)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .get();

      for (final messageDoc in messagesSnapshot.docs) {
        final readBy = List<String>.from(messageDoc.data()['readBy'] ?? []);
        if (!readBy.contains(userId)) {
          unreadCount++;
        }
      }
    }

    _numUnreadMessagesStreamController.add(unreadCount);
  }

  Future<String> findOrCreateConversation(String playerId) async {
    final String userId = _auth.currentUser!.uid;
    final sortedIds = [userId, playerId]..sort();
    final String conversationId = '${sortedIds.first}_${sortedIds.last}';

    final snapshot =
        await _firestore.collection('conversations').doc(conversationId).get();

    if (!snapshot.exists) {
      await _firestore.collection('conversations').doc(conversationId).set({
        'participantIds': sortedIds,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
    return conversationId;
  }

  Future<List<ConversationViewModel>> retrieveConversationViewModels() async {
    final collectionSnapshot = await _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: _auth.currentUser!.uid)
        .get();

    List<ConversationViewModel> convertedList =
        await Future.wait(collectionSnapshot.docs.map((docSnapshot) async {
      final conversation =
          Conversation.fromJsonWithId(docSnapshot.id, docSnapshot.data());
      return await _convertToViewModel(conversation);
    }));

    return convertedList;
  }

  Future<ConversationViewModel> _convertToViewModel(
      Conversation conversation) async {
    QuerySnapshot<Map<String, Object?>> lastMessagesSnapshot = await _firestore
        .collection('conversations')
        .doc(conversation.id)
        .collection('messages')
        .limit(1)
        .orderBy('timestamp', descending: true)
        .get();

    Message lastMessage = Message.fromJsonWithId(
        lastMessagesSnapshot.docs.first.id,
        lastMessagesSnapshot.docs.first.data());

    final String lastMessagePlayerId =
        conversation.participantIds.first == _auth.currentUser!.uid
            ? conversation.participantIds.last
            : conversation.participantIds.first;
    final Player lastMessagePlayer =
        await _playerCache.retrievePlayer(lastMessagePlayerId);

    String maybeYou = '';
    if (lastMessage.senderId == _auth.currentUser!.uid) {
      maybeYou = 'You: ';
    }

    return ConversationViewModel(
      conversation: conversation,
      lastMessagePlayerId: lastMessagePlayerId,
      lastMessagePlayerName: lastMessagePlayer.name,
      lastMessageText: maybeYou + lastMessage.value,
    );
  }

  Future<void> sendMessage(String conversationId, String value) async {
    await _cloudFunctions.httpsCallable('sendMessageToParticipants').call({
      'senderId': _auth.currentUser!.uid,
      'conversationId': conversationId,
      'message': value,
      'dbName': kDatabaseName,
    });
  }

  Stream<List<Message>> messagesStreamFor(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map<List<Message>>((querySnapshot) {
      return querySnapshot.docs.map<Message>((docSnapshot) {
        final json = docSnapshot.data();
        json['id'] = docSnapshot.id;
        return Message.fromJson(json);
      }).toList();
    });
  }

  /// Marks all messages in a conversation as read by the current user.
  /// Only marks messages that were sent by others (not the current user).
  /// After marking, refreshes the unread count.
  Future<void> markMessagesAsRead(String conversationId) async {
    if (_auth.currentUser == null) return;

    final userId = _auth.currentUser!.uid;

    // Get all messages not sent by the current user
    final messagesSnapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .get();

    // Use batch write for efficiency
    final batch = _firestore.batch();

    for (final messageDoc in messagesSnapshot.docs) {
      final readBy = List<String>.from(messageDoc.data()['readBy'] ?? []);
      if (!readBy.contains(userId)) {
        batch.update(messageDoc.reference, {
          'readBy': FieldValue.arrayUnion([userId]),
        });
      }
    }

    await batch.commit();

    // Refresh the unread count
    await readAndEmitUnreadMessages();
  }
}
