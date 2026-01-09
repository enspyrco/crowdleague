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
    return Column(
      children: [
        if (_croppedFilePath != null)
          Stack(
            children: [
              Screenshot(
                controller: _screenshotController,
                child: VenueIcon(
                  filePath: _croppedFilePath!,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_croppedFilePath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        if (_croppedFilePath == null)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Add a venue photo',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _onPickPhotoButtonPressed(ImageSource.gallery),
              icon: const Icon(Icons.photo),
              label: const Text('Gallery'),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: () => _onPickPhotoButtonPressed(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
          ],
        ),
        if (_loading) ...[
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
