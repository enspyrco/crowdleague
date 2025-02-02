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
            if (snapshot.hasData) {
              final List<ConversationViewModel> conversationViewModels =
                  snapshot.data!;
              return ListView.builder(
                  itemCount: conversationViewModels.length,
                  itemBuilder: (context, index) {
                    return ConversationWidget(
                        conversationViewModel: conversationViewModels[index]);
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}
