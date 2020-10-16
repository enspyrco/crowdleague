import 'package:crowdleague/models/storage/upload_failure.dart';
import 'package:firebase_storage/firebase_storage.dart';

extension StorageTaskSnapshotExt on StorageTaskSnapshot {
  UploadFailure getUploadFailure() {
    if (error == null) return null;
    String description;
    switch (error) {
      case StorageError.bucketNotFound:
        description = 'Bucket Not Found';
        break;
      case StorageError.canceled:
        description = 'Cancelled';
        break;
      case StorageError.invalidChecksum:
        description = 'Invalid Checksum';
        break;
      case StorageError.notAuthenticated:
        description = 'Not Authenticated';
        break;
      case StorageError.notAuthorized:
        description = 'Not Authorized';
        break;
      case StorageError.objectNotFound:
        description = 'Object Not Found';
        break;
      case StorageError.projectNotFound:
        description = 'Project Not Found';
        break;
      case StorageError.quotaExceeded:
        description = 'Quota Exceeded';
        break;
      case StorageError.retryLimitExceeded:
        description = 'Retry Limit Exceeded';
        break;
      case StorageError.unknown:
        description = 'Unknown';
        break;
      default:
        description = 'Really Unkown';
    }

    return UploadFailure(code: error, description: description);
  }
}
