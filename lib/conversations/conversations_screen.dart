import 'package:crowdleague/conversations/models/view/conversation_view_model.dart';
import 'package:crowdleague/conversations/widgets/conversation_widget.dart';
import 'package:crowdleague/conversations/conversations_service.dart';
import 'package:flutter/material.dart';

import '../utils/locator.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<ConversationViewModel>>(
          future:
              locate<ConversationsService>().retrieveConversationViewModels(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final List<ConversationViewModel> conversationViewModels =
                  snapshot.data!;
              return ListView.builder(
                  itemCount: conversationViewModels.length,
                  itemBuilder: (context, index) {
                    return ConversationWidget(
                        conversationViewModel: conversationViewModels[index]);
                  });
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No messages yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start a conversation from a player profile',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
