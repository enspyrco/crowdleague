import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../../../services/images_service.dart';
import '../../../utils/locator.dart';
import '../../models/local_venue.dart';
import 'venue_icon.dart';

class UploadVenuePhoto extends StatefulWidget {
  const UploadVenuePhoto({
    super.key,
    required LocalVenue localVenue,
    required this.updateStateCallback,
  }) : _localVenue = localVenue;

  final LocalVenue _localVenue;
  final void Function(String) updateStateCallback;

  @override
  State<UploadVenuePhoto> createState() => _UploadVenuePhotoState();
}

class _UploadVenuePhotoState extends State<UploadVenuePhoto> {
  String? _croppedFilePath;
  Object? _error;
  bool _loading = false;
  final _screenshotController = ScreenshotController();

  Future<void> _onPickPhotoButtonPressed(ImageSource source) async {
    try {
      setState(() {
        _loading = true;
      });
      XFile? pickedFile = await locate<ImagesService>().pickImage(source);
      if (pickedFile == null) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      } else {
        final croppedFilePath =
            await locate<ImagesService>().cropImage(pickedFile);
        if (croppedFilePath == null) {
          if (mounted) {
            setState(() {
              _loading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _croppedFilePath = croppedFilePath;
              widget.updateStateCallback(_croppedFilePath!);
            });
          }
          widget._localVenue.largePhotoPath = _croppedFilePath;

          // convert the VenueIcon widget to a png and upload bytes
          _screenshotController
              .capture(delay: const Duration(milliseconds: 100))
              .then((bytes) {
            widget._localVenue.iconBytes = bytes;
            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
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
              child: Text('pick a\nphoto'),
            ),
          ),
        if (_loading) const CircularProgressIndicator(),
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
