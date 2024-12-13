import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../venues/models/upload_event.dart';

class StorageService {
  final _storage = FirebaseStorage.instanceFor(
      bucket: "gs://crowdleague-project.firebasestorage.app");

  final uploadEventStreamController = StreamController<UploadEvent>();

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

  /// Returns a Stream of UploadEvents that carry the progress of the upload
  Stream<UploadEvent> uploadFile(
      {required String localPath, required String storagePath}) {
    final storageRef = _storage.ref(storagePath);
    UploadTask task = storageRef.putFile(File(localPath));
    return task.snapshotEvents.map<UploadEvent>((snapshot) {
      var progress = snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
      if (progress.isInfinite) progress = 1;
      if (progress.isNaN) progress = 0;
      return UploadEvent(progress: progress);
    });
  }

  // Returns a Future with the download Url of a file that was uploaded
  Future<String> getDownLoadUrl({required String storagePath}) {
    final storageRef = _storage.ref(storagePath);
    return storageRef.getDownloadURL();
  }

  /// Returns a Future with the download Url of the bytes that were uploaded.
  Stream<UploadEvent> uploadBytes(
      {required Uint8List bytes, required String storagePath}) {
    final storageRef = _storage.ref(storagePath);
    UploadTask task = storageRef.putData(bytes);
    return task.snapshotEvents.map<UploadEvent>((snapshot) {
      var progress = snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
      if (progress.isInfinite) progress = 1;
      if (progress.isNaN) progress = 0;
      return UploadEvent(progress: progress);
    });
  }

  Future<void> deleteFile(String path, String fileName) {
    return _storage.ref(path).child(fileName).delete();
  }
}
