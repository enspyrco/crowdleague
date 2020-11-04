import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';

final mockUpdateUploadTask = UpdateUploadTask(
    state: UploadTaskState.inProgress,
    failure: null,
    bytesTransferred: 1,
    totalByteCount: 1000,
    uploadSessionUri: null,
    uuid: 'uuid');
