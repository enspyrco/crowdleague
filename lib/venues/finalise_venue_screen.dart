import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../services/images_service.dart';
import '../services/venues_service.dart';
import '../utils/locator.dart';
import 'venue_icon.dart';

class FinaliseVenueScreen extends StatefulWidget {
  const FinaliseVenueScreen({super.key});

  @override
  State<FinaliseVenueScreen> createState() => _FinaliseVenueScreenState();
}

class _FinaliseVenueScreenState extends State<FinaliseVenueScreen> {
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
          final venueId = await locate<VenuesService>().addNewVenueToDB();
          // convert the VenueIcon widget to a png? and upload bytes
          final bytes = await _screenshotController.capture();
          final String iconDownloadUrl = (bytes != null)
              ? await locate<ImagesService>().uploadPhotoFromBytes(
                  bytes: bytes, storagePath: 'venuePhotos/${venueId}_icon')
              : '';

          final photoUrl = await locate<ImagesService>().uploadPhotoFromFile(
            localPath: _croppedFilePath!,
            storagePath: 'venuePhotos/$venueId',
          );
          await locate<VenuesService>().updateVenue(
              id: venueId,
              data: {'photoUrl': photoUrl, 'iconUrl': iconDownloadUrl});

          if (mounted) {
            context.go('/');
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
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
                      Image.file(File(_croppedFilePath!)),
                    ],
                  ),
                if (_croppedFilePath == null)
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: const Center(
                        child: Text('photo'),
                      ),
                    ),
                  ),
              ],
            ),
            if (_uploading) const LinearProgressIndicator(),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}
