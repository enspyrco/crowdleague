import 'package:crowdleague/actions/profile/select_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ListProfileAvatar extends StatelessWidget {
  final String _picId;
  final String _picURL;

  ListProfileAvatar({String picId, String picURL})
      : _picURL = picURL,
        _picId = picId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
          radius: 45, backgroundImage: Image.network(_picURL).image),
      onTap: () {
        context.dispatch(SelectProfilePic((b) => b..picId = _picId));
        context.dispatch(UpdateProfilePage((b) => b
          ..leaguerPhotoURL = _picURL
          ..selectingProfilePic = false));
      },
    );
  }
}
