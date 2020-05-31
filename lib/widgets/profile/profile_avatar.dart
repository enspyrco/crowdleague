import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String _photoURL;
  final bool _pickingPhoto;

  ProfileAvatar({String photoURL, bool pickingPhoto})
      : _photoURL = photoURL,
        _pickingPhoto = pickingPhoto;

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        width: 90,
        height: 90,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: (_pickingPhoto) ? null : 1,
              strokeWidth: 8,
            ),
            GestureDetector(
              child: CircleAvatar(
                  radius: 45, backgroundImage: Image.network(_photoURL).image),
              onTap: () {
                context.dispatch(
                    UpdateProfilePage((b) => b..selectingProfilePic = true));
              },
              onDoubleTap: () {
                context.dispatch(PickProfilePic());
              },
            )
          ],
        ),
      );
    } on NetworkImageLoadException {
      return Container();
    }
  }
}
