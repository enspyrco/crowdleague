import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithProvider(AuthProvider provider) {
    return _auth.signInWithProvider(provider);
  }

  String? get currentUserId {
    return _auth.currentUser?.uid;
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }
}
