import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _croppedFile;
  Object? _error;

  Future<void> _onPickPhotoButtonPressed(ImageSource source) async {
    if (mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile == null) return;
        var decodedImage =
            await decodeImageFromList(await pickedFile.readAsBytes());
        _cropImage(pickedFile.path, decodedImage.width, decodedImage.height);
      } catch (e) {
        setState(() {
          setState(() {
            _error = e;
          });
        });
      }
    }
  }

  Future<void> _cropImage(String path, int width, int height) async {
    int squareSize = (width > height) ? width : height;
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
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
      setState(() {
        _croppedFile = croppedFile;
      });
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
          if (_croppedFile != null)
            Center(
              child: kIsWeb
                  ? Image.network(_croppedFile!.path, errorBuilder:
                      (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                      return const Center(
                          child: Text('There was a problem downloading'));
                    })
                  : Image.file(File(_croppedFile!.path), errorBuilder:
                      (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                      return const Center(
                          child: Text('This image type is not supported'));
                    }),
            ),
        ],
      ),
    );
  }
}
