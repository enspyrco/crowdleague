import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/theme_values.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/enums/themes/theme_option.dart';
import 'package:crowdleague/utils/navigation_info_recorder.dart';
import 'package:crowdleague/widgets/auth/auth_page.dart';
import 'package:crowdleague/widgets/auth/other_auth_options_page.dart';
import 'package:crowdleague/widgets/conversations/conversation/conversation_page.dart';
import 'package:crowdleague/widgets/conversations/new_conversation/new_conversation_page.dart';
import 'package:crowdleague/widgets/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CrowdLeagueApp extends StatefulWidget {
  final Store<AppState> store;
  final GlobalKey<NavigatorState> navKey;

  CrowdLeagueApp(this.store, this.navKey);

  @override
  _CrowdLeagueAppState createState() => _CrowdLeagueAppState();
}

class _CrowdLeagueAppState extends State<CrowdLeagueApp> {
  @override
  void initState() {
    super.initState();
    widget.store.dispatch(ObserveAuthState());
    widget.store.dispatch(RequestFCMPermissions());
    widget.store.dispatch(PrintFCMToken());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: StoreConnector<AppState, ThemeValues>(
          distinct: true,
          converter: (store) => store.state.themeValues,
          builder: (context, themeValues) {
            return MaterialApp(
              navigatorKey: widget.navKey,
              navigatorObservers: [NavigationInfoRecorder(widget.store)],
              theme: ThemeDataExt.fromValues(
                  ThemeOption.greyscale_light.themeValues),
              darkTheme: ThemeDataExt.fromValues(
                  ThemeOption.greyscale_dark.themeValues),
              themeMode: (themeValues.brightnessMode.isLight)
                  ? ThemeMode.light
                  : (themeValues.brightnessMode.isDark)
                      ? ThemeMode.dark
                      : ThemeMode.system,
              home: CheckAuth(), // becomes the route named '/'
              routes: <String, WidgetBuilder>{
                '/other_auth_options': (context) => OtherAuthOptionsPage(),
                '/conversation': (context) => ConversationPage(),
                '/new_conversation': (context) => NewConversationPage()
              },
            );
          }),
    );
  }
}

class CheckAuth extends StatelessWidget {
  const CheckAuth({
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
