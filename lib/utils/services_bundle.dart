import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/middleware/app_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/utils/apple_signin_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';

/// Services can be injected, or if missing are given default values
class ServicesBundle {
  // Store<AppState> _store;

  // if in RDT mode, create a RemoteDevToolsMiddleware
  final RemoteDevToolsMiddleware _remoteDevtools =
      (const bool.fromEnvironment('RDT'))
          ? RemoteDevToolsMiddleware<dynamic>('localhost:8000')
          : null;

  static const String bucketName = bool.fromEnvironment('EMULATORS')
      ? 'gs://profile-pics-prototyping'
      : 'gs://crowdleague-profile-pics';

  /// Services
  final AuthService _authService;
  final NavigationService _navigationService;
  final DatabaseService _databaseService;
  final NotificationsService _notificationsService;
  final StorageService _storageService;
  final DeviceService _deviceService;

  ServicesBundle(
      {@required GlobalKey<NavigatorState> navKey,
      AuthService authService,
      NavigationService navigationService,
      DatabaseService databaseService,
      NotificationsService notificationsService,
      StorageService storageService,
      DeviceService deviceService})
      : _authService = authService ??
            AuthService(
              FirebaseAuth.instance,
              GoogleSignIn(scopes: <String>['email']),
              AppleSignInObject(),
            ),
        _navigationService = navigationService ?? NavigationService(navKey),
        _databaseService =
            databaseService ?? DatabaseService(FirebaseFirestore.instance),
        _notificationsService =
            notificationsService ?? NotificationsService(FirebaseMessaging()),
        _storageService = storageService ??
            StorageService(
              FirebaseStorage(
                  app: FirebaseFirestore.instance.app,
                  storageBucket: bucketName),
            ),
        _deviceService =
            deviceService ?? DeviceService(imagePicker: ImagePicker());

  AuthService get auth => _authService;
  NavigationService get navigation => _navigationService;
  DatabaseService get database => _databaseService;
  NotificationsService get notifications => _notificationsService;
  StorageService get storage => _storageService;
  DeviceService get device => _deviceService;

  Future<Store<AppState>> get store async {
    final _store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: [
        ...createAppMiddleware(
            authService: _authService,
            navigationService: _navigationService,
            databaseService: _databaseService,
            notificationsService: _notificationsService,
            storageService: _storageService,
            deviceService: _deviceService),
        if (const bool.fromEnvironment('RDT')) _remoteDevtools
      ],
    );

    // if in RDT mode, give RDT access to the store
    if (const bool.fromEnvironment('RDT')) {
      _remoteDevtools.store = _store;
    }

    if (const bool.fromEnvironment('RDT')) {
      await _remoteDevtools.connect();
    }

    if (const bool.fromEnvironment('EMULATORS')) {
      FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080',
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }

    return _store;
  }
}
