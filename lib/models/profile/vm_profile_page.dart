library vm_profile_page;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'vm_profile_page.g.dart';

abstract class VmProfilePage
    implements Built<VmProfilePage, VmProfilePageBuilder> {
  bool get pickingProfilePic;
  bool get selectingProfilePic;
  BuiltList<ProfilePic> get profilePics;
  @nullable
  String get userId;
  @nullable
  String get leaguerPhotoURL;
  @nullable
  String get uploadingProfilePicId;

  VmProfilePage._();

  factory VmProfilePage(
      {@required bool pickingProfilePic,
      @required bool selectingProfilePic,
      @required BuiltList<ProfilePic> profilePics,
      String userId,
      String leaguerPhotoURL,
      String uploadingProfilePicId}) = _$VmProfilePage._;

  factory VmProfilePage.by([void Function(VmProfilePageBuilder) updates]) =
      _$VmProfilePage;

  static VmProfilePageBuilder initBuilder() => VmProfilePageBuilder()
    ..pickingProfilePic = false
    ..selectingProfilePic = false;

  Object toJson() => serializers.serializeWith(VmProfilePage.serializer, this);

  static VmProfilePage fromJson(String jsonString) => serializers
      .deserializeWith(VmProfilePage.serializer, json.decode(jsonString));

  static Serializer<VmProfilePage> get serializer => _$vmProfilePageSerializer;
}
