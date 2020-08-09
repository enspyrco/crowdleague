import 'package:cloud_firestore/cloud_firestore.dart';
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

/// Services can be injected, or if missing are given default values
class ServicesBundle {
  static const String bucketName = bool.fromEnvironment('FIREBASE_EMULATORS')
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
            databaseService ?? DatabaseService(Firestore.instance),
        _notificationsService =
            notificationsService ?? NotificationsService(FirebaseMessaging()),
        _storageService = storageService ??
            StorageService(
              FirebaseStorage(
                  app: Firestore.instance.app, storageBucket: bucketName),
            ),
        _deviceService =
            deviceService ?? DeviceService(imagePicker: ImagePicker());

  AuthService get auth => _authService;
  NavigationService get navigation => _navigationService;
  DatabaseService get database => _databaseService;
  NotificationsService get notifications => _notificationsService;
  StorageService get storage => _storageService;
  DeviceService get device => _deviceService;
}
