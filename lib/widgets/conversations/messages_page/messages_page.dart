import 'package:crowdleague/actions/conversations/disregard_messages.dart';
import 'package:crowdleague/actions/conversations/observe_messages.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/widgets/conversations/messages_page/message_entry/message_entry.dart';
import 'package:crowdleague/widgets/conversations/messages_page/messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: StoreConnector<AppState, bool>(
        distinct: true,
        onInit: (store) => store.dispatch(ObserveMessages()),
        onDispose: (store) => store.dispatch(DisregardMessages()),
        converter: (store) => store.state.messagesPage.summary == null,
        builder: (context, waiting) {
          return (waiting)
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                  children: [Expanded(child: MessagesList()), MessageEntry()],
                ));
        },
      ),
    );
  }
}
