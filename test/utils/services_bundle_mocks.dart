import 'dart:async';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/utils/redux/redux_bundle.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:redux/src/store.dart';

import '../mocks/services/auth_service_mocks.dart';
import '../mocks/services/database_service_mocks.dart';
import '../mocks/services/storage_service_mocks.dart';

class FakeReduxBundle extends ReduxBundle {
  final Completer<Store<AppState>> _reduxCompleter;

  FakeReduxBundle(
      {@required Completer<Store<AppState>> completer,
      GlobalKey<NavigatorState> navKey})
      : _reduxCompleter = completer,
        super(
            authService: FakeAuthService(),
            databaseService: FakeDatabaseService(),
            storageService:
                FakeStorageService(StreamController<ReduxAction>()));

  @override
  AuthService get auth => throw UnimplementedError();

  @override
  Future<Store<AppState>> createStore() => _reduxCompleter.future;

  @override
  DatabaseService get database => throw UnimplementedError();

  @override
  DeviceService get device => throw UnimplementedError();

  @override
  NotificationsService get notifications => throw UnimplementedError();

  @override
  StorageService get storage => throw UnimplementedError();
}
