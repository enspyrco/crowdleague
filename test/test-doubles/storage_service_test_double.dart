import 'dart:async';

import 'dart:typed_data';

import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/venues/models/upload_event.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

class StorageServiceTestDouble implements StorageService {
  final storage = MockFirebaseStorage();

  @override
  Future<void> deleteFile(String path, String fileName) {
    // TODO: implement deleteFile
    throw UnimplementedError();
  }

  @override
  Stream<UploadEvent> uploadBytes(
      {required Uint8List bytes, required String storagePath}) {
    // TODO: implement uploadBytes
    throw UnimplementedError();
  }

  @override
  // TODO: implement uploadEventStreamController
  StreamController<UploadEvent> get uploadEventStreamController =>
      throw UnimplementedError();

  @override
  Stream<UploadEvent> uploadFile(
      {required String localPath, required String storagePath}) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

  @override
  Stream<double> uploadWithProgress(
      {required String localPath, required String storagePath}) {
    // TODO: implement uploadWithProgress
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> downloadBytes(String storagePath) {
    // TODO: implement downloadBytes
    throw UnimplementedError();
  }
}
