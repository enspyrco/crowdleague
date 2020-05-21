import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String photoURL;

  ProfileAvatar(this.photoURL);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 45,
        backgroundImage: Image.network(photoURL).image,
      ),
      onTap: () {
        context.dispatch(PickProfilePic());
      },
    );
  }
}
