import 'dart:async';

import 'package:crowdleague/services/notifications_service.dart';
import 'package:mockito/mockito.dart';

class FakeNotificationsService extends Fake implements NotificationsService {
  FakeNotificationsService();

  @override
  void printToken() {
    print('token123');
  }

  @override
  FutureOr<bool> requestPermissions() {
    // doesn't do anything, so the prompt isn't displayed and doesn't
    // mess with integration tests
    return true;
  }
}
