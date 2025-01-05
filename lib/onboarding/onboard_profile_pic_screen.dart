import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../services/images_service.dart';
import '../services/user_auth_service.dart';
import '../utils/async_avatar.dart';
import '../utils/file_avatar.dart';
import '../utils/locator.dart';

class OnboardProfilePicScreen extends StatefulWidget {
  const OnboardProfilePicScreen({super.key});

  @override
  State<OnboardProfilePicScreen> createState() =>
      _OnboardProfilePicScreenState();
}

class _OnboardProfilePicScreenState extends State<OnboardProfilePicScreen> {
  String? _croppedFilePath;
  bool _uploading = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.push('/onboard-notifications');
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
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
                        bytesFuture:
                            locate<ImagesService>().retrieveLargeProfilePic(),
                        size: 100,
                      );
                    },
                  ),
                if (_uploading) LinearProgressIndicator(),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed: () =>
                      _onPickPhotoButtonPressed(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                ),
                const SizedBox(width: 50),
                IconButton.outlined(
                  onPressed: () =>
                      _onPickPhotoButtonPressed(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
