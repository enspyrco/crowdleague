import 'package:crowdleague/services/auth_service.dart';

import '../utils/locator.dart';
import 'firestore_service.dart';

class UserService {
  Stream<Map<String, Object?>?> get profileDocStream => _profileDocStream;

  final Stream<Map<String, Object?>?> _profileDocStream =
      locate<FirestoreService>().documentStream(
          path: 'profiles/${locate<AuthService>().currentUserId}');
}
