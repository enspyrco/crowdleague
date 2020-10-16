import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFireBaseAuth extends Mock implements FirebaseAuth {}

class FakeFirebaseAuthPeriodic extends Fake implements FirebaseAuth {
  @override
  Stream<auth.User> get onAuthStateChanged =>
      Stream.periodic(Duration(seconds: 1), (tickNum) {
        if (tickNum > 1) tickNum = 1;
        return [FakeAuthUser(), FakeAuthUser()].elementAt(tickNum);
      });
}

class FakeFirebaseAuthSignInException extends Fake implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'test error: cant find user');
}

class FakeFirebaseAuthThrows extends Fake implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      throw Exception('firebaseAuth.signIn');
  @override
  Future<void> signOut() {
    throw Exception('firebaseAuth.signOut');
  }
}

class FakeFirebaseAuth1 extends Fake implements FirebaseAuth {
  @override
  Stream<auth.User> authStateChanges() => Stream.fromIterable([FakeAuthUser()]);

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      Future.value(FakeAuthCredential());
}

class FakeFirebaseAuthOpen extends Fake implements FirebaseAuth {
  final controller = StreamController<auth.User>();

  @override
  Stream<auth.User> get onAuthStateChanged => controller.stream;

  void add(auth.User user) => controller.add(user);

  void close() {
    controller.close();
  }
}

// class Fakeauth.UserNull extends Fake implements auth.User {
//   @override
//   String get uid => null;
//   @override
//   String get displayName => null;
//   @override
//   String get email => null;
//   @override
//   String get photoUrl => null;

//   @override
//   List<UserInfo> providerData;
// }

class FakeAuthUser extends Fake implements auth.User {
  @override
  String get uid => 'uid';
  @override
  String get displayName => 'name';
  @override
  String get email => 'email';
  @override
  String get photoURL => 'url';

  @override
  List<UserInfo> providerData = [];
}

class FakeAuthCredential extends Fake implements UserCredential {
  /// Returns the currently signed-in [auth.User], or `null` if there isn't
  /// any (i.e. the user is signed out).
  @override
  final auth.User user = FakeAuthUser();
}
