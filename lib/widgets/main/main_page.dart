// import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
// import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
// import 'package:crowdleague/models/navigation/page_data/new_conversation_page_data.dart';
import 'package:crowdleague/widgets/main/account_button.dart';
import 'package:crowdleague/widgets/main/main_page_body.dart';
import 'package:crowdleague/widgets/main/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NavBarSelection>(
      distinct: true,
      converter: (store) => store.state.navBarSelection,
      builder: (context, selection) {
        return Scaffold(
          appBar: AppBar(leading: AccountButton()),
          body: MainPageBody(selection: selection),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () =>
          //       context.dispatch(PushPage(data: NewConversationPageData())),
          //   child: Icon(Icons.add),
          // ),
          bottomNavigationBar: NavBar(selectedIndex: selection.index),
        );
      },
    );
  }
}
