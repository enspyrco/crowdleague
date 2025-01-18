import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crowdleague/conversations/models/conversation.dart';
import 'package:crowdleague/conversations/models/view/conversation_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../conversations/models/message.dart';
import '../players/models/player.dart';
import '../utils/globals.dart';

class ConversationsService {
  ConversationsService({
    required FirebaseAuth auth,
    required FirebaseStorage storage,
    required FirebaseFunctions cloudFunctions,
    required FirebaseFirestore firestore,
    required Map<String, Uint8List> imageCache,
    required Map<String, Player> playerCache,
  })  : _firestore = firestore,
        _auth = auth,
        _storage = storage,
        _cloudFunctions = cloudFunctions,
        _imageCache = imageCache,
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

  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _cloudFunctions;
  final Map<String, Uint8List> _imageCache;
  final Map<String, Player> _playerCache;

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
      return await convertToConverationViewModel(conversation);
    }));

    return convertedList;
  }

  Future<ConversationViewModel> convertToConverationViewModel(
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
    if (!_playerCache.containsKey(otherPlayerId)) {
      final reference =
          await _firestore.collection('profiles').doc(otherPlayerId).get();
      _playerCache[otherPlayerId] =
          Player.fromJsonWithId(reference.id, reference.data() ?? {});
    }
    final Player otherPlayer = _playerCache[otherPlayerId]!;

    final picUriString = 'profilePics/${otherPlayer.id}_small';
    if (!_imageCache.containsKey(otherPlayer.id)) {
      _imageCache[picUriString] =
          await _storage.ref(picUriString).getData() ?? Uint8List(0);
    }
    final iconData = _imageCache[picUriString];

    String maybeYou = '';
    if (lastMessage.senderId == _auth.currentUser!.uid) {
      maybeYou = 'You: ';
    }

    return ConversationViewModel(
      conversation: conversation,
      lastMessagePicData: iconData ?? Uint8List(0),
      lastMessageName: otherPlayer.name,
      identifyingLastMessageValue: maybeYou + lastMessage.value,
    );
  }

  Future<void> sendMessage(String conversationId, String value) async {
    await _cloudFunctions.httpsCallable('sendMessageToParticipants').call({
      'senderId': _auth.currentUser!.uid,
      'conversationId': conversationId,
      'message': value,
      'dbName': dbName,
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
