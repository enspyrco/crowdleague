import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/messaging_service.dart';
import '../utils/locator.dart';

class OnboardNotifications extends StatefulWidget {
  const OnboardNotifications({super.key});

  @override
  State<OnboardNotifications> createState() => _OnboardNotificationsState();
}

class _OnboardNotificationsState extends State<OnboardNotifications> {
  Future<void> _getAToken(BuildContext context) async {
    // Asks for permission, stores a new token if the token is fresh
    await locate<MessagingService>().init();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (context.mounted) {
      context.go('/');
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
                'When players you follow want to have a run\nwe will to send you a notification'),
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
