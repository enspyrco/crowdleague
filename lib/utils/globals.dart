import 'package:flutter/foundation.dart';

const String kDatabaseName = (kReleaseMode) ? '(default)' : 'firestore-usa';
const String kBucketName = kReleaseMode
    ? 'crowdleague-project-aus'
    : 'crowdleague-project.firebasestorage.app';
