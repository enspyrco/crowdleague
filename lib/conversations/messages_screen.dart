import 'package:crowdleague/services/user_service.dart';
import 'package:flutter/material.dart';

import 'conversations_service.dart';
import '../players/players_service.dart';
import '../players/models/player.dart';
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
  String? _otherPlayerName;

  @override
  void initState() {
    super.initState();
    // Mark messages as read when opening the conversation
    locate<ConversationsService>().markMessagesAsRead(widget.conversationId);
    _loadOtherPlayerName();
  }

  Future<void> _loadOtherPlayerName() async {
    // Conversation ID is in format "{id1}_{id2}" sorted alphabetically
    final ids = widget.conversationId.split('_');
    final currentUserId = locate<UserService>().currentUserId;
    final otherPlayerId = ids.first == currentUserId ? ids.last : ids.first;

    final Player? player =
        await locate<PlayersService>().retrievePlayer(otherPlayerId);
    if (mounted && player != null) {
      setState(() {
        _otherPlayerName = player.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_otherPlayerName ?? ''),
      ),
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
                            locate<UserService>().currentUserId) {
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
                      hintText: _otherPlayerName != null
                          ? 'Message ${_otherPlayerName!.split(' ').first}...'
                          : 'Type a message...',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.colorScheme.primary, width: 1.0),
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
