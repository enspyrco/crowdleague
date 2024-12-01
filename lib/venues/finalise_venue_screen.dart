import 'dart:io';

import 'package:crowdleague/services/user_service.dart';
import 'package:crowdleague/services/venues_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../services/images_service.dart';
import '../utils/locator.dart';

class FinaliseVenueScreen extends StatefulWidget {
  const FinaliseVenueScreen({super.key});

  @override
  State<FinaliseVenueScreen> createState() => _FinaliseVenueScreenState();
}

class _FinaliseVenueScreenState extends State<FinaliseVenueScreen> {
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
          final venueId = await locate<VenuesService>().addNewVenueToDB();
          final photoUrl = await locate<ImagesService>().uploadPhoto(
            localPath: _croppedFilePath!,
            storagePath: 'venuePhotos/$venueId',
          );
          await locate<VenuesService>()
              .updateVenue(id: venueId, photoUrl: photoUrl);

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
            Stack(
              children: [
                if (_croppedFilePath != null)
                  Image.file(File(_croppedFilePath!)),
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
