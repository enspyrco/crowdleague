import 'package:crowdleague/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../services/images_service.dart';
import 'avatar.dart';
import 'locator.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  String? _croppedFilePath;
  Object? _error;
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
          final storagePath = await locate<ImagesService>()
              .uploadProfilePic(localPath: _croppedFilePath!);
          await locate<UserService>().updateProfilePicUrl(storagePath);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
                      picUrl: snapshot.data?['largePic'] as String?,
                      loading: _uploading,
                      size: 100,
                    );
                  },
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton.outlined(
                  onPressed: () =>
                      _onPickPhotoButtonPressed(ImageSource.gallery),
                  icon: const Icon(Icons.photo)),
              IconButton.outlined(
                  onPressed: () =>
                      _onPickPhotoButtonPressed(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt)),
            ],
          ),
          if (_error != null) // display any errors in a Text widget
            Text(
              _error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
