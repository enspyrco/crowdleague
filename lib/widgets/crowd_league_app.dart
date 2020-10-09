import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/navigation/entries/navigator_entry.dart';
import 'package:crowdleague/models/settings/settings.dart';
import 'package:crowdleague/utils/redux/navigation_info_recorder.dart';
import 'package:crowdleague/utils/redux/services_bundle.dart';
import 'package:crowdleague/utils/wrappers/firebase_wrapper.dart';
import 'package:crowdleague/widgets/auth/auth_page.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CrowdLeagueApp extends StatefulWidget {
  final FirebaseWrapper _firebase;
  final ServicesBundle _redux;

  CrowdLeagueApp({FirebaseWrapper firebase, ServicesBundle redux})
      : _firebase = firebase ?? FirebaseWrapper(),
        _redux = redux;
  @override
  _CrowdLeagueAppState createState() => _CrowdLeagueAppState();
}

class _CrowdLeagueAppState extends State<CrowdLeagueApp> {
  ServicesBundle _redux;
  Store<AppState> _store;
  dynamic _error;
  bool _initializedFirebase = false;
  bool _initializedRedux = false;

  // Define an async function to initialize FlutterFire
  void initialize() async {
    try {
      // firebase must be initialised first so createStore() can run
      await widget._firebase.init();
      setState(() {
        _initializedFirebase = true;
      });

      // use the injected services bundle if there is one or create one
      _redux =
          widget._redux ?? ServicesBundle(navKey: GlobalKey<NavigatorState>());
      // create the redux store and run any extra operations
      _store = await _redux.createStore();
      setState(() {
        _initializedRedux = true;
      });

      // dispatch initial actions
      _store.dispatch(ObserveAuthState());
      _store.dispatch(RequestFCMPermissions());
      _store.dispatch(PrintFCMToken());
      _store.dispatch(CheckPlatform());

      /// This should happen once on app load, the various streams from the
      /// [FirebaseFirestore] database are changed but the [DatabaseService] stream
      /// controller is connected to the redux [Store] then remains unchanged.
      _store.dispatch(PlumbDatabaseStream());
    } catch (e) {
      setState(() {
        _error = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorPage(error: _error, trace: StackTrace.current);
    }

    // Show a loader until FlutterFire is initialized
    if (!_initializedFirebase || !_initializedRedux) {
      return InitializingIndicator(
        firebaseDone: _initializedFirebase,
        reduxDone: _initializedRedux,
      );
    }

    return StoreProvider<AppState>(
      store: _store,
      child: StoreConnector<AppState, Settings>(
        distinct: true,
        converter: (store) => store.state.settings,
        builder: (context, settings) {
          return MaterialApp(
            navigatorKey: _redux.navKey,
            navigatorObservers: [NavigationInfoRecorder(_store)],
            theme: ThemeDataExt.from(settings.lightTheme),
            darkTheme: ThemeDataExt.from(settings.darkTheme),
            themeMode: ThemeModeExt.from(settings.brightnessMode),
            home: StoreConnector<AppState, BuiltList<NavigatorEntry>>(
              distinct: true,
              converter: (store) => store.state.navigatorEntries,
              builder: (context, navigatorEntries) => Navigator(
                pages: navigatorEntries.toPages(),
                onPopPage: (route, dynamic result) => route.didPop(result),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A StoreConnector that builds either the AuthPage or MainPage depending on
/// the auth state.
class AuthOrMain extends StatelessWidget {
  const AuthOrMain({
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

/// This widget is just a CircularProgressIndicator and some text, in a
/// Material widget so it looks nice, as it is used outside of the MaterialApp.
///
/// It's a separate widget as the existing ProgressIndicator widget doesn't
/// need to have it's contents in a Material widget.
class InitializingIndicator extends StatelessWidget {
  final bool firebaseDone;
  final bool reduxDone;
  const InitializingIndicator({
    @required this.firebaseDone,
    @required this.reduxDone,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var message = '';
    if (!firebaseDone) {
      message = 'Waiting for Firebase...';
    } else if (!reduxDone) {
      message = 'Waiting for Redux...';
    }
    return Material(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text(message, textDirection: TextDirection.ltr)
          ]),
    );
  }
}

/// This widget just displays the available info if there is an error during
/// intialization.
///
/// It's not particularly pretty but it shouldn't ever be seen and if it is,
/// we just need to view the available info.
class ErrorPage extends StatelessWidget {
  final dynamic _error;
  final StackTrace _trace;
  const ErrorPage({
    @required dynamic error,
    @required StackTrace trace,
    Key key,
  })  : _error = error,
        _trace = trace,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SizedBox(height: 50),
            Text('Looks like there was a problem.',
                textDirection: TextDirection.ltr),
            SizedBox(height: 20),
            Text(_error.toString(), textDirection: TextDirection.ltr),
            SizedBox(height: 50),
            Text(_trace.toString(), textDirection: TextDirection.ltr),
          ],
        ),
      ),
    );
  }
}
