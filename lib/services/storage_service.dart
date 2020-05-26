import 'dart:io';

import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_update_type.dart';
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
    yield UpdateUploadTask((b) => b
      ..type = UploadTaskUpdateType.setup
      ..uuid = uuid
      ..filePath = filePath);

    // the profile page vm now has the uuid that it can use to access the upload
    // task
    yield UpdateProfilePage((b) => b..uploadingProfilePicId = uuid);

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
        .map<UpdateUploadTask>((event) => event.toUpdateUploadTask())) {
      yield action;
    }
  }
}
