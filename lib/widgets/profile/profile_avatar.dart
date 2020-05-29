import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String _photoURL;

  ProfileAvatar({String photoURL}) : _photoURL = photoURL;

  @override
  Widget build(BuildContext context) {
    try {
      return GestureDetector(
        child: CircleAvatar(
            radius: 45, backgroundImage: Image.network(_photoURL).image),
        onTap: () {
          context.dispatch(
              UpdateProfilePage((b) => b..selectingProfilePic = true));
        },
        onDoubleTap: () {
          context.dispatch(PickProfilePic());
        },
      );
    } on NetworkImageLoadException {
      return Container();
    }
  }
}
