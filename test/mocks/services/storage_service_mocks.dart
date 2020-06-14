import 'dart:async';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:mockito/mockito.dart';

class MockStorageService extends Mock implements StorageService {}

class FakeStorageService extends Fake implements StorageService {
  final StreamController<ReduxAction> _controller;

  FakeStorageService(StreamController<ReduxAction> controller)
      : _controller = controller;

  @override
  Stream<ReduxAction> uploadProfilePic(String userId, String filePath) =>
      _controller.stream;
}
