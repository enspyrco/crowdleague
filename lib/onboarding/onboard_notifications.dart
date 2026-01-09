import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/messaging_service.dart';
import '../utils/locator.dart';
import 'widgets/onboarding_progress_indicator.dart';

class OnboardNotifications extends StatefulWidget {
  const OnboardNotifications({super.key});

  @override
  State<OnboardNotifications> createState() => _OnboardNotificationsState();
}

class _OnboardNotificationsState extends State<OnboardNotifications> {
  Future<void> _enableNotifications() async {
    // Asks for permission, stores a new token if the token is fresh
    await locate<MessagingService>().init();
    await _completeOnboarding();
  }

  Future<void> _skipNotifications() async {
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const OnboardingProgressIndicator(currentStep: 2),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stay in the loop',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'When players you follow want to have a run, we will send you a notification.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                  FilledButton(
                    onPressed: _enableNotifications,
                    child: const Text('Yes, notify me'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _skipNotifications,
                    child: const Text('No thanks'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
