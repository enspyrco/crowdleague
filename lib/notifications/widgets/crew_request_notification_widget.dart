import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/widgets/avatar.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../utils/locator.dart';
import '../models/views/notification_view_model.dart';

class CrewRequestNotificationWidget extends StatefulWidget {
  const CrewRequestNotificationWidget(
    CrewRequestNotificationViewModel viewModel, {
    super.key,
  }) : _notificationViewModel = viewModel;

  final CrewRequestNotificationViewModel _notificationViewModel;

  @override
  State<CrewRequestNotificationWidget> createState() =>
      _CrewRequestNotificationWidgetState();
}

class _CrewRequestNotificationWidgetState
    extends State<CrewRequestNotificationWidget> {
  bool _isAccepting = false;
  bool _isDeclining = false;

  Future<void> _acceptCrewRequest() async {
    setState(() => _isAccepting = true);
    await locate<UserService>().acceptCrewRequest(
      requesterId: widget._notificationViewModel.requesterId,
      requesteeId: widget._notificationViewModel.requesteeId,
      notificationId: widget._notificationViewModel.notification.id,
    );
  }

  Future<void> _declineCrewRequest() async {
    setState(() => _isDeclining = true);
    await locate<UserService>().declineCrewRequest(
      widget._notificationViewModel.notification.id,
      widget._notificationViewModel.requesterId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isAccepting || _isDeclining;
    final showWaiting = widget._notificationViewModel.waiting || _isAccepting;

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.white,
      child: ListTile(
        leading: Avatar(
            playerId: widget._notificationViewModel.requesterId,
            picSize: PicSize.small),
        title: Text(
          '${widget._notificationViewModel.requesterName} wants to join crews',
          style: Theme.of(context).textTheme.bodyLarge!,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        subtitle: Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            if (!showWaiting && !_isDeclining) ...[
              OutlinedButton(
                onPressed: isLoading ? null : _acceptCrewRequest,
                child: Text(
                  'Accept',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
              OutlinedButton(
                onPressed: isLoading ? null : _declineCrewRequest,
                child: Text(
                  'Decline',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
            ] else if (_isDeclining)
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Declining...'),
                ],
              )
            else
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Updating crew members...'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
