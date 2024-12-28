import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/user_service.dart';
import '../utils/locator.dart';

class OnboardNameScreen extends StatefulWidget {
  const OnboardNameScreen({super.key});

  @override
  State<OnboardNameScreen> createState() => _OnboardNameScreenState();
}

class _OnboardNameScreenState extends State<OnboardNameScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              locate<UserService>().updateProfileName(_textController.text);
              context.push('/onboard-profile-pic');
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _textController),
            const Text('Name'),
          ],
        ),
      ),
    );
  }
}
