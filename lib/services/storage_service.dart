import 'dart:io';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/actions/storage/update_storage_task_info.dart';
import 'package:crowdleague/enums/storage/update_storage_task_type.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:crowdleague/extensions/extensions.dart';

class StorageService {
  final FirebaseStorage storage;
  final Map<String, StorageUploadTask> _tasks = <String, StorageUploadTask>{};

  StorageService(this.storage);

  Stream<ReduxAction> uploadProfilePic(String userId, String filePath) async* {
    final uuid = Uuid().v1();

    // emit a setup event to create the entry in the store that will be used
    // by each subsequent update event
    yield UpdateStorageTaskInfo((b) => b
      ..type = UpdateStorageTaskType.setup
      ..uuid = uuid);

    final ref = storage.ref().child('profilePics').child(userId).child(uuid);
    final uploadTask = ref.putFile(
      File(filePath),
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    _tasks[uuid] = uploadTask;

    await for (final action in uploadTask.events
        .map<UpdateStorageTaskInfo>((event) => event.toReduxAction())) {
      yield action;
    }
  }
}
