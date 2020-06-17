import 'package:crowdleague/actions/storage/update_upload_task.dart';
import 'package:crowdleague/enums/storage/upload_task_update_type.dart';

final mockUpdateUploadTask = UpdateUploadTask((b) => b
  ..type = UploadTaskUpdateType.progress
  ..failure = null
  ..bytesTransferred = 1
  ..totalByteCount = 1000
  ..uploadSessionUri = null
  ..uuid = 'uuid');
