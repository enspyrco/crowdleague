import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/storage/upload_task.dart';

final mockUploadTask1 = UploadTask(
    uuid: 'uuid1',
    filePath: 'path',
    state: UploadTaskState.inProgress,
    bytesTransferred: 1,
    totalByteCount: 100);
