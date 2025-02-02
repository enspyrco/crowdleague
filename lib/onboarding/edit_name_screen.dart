import 'package:crowdleague/players/players_service.dart';
import 'package:crowdleague/auth/user_auth_service.dart';
import 'package:crowdleague/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/user_service.dart';
import '../utils/locator.dart';

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
        .retrievePlayer(locate<UserAuthService>().currentUserId!);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: TextField(
                controller: _textController,
                autofocus: true,
              ),
            ),
            const Text('Name'),
          ],
        ),
      ),
    );
  }
}
