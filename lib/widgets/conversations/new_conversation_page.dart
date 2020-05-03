import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/widgets/conversations/new_conversation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewConversationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: StoreConnector<AppState, BuiltList<Leaguer>>(
        distinct: true,
        converter: (store) => store.state.leaguers,
        builder: (context, vm) {
          return NewConversationList(items: vm);
        },
      ),
    );
  }
}
