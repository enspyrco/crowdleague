import 'dart:io';

import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _profilePicsStorage;
  final Map<String, UploadTask> _tasks = <String, UploadTask>{};

  StorageService(FirebaseStorage profilePicsStorage)
      : _profilePicsStorage = profilePicsStorage;

  Stream<ReduxAction> uploadProfilePic(String userId, String filePath) async* {
    final uuid = Uuid().v1();

    // emit a setup event to create the entry in the store that will be used
    // by each subsequent update event
    yield UpdateUploadTask(
        state: UploadTaskState.setup, uuid: uuid, filePath: filePath);

    // the profile page vm now has the uuid that it can use to access the upload
    // task
    yield UpdateProfilePage(uploadingProfilePicId: uuid);

    final ref = _profilePicsStorage.ref().child(userId).child(uuid);
    final uploadTask = ref.putFile(
      File(filePath),
      SettableMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    _tasks[uuid] = uploadTask;

    await for (final action in uploadTask.snapshotEvents
        .map<UpdateUploadTask>((event) => event.toUpdateUploadTask())) {
      yield action;
    }
  }
}
