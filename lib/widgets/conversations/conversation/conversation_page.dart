import 'package:crowdleague/models/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ConversationPage extends StatelessWidget {
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
        converter: (store) => store.state.conversationPage.item == null,
        builder: (context, waiting) {
          return (waiting)
              ? Center(child: CircularProgressIndicator())
              : Center(child: Text('Conversation'));
        },
      ),
    );
  }
}
