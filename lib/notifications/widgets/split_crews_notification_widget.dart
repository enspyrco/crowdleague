import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/views/notification_view_model.dart';

class SplitCrewsNotificationWidget extends StatelessWidget {
  const SplitCrewsNotificationWidget(
    SplitCrewsNotificationViewModel viewModel, {
    super.key,
  }) : _viewModel = viewModel;

  final SplitCrewsNotificationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.white,
      child: ListTile(
        onTap: () {
          context.pushNamed('player-profile', pathParameters: {
            'id': _viewModel.playerId,
          });
        },
        leading: Avatar(playerId: _viewModel.playerId, picSize: PicSize.small),
        title: Text('${_viewModel.playerName}\'s crew was split from yours',
            style: Theme.of(context).textTheme.bodyLarge!),
      ),
    );
  }
}
