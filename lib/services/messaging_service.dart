import 'package:firebase_messaging/firebase_messaging.dart' as fbm;
import 'package:flutter/foundation.dart';

import '../notifications/enums/authorization_status.dart';

class MessagingService {
  late final fbm.FirebaseMessaging _messaging;
  fbm.NotificationSettings? _notificationSettings;

  MessagingService({fbm.FirebaseMessaging? messaging}) {
    (messaging == null)
        ? _messaging = fbm.FirebaseMessaging.instance
        : _messaging = messaging;

    _messaging.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
  }

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
          Future.delayed(Duration(milliseconds: 100));
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
  }

  AuthorizationStatus getAuthorizatinStatus() {
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

  Future<String?> getToken() {
    return _messaging.getToken();
  }
}
