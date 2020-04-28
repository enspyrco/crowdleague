import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/actions/auth/sign_out_user.dart';
import 'package:crowdleague/models/actions/store_nav_index.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
      distinct: true,
      converter: (store) => store.state.navIndex,
      builder: (context, selectedIndex) {
        return Scaffold(
          appBar: AppBar(
            leading: AccountButton(),
          ),
          body: Center(child: Text('Main Page')),
          bottomNavigationBar: BottomNavigationBar(
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
                icon: Icon(Icons.search),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_vert),
                title: Text('More'),
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (index) => _onItemTapped(context, index),
          ),
        );
      },
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    context.dispatch(StoreNavIndex((b) => b..index = index));
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
        context.dispatch(SignOutUser());
      },
    );
  }
}
