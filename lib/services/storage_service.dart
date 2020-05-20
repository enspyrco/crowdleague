import 'dart:io';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/actions/storage/update_upload_task_info.dart';
import 'package:crowdleague/enums/storage/update_upload_task_type.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:crowdleague/extensions/extensions.dart';

class StorageService {
  final FirebaseStorage profilePicsStorage;
  final Map<String, StorageUploadTask> _tasks = <String, StorageUploadTask>{};

  StorageService(this.profilePicsStorage);

  Stream<ReduxAction> uploadProfilePic(String userId, String filePath) async* {
    final uuid = Uuid().v1();

    // emit a setup event to create the entry in the store that will be used
    // by each subsequent update event
    yield UpdateUploadTaskInfo((b) => b
      ..type = UpdateUploadTaskType.setup
      ..uuid = uuid);

    final ref = profilePicsStorage.ref().child(userId).child(uuid);
    final uploadTask = ref.putFile(
      File(filePath),
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    _tasks[uuid] = uploadTask;

    await for (final action in uploadTask.events
        .map<UpdateUploadTaskInfo>((event) => event.toUpdateUploadTaskInfo())) {
      yield action;
    }
  }
}
