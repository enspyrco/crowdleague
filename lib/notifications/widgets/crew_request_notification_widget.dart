import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/widgets/avatar.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../utils/locator.dart';
import '../models/views/notification_view_model.dart';

class CrewRequestNotificationWidget extends StatelessWidget {
  const CrewRequestNotificationWidget(
    CrewRequestNotificationViewModel viewModel, {
    super.key,
  }) : _notificationViewModel = viewModel;

  final CrewRequestNotificationViewModel _notificationViewModel;

  Future<void> _declineCrewRequest(
      String notificationId, String requesterId) async {
    locate<UserService>().declineCrewRequest(
      notificationId,
      requesterId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.white,
      child: ListTile(
        leading: Avatar(playerId: _notificationViewModel.requesterId, picSize: PicSize.small),
        title: Text(
          '${_notificationViewModel.requesterName} wants to join crews',
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
        subtitle: Row(
          children: [
            if (!_notificationViewModel.waiting) ...[
              OutlinedButton(
                onPressed: () {
                  locate<UserService>().acceptCrewRequest(
                    requesterId: _notificationViewModel.requesterId,
                    requesteeId: _notificationViewModel.requesteeId,
                    notificationId: _notificationViewModel.notification.id,
                  );
                },
                child: Text(
                  'Accept',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  _declineCrewRequest(_notificationViewModel.notification.id,
                      _notificationViewModel.requesterId);
                },
                child: Text(
                  'Decline',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
            ] else
              Text('Updating crew members...'),
          ],
        ),
      ),
    );
  }
}
