import 'dart:convert';

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
import '../utils/cache/image_bytes_cache.dart';
import '../utils/globals.dart';

class ConversationsService {
  ConversationsService({
    required FirebaseAuth auth,
    required FirebaseStorage storage,
    required FirebaseFunctions cloudFunctions,
    required FirebaseFirestore firestore,
    required ImageBytesCache imageBytesCache,
    required PlayerCache playerCache,
  })  : _firestore = firestore,
        _auth = auth,
        _cloudFunctions = cloudFunctions,
        _imageBytesCache = imageBytesCache,
        _playerCache = playerCache {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${jsonEncode(message.notification?.toMap())}');
      }
    });
  }

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _cloudFunctions;
  final ImageBytesCache _imageBytesCache;
  final PlayerCache _playerCache;

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
    final collectionSnapshot =
        await _firestore.collection('conversations').get();

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
    QuerySnapshot<Map<String, Object?>> snapshot = await _firestore
        .collection('conversations')
        .doc(conversation.id)
        .collection('messages')
        .limit(1)
        .orderBy('timestamp', descending: true)
        .get();

    Message lastMessage = Message.fromJsonWithId(
        snapshot.docs.first.id, snapshot.docs.first.data());

    final String otherPlayerId =
        conversation.participantIds.first == _auth.currentUser!.uid
            ? conversation.participantIds.last
            : conversation.participantIds.first;
    final Player otherPlayer = await _playerCache.retrievePlayer(otherPlayerId);

    final picData = await _imageBytesCache
        .retrieveImage('profilePics/${otherPlayer.id}_small.jpg');

    String maybeYou = '';
    if (lastMessage.senderId == _auth.currentUser!.uid) {
      maybeYou = 'You: ';
    }

    return ConversationViewModel(
      conversation: conversation,
      lastMessagePicData: picData,
      lastMessageName: otherPlayer.name,
      identifyingLastMessageValue: maybeYou + lastMessage.value,
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
}
