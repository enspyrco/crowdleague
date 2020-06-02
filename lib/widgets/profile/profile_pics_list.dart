import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';
import 'package:crowdleague/widgets/profile/list_profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfilePicsList extends StatelessWidget {
  final BuiltList<ProfilePic> _profilePics;

  ProfilePicsList(
      {BuiltList<ProfilePic> profilePics,
      BuiltSet<String> deletingPicIds,
      String userId})
      : _profilePics = profilePics;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _profilePics.length,
          itemBuilder: (context, index) {
            final pic = _profilePics[index];
            return ListProfileAvatar(profilePic: pic);
          }),
    );
  }
}
