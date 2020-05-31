import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/actions/profile/select_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ListProfileAvatar extends StatelessWidget {
  final String _picId;
  final String _picURL;
  final bool _deleting;

  ListProfileAvatar({String picId, String picURL, bool deleting})
      : _picURL = picURL,
        _picId = picId,
        _deleting = deleting;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: (_deleting) ? null : 1,
            strokeWidth: 8,
          ),
          GestureDetector(
            child: CircleAvatar(
                radius: 45, backgroundImage: Image.network(_picURL).image),
            onTap: () {
              context.dispatch(SelectProfilePic((b) => b..picId = _picId));
              context.dispatch(UpdateProfilePage((b) => b
                ..leaguerPhotoURL = _picURL
                ..selectingProfilePic = false));
            },
            onLongPress: () {
              context.dispatch(DeleteProfilePic((b) => b..picId = _picId));
            },
          )
        ],
      ),
    );
  }
}
