import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSubscriptions {
  StreamSubscription<QuerySnapshot> processingFailures;
  StreamSubscription<QuerySnapshot> conversations;
  StreamSubscription<QuerySnapshot> messages;
  StreamSubscription<QuerySnapshot> profilePics;
  StreamSubscription<DocumentSnapshot> profile;
}
