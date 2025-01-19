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
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              minRadius: 30,
              backgroundColor: Colors.red,
              backgroundImage:
                  MemoryImage(conversationViewModel.lastMessagePicData),
            ),
          ),
          Column(children: [
            Text(conversationViewModel.lastMessageName,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!),
            Text(
              conversationViewModel.identifyingLastMessageValue,
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
