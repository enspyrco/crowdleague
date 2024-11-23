import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _onImageButtonPressed(ImageSource source) async {
    if (mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        setState(() {
          _setImageFileFromFile(pickedFile);
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  void _setImageFileFromFile(XFile? file) {
    _imageFile = file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          IconButton.outlined(
              onPressed: () => _onImageButtonPressed(ImageSource.gallery),
              icon: const Icon(Icons.browse_gallery)),
          PickedImage(
            imageFile: _imageFile,
          ),
        ],
      ),
    );
  }
}

class PickedImage extends StatelessWidget {
  const PickedImage({required this.imageFile, super.key});

  final XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return const Placeholder();
    } else {
      return (kIsWeb)
          ? Image.network(imageFile!.path)
          : Image.file(File(imageFile!.path), errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Center(
                  child: Text('This image type is not supported'));
            });
    }
  }
}
