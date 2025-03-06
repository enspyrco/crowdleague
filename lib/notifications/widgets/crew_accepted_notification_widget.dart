import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/widgets/avatar/async_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        leading: AsyncAvatar(_notificationViewModel.playerId, PicSize.small),
        title: Text(
            '${_notificationViewModel.otherName} is in your crew and you are following each other',
            style: Theme.of(context).textTheme.bodyLarge!),
      ),
    );
  }
}
