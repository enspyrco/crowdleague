import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instanceFor(
      bucket: "gs://crowdleague-project.firebasestorage.app");

  Stream<double> uploadWithProgress(
      {required String localPath, required String storagePath}) {
    final storageRef = _storage.ref(storagePath);
    UploadTask task = storageRef.putFile(File(localPath));
    return task.asStream().map<double>((snapshot) {
      double uploadProgress =
          snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
      if (uploadProgress > 0.99) return 1.0;
      return uploadProgress;
    });
  }

  /// Returns a reference to the uploaded file.
  Future<Reference> uploadFile(
      {required String localPath, required String storagePath}) async {
    final storageRef = _storage.ref(storagePath);
    UploadTask task = storageRef.putFile(File(localPath));
    await task;
    return storageRef;
  }

  /// Returns a reference to the uploaded bytes.
  Future<Reference> uploadBytes(
      {required Uint8List bytes, required String storagePath}) async {
    final storageRef = _storage.ref(storagePath);
    UploadTask task = storageRef.putData(bytes);
    await task;
    return storageRef;
  }

  Future<void> deleteFile(String path, String fileName) {
    return _storage.ref(path).child(fileName).delete();
  }
}
