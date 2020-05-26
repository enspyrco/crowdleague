import 'dart:io';

import 'package:crowdleague/actions/device/pick_profile_pic.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String photoURL;
  final String filePath;

  ProfileAvatar({this.photoURL, this.filePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 45,
        backgroundImage: (photoURL != null)
            ? Image.network(photoURL).image
            : Image.file(File(filePath)).image,
      ),
      onTap: () {
        context.dispatch(PickProfilePic());
      },
    );
  }
}
