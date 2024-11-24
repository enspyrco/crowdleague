import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instanceFor(
      bucket: "gs://crowdleague-project.firebasestorage.app");

  Reference createReference({required String at}) {
    final storageRef = _storage.ref();
    return storageRef.child(at);
  }
}
