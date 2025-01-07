import 'package:crowdleague/services/user_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart';

class CrewMenuButton extends StatefulWidget {
  const CrewMenuButton({required this.playerId, super.key});

  final String playerId;

  @override
  State<CrewMenuButton> createState() => _CrewMenuButtonState();
}

class _CrewMenuButtonState extends State<CrewMenuButton> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        MenuItemButton(
          onPressed: () {
            locate<UserService>().splitCrews(widget.playerId);
          },
          child: const Text('Split your crews'),
        ),
        MenuItemButton(
          onPressed: () {},
          child: const Text('Unfollow'),
        ),
      ],
      builder: (_, MenuController controller, Widget? child) {
        return TextButton(
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Text('Part of your crew'),
        );
      },
    );
  }
}
