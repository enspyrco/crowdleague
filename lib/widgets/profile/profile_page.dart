import 'package:crowdleague/actions/profile/disregard_profile.dart';
import 'package:crowdleague/actions/profile/disregard_profile_pics.dart';
import 'package:crowdleague/actions/profile/observe_profile.dart';
import 'package:crowdleague/actions/profile/observe_profile_pics.dart';
import 'package:crowdleague/enums/storage/upload_task_state.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
import 'package:crowdleague/models/storage/upload_task.dart';
import 'package:crowdleague/widgets/profile/background_photo.dart';
import 'package:crowdleague/widgets/profile/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: StoreConnector<AppState, VmProfilePage>(
          onInit: (store) {
            store.dispatch(ObserveProfile());
            store.dispatch(ObserveProfilePics());
          },
          onDispose: (store) {
            store.dispatch(DisregardProfilePics());
            store.dispatch(DisregardProfile());
          },
          distinct: true,
          converter: (store) => store.state.profilePage,
          builder: (context, vm) {
            if (vm.leaguer == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Stack(
              children: [
                BackgroundPhoto(),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: SizedBox(
                      width: 90,
                      height: 90,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: (vm.pickingProfilePic) ? null : 1,
                            strokeWidth: 8,
                          ),
                          ProfileAvatar(photoURL: vm.leaguer.photoUrl),
                        ],
                      )),
                ),
                if (vm.uploadingProfilePicId != null)
                  StoreConnector<AppState, UploadTask>(
                    distinct: true,
                    converter: (store) =>
                        store.state.uploadTasksMap[vm.uploadingProfilePicId],
                    builder: (context, task) {
                      return Positioned(
                          bottom: (task.state == UploadTaskState.processing)
                              ? 90
                              : 10,
                          left: 10,
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ProfilePicUploadProgressIndicator(task),
                                ProfileAvatar(filePath: task.filePath),
                              ],
                            ),
                          ));
                    },
                  ),
              ],
            );
          }),
    );
  }
}

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
