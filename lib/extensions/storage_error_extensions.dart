import 'package:firebase_storage/firebase_storage.dart';

extension PrintStorageError on int {
  String toStorageErrorString() {
    switch (this) {
      case StorageError.bucketNotFound:
        return 'Bucket Not Found';
      case StorageError.canceled:
        return 'Cancelled';
      case StorageError.invalidChecksum:
        return 'Invalid Checksum';
      case StorageError.notAuthenticated:
        return 'Not Authenticated';
      case StorageError.notAuthorized:
        return 'Not Authorized';
      case StorageError.objectNotFound:
        return 'Object Not Found';
      case StorageError.projectNotFound:
        return 'Project Not Found';
      case StorageError.quotaExceeded:
        return 'Quota Exceeded';
      case StorageError.retryLimitExceeded:
        return 'Retry Limit Exceeded';
      case StorageError.unknown:
        return 'Unknown';
      default:
        return 'Really Unkown';
    }
  }
}
