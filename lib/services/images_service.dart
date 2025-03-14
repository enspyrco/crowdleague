import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/painting.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagesService {
  ImagesService({
    required FirebaseStorage storage,
    required FirebaseAuth firebaseAuth,
  })  : _storage = storage,
        _auth = firebaseAuth;

  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source, maxHeight: 1000);
    if (pickedFile == null) return null;
    return pickedFile;
  }

  Future<String?> cropImage(XFile pickedFile) async {
    // We need the dimensions to set rectWidth/rectHeight in the iOSUISettings
    // as this seems to be the only way to start the cropper as a square.
    final imageBytes = await pickedFile.readAsBytes();
    var decodedImage = await decodeImageFromList(imageBytes);
    int width = decodedImage.width;
    int height = decodedImage.height;
    int squareSize = (width > height) ? width : height;
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
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
    return croppedFile?.path;
  }

  Future<void> saveProfilePic(String filePath) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    final storageRef =
        _storage.ref('profiles/${_auth.currentUser!.uid}/$timestamp.jpg');
    await storageRef.putFile(File(filePath));
  }
}
