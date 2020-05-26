import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

extension ConvertToLeaguer on DocumentSnapshot {
  Leaguer toLeaguer() {
    return Leaguer((b) => b
      ..uid = documentID
      ..displayName = data['displayName'] as String
      ..photoUrl = data['photoURL'] as String ??
          'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y');
  }
}
