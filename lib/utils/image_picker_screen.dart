import 'dart:io';

import 'package:crowdleague/services/firestore_service.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _croppedFile;
  Object? _error;
  bool _uploading = false;
  double _uploadProgress = 0.0;

  Future<void> _onPickPhotoButtonPressed(
      BuildContext context, ImageSource source) async {
    if (mounted) {
      try {
        final XFile? pickedFile =
            await _picker.pickImage(source: source, maxHeight: 1000);
        if (pickedFile == null) return;
        final imageBytes = await pickedFile.readAsBytes();
        var decodedImage = await decodeImageFromList(imageBytes);
        _cropImage(
          // ignore: use_build_context_synchronously (as we check if mounted where it is used)
          context,
          pickedFile.path,
          decodedImage.width,
          decodedImage.height,
        );
      } catch (e) {
        setState(() {
          _error = e;
        });
      }
    }
  }

  Future<void> _cropImage(
      BuildContext context, String path, int width, int height) async {
    int squareSize = (width > height) ? width : height;
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        uiSettings: [
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            rectHeight: squareSize.toDouble(),
            rectWidth: squareSize.toDouble(),
            rectX: 0,
            rectY: 0,
            resetButtonHidden: true,
            aspectRatioPickerButtonHidden: true,
          ),
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            initAspectRatio: CropAspectRatioPreset.square,
            hideBottomControls: true,
          )
        ]);
    if (croppedFile != null) {
      if (mounted) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
      final imageRef = locate<StorageService>()
          .createReference(at: 'profilePics')
          .child(locate<AuthService>().currentUserId ?? '?');
      _uploading = true;
      UploadTask task = imageRef.putFile(File(_croppedFile!.path));
      await for (final snapshot in task.asStream()) {
        _uploadProgress =
            snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
        bool finished = (_uploadProgress > 0.99) ? true : false;
        if (mounted) {
          setState(() {
            if (finished) {
              _uploadProgress = 0.0;
              _uploading = false;
            }
          });
        }
        if (finished) {
          String downloadUrl = await imageRef.getDownloadURL();
          await locate<FirestoreService>().setDoc(
              merge: true,
              path: 'profiles/${locate<AuthService>().currentUserId!}',
              data: {'largePic': downloadUrl});
          if (context.mounted) {
            context.pop();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton.outlined(
                  onPressed: () =>
                      _onPickPhotoButtonPressed(context, ImageSource.gallery),
                  icon: const Icon(Icons.photo)),
              IconButton.outlined(
                  onPressed: () =>
                      _onPickPhotoButtonPressed(context, ImageSource.camera),
                  icon: const Icon(Icons.camera_alt)),
            ],
          ),
          if (_error != null) // display any errors in a Text widget
            Text(
              _error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          if (_croppedFile != null)
            Column(
              children: [
                kIsWeb
                    ? Image.network(
                        _croppedFile!.path,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Center(
                            child:
                                Text('There was a problem downloading image'),
                          );
                        },
                      )
                    : Image.file(
                        File(_croppedFile!.path),
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Center(
                            child: Text('There was a problem opening image'),
                          );
                        },
                      ),
                if (_uploading && _uploadProgress == 0.0)
                  const LinearProgressIndicator(),
                if (_uploading && _uploadProgress > 0.0)
                  LinearProgressIndicator(value: _uploadProgress),
              ],
            ),
        ],
      ),
    );
  }
}
