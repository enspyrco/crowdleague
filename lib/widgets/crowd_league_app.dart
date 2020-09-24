import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/settings.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/utils/navigation_info_recorder.dart';
import 'package:crowdleague/utils/services_bundle.dart';
import 'package:crowdleague/widgets/auth/auth_page.dart';
import 'package:crowdleague/widgets/auth/other_auth_options_page.dart';
import 'package:crowdleague/widgets/chats/messages/messages_page.dart';
import 'package:crowdleague/widgets/chats/new_conversation/new_conversation_page.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:crowdleague/widgets/profile/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CrowdLeagueApp extends StatefulWidget {
  @override
  _CrowdLeagueAppState createState() => _CrowdLeagueAppState();
}

class _CrowdLeagueAppState extends State<CrowdLeagueApp> {
  Store<AppState> _store;
  // A GlobalKey that allows the NavigationService to navigate,
  // must be used when creating the MaterialApp widget
  final _navKey = GlobalKey<NavigatorState>();
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });

      final services = ServicesBundle(navKey: _navKey);
      _store = await services.createStore();

      _store.dispatch(ObserveAuthState());
      _store.dispatch(RequestFCMPermissions());
      _store.dispatch(PrintFCMToken());

      /// This should happen once on app load, the various streams from the
      /// [FirebaseFirestore] database are changed but the [DatabaseService] stream
      /// controller is connected to the redux [Store] then remains unchanged.
      _store.dispatch(PlumbDatabaseStream());
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      // TODO: display an error without using redux
      print(_error);
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return CircularProgressIndicator();
    }

    return StoreProvider<AppState>(
      store: _store,
      child: StoreConnector<AppState, Settings>(
          distinct: true,
          converter: (store) => store.state.settings,
          builder: (context, settings) {
            return MaterialApp(
              navigatorKey: _navKey,
              navigatorObservers: [NavigationInfoRecorder(_store)],
              theme: ThemeDataExt.from(settings.lightTheme),
              darkTheme: ThemeDataExt.from(settings.darkTheme),
              themeMode: ThemeModeExt.from(settings.brightnessMode),
              home: CheckAuth(), // becomes the route named '/'
              routes: <String, WidgetBuilder>{
                '/other_auth_options': (context) => OtherAuthOptionsPage(),
                '/conversation': (context) => MessagesPage(),
                '/new_conversation': (context) => NewConversationPage(),
                '/profile': (context) => ProfilePage()
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
