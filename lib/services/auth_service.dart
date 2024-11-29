import 'package:firebase_auth/firebase_auth.dart';

import '../utils/locator.dart';
import 'user_service.dart';

/// Wraps the FirebaseAuth.instance to allow providing test doubles in tests.
///
/// The AuthService accesses the UserService in its constructor so the
/// UserService must be added to the service provider before the AuthService.
class AuthService {
  AuthService() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        locate<UserService>().listenToProfileStream(user.uid);
      }
    });
  }

  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithProvider(AuthProvider provider) {
    return _auth.signInWithProvider(provider);
  }

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  Future<UserCredential> signInWithCredential(AuthCredential authCredential) {
    return _auth.signInWithCredential(authCredential);
  }
}
