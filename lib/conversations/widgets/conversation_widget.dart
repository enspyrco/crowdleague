import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/view/conversation_view_model.dart';

class ConversationWidget extends StatelessWidget {
  const ConversationWidget({required this.conversationViewModel, super.key});

  final ConversationViewModel conversationViewModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed('conversation',
            pathParameters: {'id': conversationViewModel.conversation.id});
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Avatar(
                playerId: conversationViewModel.lastMessagePlayerId,
                picSize: PicSize.small),
          ),
          Column(children: [
            Text(conversationViewModel.lastMessagePlayerName,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!),
            Text(
              conversationViewModel.lastMessageText,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w300),
            ),
          ]),
        ],
      ),
    );
  }
}
