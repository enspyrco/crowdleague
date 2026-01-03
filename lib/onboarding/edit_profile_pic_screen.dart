import 'dart:developer';

import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/players/models/player.dart';
import 'package:crowdleague/services/user_service.dart';
import 'package:crowdleague/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../services/images_service.dart';
import '../auth/user_auth_service.dart';
import '../utils/widgets/avatar/async_avatar.dart';
import '../utils/widgets/avatar/file_avatar.dart';
import '../utils/locator.dart';

class EditProfilePicScreen extends StatefulWidget {
  const EditProfilePicScreen({required this.onboarding, super.key});

  final String onboarding;

  @override
  State<EditProfilePicScreen> createState() => _EditProfilePicScreenState();
}

class _EditProfilePicScreenState extends State<EditProfilePicScreen> {
  Player? _userPlayer;
  String? _croppedFilePath;
  bool _uploading = false;
  bool _onboarding = false;

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
          await locate<ImagesService>().saveProfilePic(_croppedFilePath!);

          // navigate based on whether we are onboarding or not
          if (mounted && _onboarding) {
            context.push('/onboard-notifications');
          } else if (mounted && !_onboarding) {
            context.pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        log(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _onboarding = widget.onboarding.parseBool();
    _userPlayer = locate<UserAuthService>().getUserPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              (_onboarding)
                  ? context.push('/onboard-notifications')
                  : context.pop();
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_uploading) LinearProgressIndicator(),
            const SizedBox(height: 50),
            Stack(
              children: [
                if (_croppedFilePath != null)
                  FileAvatar(
                    picPath: _croppedFilePath!,
                    size: 100,
                  ),
                if (_croppedFilePath == null)
                  StreamBuilder<Map<String, Object?>?>(
                    stream: locate<UserAuthService>().profileDocStream,
                    builder: (context, snapshot) {
                      return AsyncAvatar(
                        locate<UserAuthService>().currentUserId!,
                        PicSize.medium,
                        widgetSize: 100,
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Flexible(
                        flex: 1,
                        child: IconButton.outlined(
                          onPressed: () =>
                              _onPickPhotoButtonPressed(ImageSource.gallery),
                          icon: const Icon(Icons.photo),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextButton(
                                onPressed: () => _onPickPhotoButtonPressed(
                                    ImageSource.gallery),
                                child: Text('Pick from Gallery')),
                          ))
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Flexible(
                        flex: 1,
                        child: IconButton.outlined(
                          onPressed: () =>
                              _onPickPhotoButtonPressed(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextButton(
                            onPressed: () =>
                                _onPickPhotoButtonPressed(ImageSource.camera),
                            child: Text('Take a Photo')),
                      )),
                    ],
                  ),
                  const SizedBox(height: 30),
                  OldProfilePicsList(userPlayer: _userPlayer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OldProfilePicsList extends StatefulWidget {
  const OldProfilePicsList({
    super.key,
    required Player? userPlayer,
  }) : _userPlayer = userPlayer;

  final Player? _userPlayer;

  @override
  State<OldProfilePicsList> createState() => _OldProfilePicsListState();
}

class _OldProfilePicsListState extends State<OldProfilePicsList> {
  // if we are deleting the onTap will delete rather than select
  bool _deleteOnSelection = false;

  void deleteImage() {
    log("Image deleted!");
    // Add your actual image deletion logic here
  }

  // Function to show the confirmation dialog
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Image"),
          content: Text("Are you sure you want to delete this image?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteImage(); // Call the delete function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _deleteOnSelection
                  ? Text('Tap a pic to delete')
                  : Text('Or select an old pic'),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget._userPlayer?.picIds.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _deleteOnSelection
                    ? () => showDeleteConfirmationDialog(context)
                    : () => locate<UserService>()
                        .updateProfilePic(widget._userPlayer!.picIds[index]),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(
                      locate<ImagesService>().constructProfilePicUrl(
                          playerId: widget._userPlayer!.id,
                          picId: widget._userPlayer!.picIds[index],
                          picSize: PicSize.small),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _deleteOnSelection
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          _deleteOnSelection = false;
                        });
                      },
                      child: Text('Cancel'))
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          _deleteOnSelection = true;
                        });
                      },
                      child: Text('Delete a pic')),
            ),
          ],
        ),
      ],
    );
  }
}
