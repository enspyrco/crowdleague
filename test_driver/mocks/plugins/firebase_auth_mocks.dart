import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mockito/mockito.dart';

class FakeFirebaseAuthPeriodic extends Fake implements auth.FirebaseAuth {
  @override
  Stream<auth.User> get onAuthStateChanged =>
      Stream.periodic(Duration(seconds: 1), (tickNum) {
        if (tickNum > 1) tickNum = 1;
        return <auth.User>[FakeAuthUserNull(), FakeAuthUser()]
            .elementAt(tickNum);
      });
}

// emits a auth.User with null members then a FirebaseUser with random
// values (this follows the pattern when a user is signed in and starts the app)
class FakeFirebaseAuth1 extends Fake implements auth.FirebaseAuth {
  @override
  Stream<auth.User> authStateChanges() =>
      Stream.fromIterable([FakeAuthUserNull(), FakeAuthUser()]);

  @override
  Future<auth.UserCredential> signInWithCredential(
          auth.AuthCredential credential) =>
      Future.value(FakeUserCredential());
}

class FakeFirebaseAuthOpen extends Fake implements auth.FirebaseAuth {
  final controller = StreamController<auth.User>();

  @override
  Stream<auth.User> get onAuthStateChanged => controller.stream;

  void add(auth.User user) => controller.add(user);

  void close() {
    controller.close();
  }
}

// a auth.User with all null members
class FakeAuthUserNull extends Fake implements auth.User {
  @override
  String get uid => null;
  @override
  String get displayName => null;
  @override
  String get email => null;
  @override
  String get photoUrl => null;

  @override
  List<auth.UserInfo> providerData;
}

class FakeAuthUser extends Fake implements auth.User {
  @override
  String get uid => 'uid';
  @override
  String get displayName => 'name';
  @override
  String get email => 'email';
  @override
  String get photoUrl => 'url';

  @override
  List<auth.UserInfo> providerData = [];
}

class FakeUserCredential extends Fake implements auth.UserCredential {
  /// Returns the currently signed-in [auth.User], or `null` if there isn't
  /// any (i.e. the user is signed out).
  @override
  final auth.User user = FakeAuthUser();
}
