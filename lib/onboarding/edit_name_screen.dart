import 'package:crowdleague/players/players_service.dart';
import 'package:crowdleague/services/user_service.dart';
import 'package:crowdleague/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/locator.dart';
import 'widgets/onboarding_progress_indicator.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({required this.onboarding, super.key});

  final String onboarding;

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final _textController = TextEditingController();
  bool _onboarding = false;

  Future<void> _getCurrentName() async {
    final player = await locate<PlayersService>()
        .retrievePlayer(locate<UserService>().currentUserId!);
    _textController.text = player?.name ?? '';
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );
  }

  @override
  void initState() {
    super.initState();
    _onboarding = widget.onboarding.parseBool();
    _getCurrentName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              locate<UserService>().updateProfileName(_textController.text);
              (_onboarding)
                  ? context.pushNamed(
                      'edit-profile-pic',
                      pathParameters: {
                        'onboarding': 'true',
                      },
                    )
                  : context.pop();
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Column(
        children: [
          if (_onboarding) ...[
            const SizedBox(height: 16),
            const OnboardingProgressIndicator(currentStep: 0),
          ],
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "What's your name?",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
