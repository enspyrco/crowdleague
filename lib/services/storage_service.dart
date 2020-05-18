import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage;
  final List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  StorageService(this.storage);

  Future<void> uploadProfilePic(
      String userId, String profilePicId, String filePath) async {
    final ref =
        storage.ref().child('profilePics').child(userId).child(profilePicId);
    final uploadTask = ref.putFile(
      File(filePath),
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    _tasks.add(uploadTask);
  }
}
