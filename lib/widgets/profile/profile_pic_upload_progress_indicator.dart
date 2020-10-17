import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/storage/upload_task.dart';
import 'package:flutter/material.dart';

class ProfilePicUploadProgressIndicator extends StatelessWidget {
  final UploadTask task;

  const ProfilePicUploadProgressIndicator(
    this.task, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (task.state == UploadTaskState.processing) {
      return CircularProgressIndicator(
        value: null,
        strokeWidth: 8,
      );
    }

    final hasValues =
        task.bytesTransferred != null && task.totalByteCount != null;
    double progress; // show indeterminate unless there are valid values
    if (hasValues) {
      progress = task.bytesTransferred / task.totalByteCount;
      if (progress < 0.1) {
        // or a small progress value
        progress = null;
      }
    }
    return CircularProgressIndicator(
      value: progress,
      strokeWidth: 8,
    );
  }
}
