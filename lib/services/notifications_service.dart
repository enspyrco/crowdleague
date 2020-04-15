import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  final FirebaseMessaging _messaging;

  NotificationsService(this._messaging) {
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        // _showItemDialog(message);
      },
      onBackgroundMessage: backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        // _navigateToItemDetail(message);
      },
    );
  }

  FutureOr<bool> requestPermissions() {
    return _messaging.requestNotificationPermissions();
  }

  void printToken() {
    _messaging.getToken().then(print);
  }
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];

    print(notification);
  }

  return null;
}
