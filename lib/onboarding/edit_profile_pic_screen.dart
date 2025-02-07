import 'dart:developer';

import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../services/images_service.dart';
import '../auth/user_auth_service.dart';
import '../utils/widgets/avatar/async_avatar.dart';
import '../utils/widgets/avatar/file_avatar.dart';
import '../utils/locator.dart';

class EditProfilePicScreen extends StatefulWidget {
  const EditProfilePicScreen({required this.onboarding, super.key});

  final String onboarding;

  @override
  State<EditProfilePicScreen> createState() => _EditProfilePicScreenState();
}

class _EditProfilePicScreenState extends State<EditProfilePicScreen> {
  String? _croppedFilePath;
  bool _uploading = false;
  bool _onboarding = false;

  Future<void> _onPickPhotoButtonPressed(ImageSource source) async {
    try {
      setState(() {
        _uploading = true;
      });
      XFile? pickedFile = await locate<ImagesService>().pickImage(source);
      if (pickedFile == null) {
        if (mounted) {
          setState(() {
            _uploading = false;
          });
        }
      } else {
        final croppedFilePath =
            await locate<ImagesService>().cropImage(pickedFile);
        if (croppedFilePath == null) {
          if (mounted) {
            setState(() {
              _uploading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _croppedFilePath = croppedFilePath;
            });
          }
          locate<ImagesService>().saveLargeProfilePic(_croppedFilePath!);

          final int smallSize = 100;
          await locate<ImagesService>()
              .resizeImage(filePath: _croppedFilePath!, size: smallSize);

          locate<ImagesService>()
              .saveSmallProfilePic(_croppedFilePath!, smallSize);

          if (mounted) {
            context.push('/onboard-notifications');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        log(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _onboarding = widget.onboarding.parseBool();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              (_onboarding)
                  ? context.push('/onboard-notifications')
                  : context.pop();
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Stack(
              children: [
                if (_croppedFilePath != null)
                  FileAvatar(
                    picPath: _croppedFilePath!,
                    size: 100,
                  ),
                if (_croppedFilePath == null)
                  StreamBuilder<Map<String, Object?>?>(
                    stream: locate<UserAuthService>().profileDocStream,
                    builder: (context, snapshot) {
                      return AsyncAvatar(
                        locate<UserAuthService>().currentUserId!,
                        PicSize.large,
                        widgetSize: 100,
                      );
                    },
                  ),
                if (_uploading) LinearProgressIndicator(),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Flexible(
                        flex: 1,
                        child: IconButton.outlined(
                          onPressed: () =>
                              _onPickPhotoButtonPressed(ImageSource.gallery),
                          icon: const Icon(Icons.photo),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('Pick from Gallery'),
                          ))
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Flexible(
                        flex: 1,
                        child: IconButton.outlined(
                          onPressed: () =>
                              _onPickPhotoButtonPressed(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Take a Photo'),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
