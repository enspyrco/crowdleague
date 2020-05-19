import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/conversations/update_conversation_page.dart';
import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/actions/conversations/create_conversation.dart';
import 'package:crowdleague/actions/leaguers/retrieve_leaguers.dart';
import 'package:crowdleague/actions/navigation/navigator_replace_current.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_leaguers.dart';
import 'package:crowdleague/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/widgets/conversations/conversation/conversation_page.dart';
import 'package:crowdleague/widgets/conversations/new_conversation/new_conversation_leaguers_list.dart';
import 'package:crowdleague/widgets/conversations/new_conversation/new_conversation_selections_list.dart';
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
                  store.state.newConversationsPage.selectionsVM.selections,
              builder: (context, vm) {
                return NewConversationSelectionsList(items: vm);
              },
            ),
            StoreConnector<AppState, VmNewConversationLeaguers>(
              onInit: (store) => store.dispatch(RetrieveLeaguers()),
              distinct: true,
              converter: (store) => store.state.newConversationsPage.leaguersVM,
              builder: (context, vm) {
                if (vm.state == NewConversationPageLeaguersState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return NewConversationLeaguersList(items: vm.leaguers);
              },
            ),
          ],
        ),
        floatingActionButton: StoreConnector<AppState, bool>(
          distinct: true,
          converter: (store) => store
              .state.newConversationsPage.selectionsVM.selections.isNotEmpty,
          builder: (context, hasSelections) {
            return (hasSelections)
                ? FloatingActionButton(
                    onPressed: () {
                      if (hasSelections) {
                        context.dispatch(UpdateNewConversationPage((b) => b
                          ..state = NewConversationPageLeaguersState.waiting));
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
