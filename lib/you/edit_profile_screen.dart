import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../services/images_service.dart';
import '../utils/avatar.dart';
import '../utils/locator.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _croppedFilePath;
  Object? _error;
  bool _uploading = false;
  final _textController = TextEditingController();

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
          final storagePath =
              'profilePics/${locate<AuthService>().currentUserId!}_large';
          // we use an indeterminate progress indicator as the file is so small
          // that the indicator is useless
          await for (final _ in locate<StorageService>().uploadFile(
            localPath: _croppedFilePath!,
            storagePath: storagePath,
          )) {}
          final imageUrl = await locate<StorageService>()
              .getDownLoadUrl(storagePath: storagePath);

          await locate<UserService>()
              .updateProfilePicUrl(size: 'large', url: imageUrl);

          final int smallSize = 50;
          await locate<ImagesService>()
              .resizeImage(filePath: _croppedFilePath!, size: smallSize);

          final storagePathSmall =
              'profilePics/${locate<AuthService>().currentUserId!}_small';

          await for (final _ in locate<StorageService>().uploadFile(
            localPath: '${_croppedFilePath!}_$smallSize',
            storagePath: storagePathSmall,
          )) {}
          final imageUrlSmall = await locate<StorageService>()
              .getDownLoadUrl(storagePath: storagePathSmall);

          await locate<UserService>()
              .updateProfilePicUrl(size: 'small', url: imageUrlSmall);

          if (mounted) {
            context.pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    locate<UserService>().profileDocStream.listen((profile) {
      if (mounted) {
        _textController.text = profile?['name'] as String? ?? 'null';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              locate<UserService>().updateProfileName(_textController.text);
              context.pop();
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
                  Avatar(
                    picPath: _croppedFilePath!,
                    loading: _uploading,
                    size: 100,
                  ),
                if (_croppedFilePath == null)
                  StreamBuilder<Map<String, Object?>?>(
                    stream: locate<UserService>().profileDocStream,
                    builder: (context, snapshot) {
                      return Avatar(
                        picUrl: snapshot.data?['largePic'] as String? ??
                            'https://firebasestorage.googleapis.com/v0/b/crowdleague-project.firebasestorage.app/o/profilePics%2Fempty_profile_pic.jpg?alt=media&token=c8a9c8d7-0c0a-4510-b003-a389473573cb',
                        loading: _uploading,
                        size: 100,
                      );
                    },
                  ),
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
            if (_error != null) // display any errors in a Text widget
              Text(
                _error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: TextField(controller: _textController),
            ),
            const Text('Name'),
          ],
        ),
      ),
    );
  }
}
