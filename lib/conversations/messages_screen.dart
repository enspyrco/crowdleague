import 'package:crowdleague/auth/user_auth_service.dart';
import 'package:flutter/material.dart';

import 'conversations_service.dart';
import '../utils/locator.dart';
import 'models/message.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({required this.conversationId, super.key});

  final String conversationId;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
                stream: locate<ConversationsService>()
                    .messagesStreamFor(widget.conversationId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final message = messages[index];
                        if (message.senderId ==
                            locate<UserAuthService>().currentUserId) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                message.value,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ),
                          );
                        }
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              message.value,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.onSecondary),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 8.0, bottom: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                    controller: _controller,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        locate<ConversationsService>().sendMessage(
                            widget.conversationId, _controller.text);
                        _controller.clear();
                      }
                    },
                    icon: Icon(Icons.arrow_upward_rounded))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
