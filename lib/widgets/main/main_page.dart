import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/actions/navigation/navigate_to.dart';
import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/enums/nav_bar_selection.dart';
import 'package:crowdleague/widgets/chats/conversations/conversations_page.dart';
import 'package:crowdleague/widgets/more_options/more_options_page.dart';
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
          appBar: AppBar(
            leading: AccountButton(),
          ),
          body: BodyWidget(
            selection: selection,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.dispatch(
                  NavigateTo((b) => b..location = '/new_conversation'));
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: NavBar(selectedIndex: selection.index),
        );
      },
    );
  }
}

class NavBar extends StatelessWidget {
  final int selectedIndex;

  const NavBar({
    @required this.selectedIndex,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Text(
            'sports_basketball',
            style: TextStyle(
              fontFamily: 'maticons',
            ),
          ),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Business'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          title: Text('Conversations'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_vert),
          title: Text('More'),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    context.dispatch(StoreNavBarSelection(
        (b) => b..selection = NavBarSelection.valueOfIndex(index)));
  }
}

class BodyWidget extends StatelessWidget {
  final NavBarSelection selection;
  const BodyWidget({
    @required this.selection,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (selection) {
      case NavBarSelection.home:
        return Center(child: Text('Home Page'));
      case NavBarSelection.business:
        return Center(child: Text('Business Page'));
      case NavBarSelection.conversations:
        return ConversationSummariesPage();
      case NavBarSelection.more:
        return MoreOptionsPage();
      default:
        return Center(child: Text('Main Page'));
    }
  }
}

class AccountButton extends StatelessWidget {
  const AccountButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        size: 50,
      ),
      onPressed: () {
        context.dispatch(NavigateTo((b) => b..location = '/profile'));
      },
    );
  }
}
