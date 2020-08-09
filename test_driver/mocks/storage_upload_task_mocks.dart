import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/mockito.dart';

class FakeStorageUploadTask extends Fake implements StorageUploadTask {
  FakeStorageUploadTask(StreamController<StorageTaskEvent> controller)
      : _controller = controller;

  StreamController<StorageTaskEvent> _controller;
  Stream<StorageTaskEvent> get events => _controller.stream;
}
