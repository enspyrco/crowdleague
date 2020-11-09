import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/mockito.dart';

class FakeStorageUploadTask extends Fake implements UploadTask {
  FakeStorageUploadTask(StreamController<TaskSnapshot> controller)
      : _controller = controller;

  final StreamController<TaskSnapshot> _controller;

  @override
  Stream<TaskSnapshot> get events => _controller.stream;
}
