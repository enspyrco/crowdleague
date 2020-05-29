import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/widgets/profile/list_profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfilePicsList extends StatelessWidget {
  final BuiltList<String> _profilePicIds;
  final String _userId;

  ProfilePicsList({BuiltList<String> profilePicIds, String userId})
      : _userId = userId,
        _profilePicIds = profilePicIds;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _profilePicIds.length,
          itemBuilder: (context, index) {
            final picId = _profilePicIds[index];
            final picURL =
                'https://storage.googleapis.com/crowdleague-profile-pics/$_userId/${picId}_200x200';
            return ListProfileAvatar(picId: picId, picURL: picURL);
          }),
    );
  }
}
