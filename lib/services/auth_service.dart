import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Wraps the FirebaseAuth.instance to allow providing test doubles in tests.
///
/// The AuthService accesses the UserService in its constructor so the
/// UserService must be added to the service provider before the AuthService.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth}) {
    firebaseAuth == null ? _auth = FirebaseAuth.instance : _auth = firebaseAuth;
  }

  late final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() {
    final provider = AppleAuthProvider();
    return _auth.signInWithProvider(provider);
  }

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
