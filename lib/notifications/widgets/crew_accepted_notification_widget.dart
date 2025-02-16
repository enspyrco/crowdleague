import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/widgets/avatar/bytes_avatar.dart';
import '../models/views/notification_view_model.dart';

class CrewAcceptedNotificationWidget extends StatelessWidget {
  const CrewAcceptedNotificationWidget(
    CrewAcceptedNotificationViewModel viewModel, {
    super.key,
  }) : _notificationViewModel = viewModel;

  final CrewAcceptedNotificationViewModel _notificationViewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.white,
      child: ListTile(
        onTap: () {
          context.pushNamed('player-profile',
              pathParameters: {'id': _notificationViewModel.playerId});
        },
        leading: BytesAvatar(_notificationViewModel.otherPicBytes),
        title: Text(
            '${_notificationViewModel.otherName} is in your crew and you are following each other',
            style: Theme.of(context).textTheme.bodyLarge!),
      ),
    );
  }
}
