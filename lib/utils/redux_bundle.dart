import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/middleware/app_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/utils/services_bundle.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

/// [_navKey] is a [GlobalKey] that is used in the []
class ReduxBundle {
  Store<AppState> _store;

  // if in RDT mode, create a RemoteDevToolsMiddleware
  final RemoteDevToolsMiddleware _remoteDevtools =
      (const bool.fromEnvironment('RDT'))
          ? RemoteDevToolsMiddleware<dynamic>('localhost:8000')
          : null;

  ReduxBundle({@required ServicesBundle services}) {
    _store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: [
        ...createAppMiddleware(
            authService: services.auth,
            navigationService: services.navigation,
            databaseService: services.database,
            notificationsService: services.notifications,
            storageService: services.storage,
            deviceService: services.device),
        if (const bool.fromEnvironment('RDT')) _remoteDevtools
      ],
    );

    // if in RDT mode, give RDT access to the store
    if (const bool.fromEnvironment('RDT')) {
      _remoteDevtools.store = _store;
    }
  }

  // Initialisation - if env var exists, connect to RDT and/or setup emulators
  Future<void> _init() async {
    if (const bool.fromEnvironment('RDT')) {
      await _remoteDevtools.connect();
    }

    if (const bool.fromEnvironment('EMULATORS')) {
      await Firestore.instance.settings(
        host: 'localhost:8080',
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }
  }

  static Future<ReduxBundle> create(ServicesBundle servicesBundle) async {
    var reduxBundle = ReduxBundle(services: servicesBundle);
    await reduxBundle._init();
    return reduxBundle;
  }

  Store<AppState> get store => _store;
}
