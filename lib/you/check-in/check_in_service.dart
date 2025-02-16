import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckInService {
  const CheckInService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  void createCheckIn(String venueId, DateTime startTime, Duration duration) {
    _firestore.collection('check-ins').add({
      'venueId': venueId,
      'startTime': Timestamp.fromDate(startTime),
      'duration': duration.inMinutes,
      'playerId': _auth.currentUser!.uid
    });
  }
}
