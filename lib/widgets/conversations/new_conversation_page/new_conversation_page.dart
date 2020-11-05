import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/conversations/create_conversation.dart';
import 'package:crowdleague/actions/conversations/retrieve_new_conversation_suggestions.dart';
import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_suggestions.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/widgets/conversations/new_conversation_page/new_conversation_leaguers_list.dart';
import 'package:crowdleague/widgets/conversations/new_conversation_page/new_conversation_selections_list.dart';
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
        body: Column(
          children: [
            StoreConnector<AppState, BuiltList<Leaguer>>(
              distinct: true,
              converter: (store) =>
                  store.state.newConversationPage.selections.leaguers,
              builder: (context, vm) =>
                  NewConversationSelectionsList(items: vm),
            ),
            StoreConnector<AppState, VmNewConversationSuggestions>(
              onInit: (store) =>
                  store.dispatch(RetrieveNewConversationSuggestions()),
              distinct: true,
              converter: (store) => store.state.newConversationPage.suggestions,
              builder: (context, vm) => (vm.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : NewConversationLeaguersList(items: vm.leaguers),
            ),
          ],
        ),
        floatingActionButton: StoreConnector<AppState, bool>(
          distinct: true,
          converter: (store) =>
              store.state.newConversationPage.selections.leaguers.isNotEmpty,
          builder: (context, hasSelections) {
            return (hasSelections)
                ? FloatingActionButton(
                    onPressed: () {
                      if (hasSelections) {
                        context
                            .dispatch(UpdateNewConversationPage(waiting: true));
                        context.dispatch(CreateConversation());
                      }
                    },
                    child: Icon(Icons.done),
                    backgroundColor: Colors.grey)
                : Container();
          },
        ));
  }
}
