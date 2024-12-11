import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../../../services/images_service.dart';
import '../../../services/venues_service.dart';
import '../../../utils/locator.dart';
import 'venue_icon.dart';

class UploadVenuePhoto extends StatefulWidget {
  const UploadVenuePhoto({super.key});

  @override
  State<UploadVenuePhoto> createState() => _UploadVenuePhotoState();
}

class _UploadVenuePhotoState extends State<UploadVenuePhoto> {
  String? _croppedFilePath;
  Object? _error;
  bool _uploading = false;
  final _screenshotController = ScreenshotController();

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
          locate<VenuesService>()
              .updateLocalVenue(largePhotoPath: _croppedFilePath);
          // convert the VenueIcon widget to a png and upload bytes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _screenshotController.capture().then((bytes) {
              locate<VenuesService>().updateLocalVenue(iconBytes: bytes);
              if (mounted) {
                setState(() {
                  _uploading = false;
                });
              }
            });
          });
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton.outlined(
                onPressed: () => _onPickPhotoButtonPressed(ImageSource.gallery),
                icon: const Icon(Icons.photo)),
            IconButton.outlined(
                onPressed: () => _onPickPhotoButtonPressed(ImageSource.camera),
                icon: const Icon(Icons.camera_alt)),
          ],
        ),
        if (_croppedFilePath != null)
          Stack(
            children: [
              Screenshot(
                controller: _screenshotController,
                child: VenueIcon(
                  filePath: _croppedFilePath!,
                ),
              ),
              Image.file(File(_croppedFilePath!)),
            ],
          ),
        if (_croppedFilePath == null)
          const AspectRatio(
            aspectRatio: 1.0,
            child: Center(
              child: Text('upload'),
            ),
          ),
        if (_uploading) const LinearProgressIndicator(),
        const SizedBox(height: 20),
        if (_error != null) // display any errors in a Text widget
          Text(
            _error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
