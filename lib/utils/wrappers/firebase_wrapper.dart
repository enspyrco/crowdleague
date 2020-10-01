import 'package:firebase_core/firebase_core.dart';

class FirebaseWrapper {
  Future<FirebaseApp> init() => Firebase.initializeApp();
}
