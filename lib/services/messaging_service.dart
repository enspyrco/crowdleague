import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fbm;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifications/enums/authorization_status.dart';

class MessagingService {
  MessagingService({
    required fbm.FirebaseMessaging messaging,
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _auth = firebaseAuth,
        _messaging = messaging {
    _messaging.onTokenRefresh.listen((_) {
      checkAndUpdateFcmTokenIfFresh();
    }).onError((err) {
      throw 'Error getting token: $err';
    });

    fbm.FirebaseMessaging.onMessage.listen((fbm.RemoteMessage message) {
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
  final fbm.FirebaseMessaging _messaging;
  fbm.NotificationSettings? _notificationSettings;

  /// Asks for permission, stores a new token if the token is fresh
  Future<void> init() async {
    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.
    _notificationSettings =
        await fbm.FirebaseMessaging.instance.requestPermission();

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
      String? apnsToken = await fbm.FirebaseMessaging.instance.getAPNSToken();

      int counter;
      final int maxTries = 20;
      for (counter = 0; counter < maxTries; counter++) {
        if (apnsToken == null) {
          await Future.delayed(Duration(milliseconds: 100));
          apnsToken = await fbm.FirebaseMessaging.instance.getAPNSToken();
        } else {
          break;
        }
      }
      if (counter == maxTries) {
        throw 'The APNS token did not become available after waiting for 2 seconds';
      }
    }
    // APNS token is available, we can make FCM plugin API requests...
    checkAndUpdateFcmTokenIfFresh();
  }

  AuthorizationStatus getAuthorizationStatus() {
    switch (_notificationSettings?.authorizationStatus) {
      case fbm.AuthorizationStatus.authorized:
        return AuthorizationStatus.authorized;
      case fbm.AuthorizationStatus.denied:
        return AuthorizationStatus.denied;
      case fbm.AuthorizationStatus.notDetermined:
        return AuthorizationStatus.notDetermined;
      case fbm.AuthorizationStatus.provisional:
        return AuthorizationStatus.provisional;
      default:
        return AuthorizationStatus.notDetermined;
    }
  }

  Future<void> checkAndUpdateFcmTokenIfFresh() async {
    // Get a token from the SDK
    String? token = await _messaging.getToken();

    if (_auth.currentUser == null || token == null) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? oldToken = prefs.getString('oldFcmToken');
    if (oldToken != token && _auth.currentUser != null) {
      // If token is fresh, update the relevant doc and set shared preferences.
      // A cloud function reacts to the doc update and updates the token everywhere.

      await _firestore
          .collection('fcmTokens')
          .doc(_auth.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));

      await prefs.setString('oldFcmToken', token);
    }
  }
}
