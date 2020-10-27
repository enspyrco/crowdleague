import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/navigation/remove_current_page.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/models/settings/settings.dart';
import 'package:crowdleague/utils/redux/redux_bundle.dart';
import 'package:crowdleague/utils/wrappers/firebase_wrapper.dart';
import 'package:crowdleague/widgets/app/initializing_error_page.dart';
import 'package:crowdleague/widgets/app/initializing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CrowdLeagueApp extends StatefulWidget {
  final FirebaseWrapper _firebase;
  final ReduxBundle _redux;

  CrowdLeagueApp({FirebaseWrapper firebase, ReduxBundle redux})
      : _firebase = firebase ?? FirebaseWrapper(),
        _redux = redux;
  @override
  _CrowdLeagueAppState createState() => _CrowdLeagueAppState();
}

class _CrowdLeagueAppState extends State<CrowdLeagueApp> {
  ReduxBundle _redux;
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

      // use the injected redux bundle if there is one or create one
      _redux = widget._redux ?? ReduxBundle();
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
      return InitializingErrorPage(error: _error, trace: StackTrace.current);
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
            theme: ThemeDataExt.from(settings.lightTheme),
            darkTheme: ThemeDataExt.from(settings.darkTheme),
            themeMode: ThemeModeExt.from(settings.brightnessMode),
            home: StoreConnector<AppState, BuiltList<PageData>>(
              distinct: true,
              converter: (store) => store.state.pagesData,
              builder: (context, pagesData) => Navigator(
                  pages: pagesData.toPages(),
                  onPopPage: (route, dynamic result) {
                    if (!route.didPop(result)) {
                      return false;
                    }

                    if (route.isCurrent) {
                      _store.dispatch(RemoveCurrentPage());
                    }

                    return true;
                  }),
            ),
          );
        },
      ),
    );
  }
}
