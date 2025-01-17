import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../conversations/models/message.dart';
import '../utils/globals.dart';

class ConversationsService {
  ConversationsService({
    required FirebaseFunctions cloudFunctions,
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _auth = firebaseAuth,
        _cloudFunctions = cloudFunctions {
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
