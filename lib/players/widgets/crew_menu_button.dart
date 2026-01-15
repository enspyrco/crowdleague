import 'package:flutter/material.dart';

class CrewMenuButton extends StatefulWidget {
  const CrewMenuButton({required this.callback, super.key});

  final Function callback;

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
            widget.callback();
          },
          child: Text(
            'Split your crews',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        MenuItemButton(
          onPressed: () {},
          child: Text(
            'Unfollow',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
      builder: (_, MenuController controller, Widget? child) {
        return TextButton.icon(
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(Icons.arrow_drop_down),
          label: Text(
            'Part of your crew',
            style: Theme.of(context).textTheme.displaySmall!,
          ),
        );
      },
    );
  }
}
