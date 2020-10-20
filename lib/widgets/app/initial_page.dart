import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/widgets/auth/auth_page/auth_page.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// A StoreConnector that builds either the AuthPage or MainPage depending on
/// the auth state.
class InitialPage extends StatelessWidget {
  const InitialPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        distinct: true,
        converter: (store) => store.state.user,
        builder: (context, user) {
          return (user == null || user.id == null) ? AuthPage() : MainPage();
        });
  }
}
