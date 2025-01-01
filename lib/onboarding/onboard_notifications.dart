import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/messaging_service.dart';
import '../utils/locator.dart';

class OnboardNotifications extends StatefulWidget {
  const OnboardNotifications({super.key});

  @override
  State<OnboardNotifications> createState() => _OnboardNotificationsState();
}

class _OnboardNotificationsState extends State<OnboardNotifications> {
  Future<void> _getAToken(BuildContext context) async {
    await locate<MessagingService>().init();
    String? token = await locate<MessagingService>().getToken();
    if (token == null) {
      log('FCM Token was null');
    } else {
      await locate<MessagingService>().storeToken(token);
      if (context.mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'When your the players you follow want to have a run\nwe will to send you a notification'),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                _getAToken(context);
              },
              child: Text('OK'),
            )
          ],
        ),
      ),
    );
  }
}
