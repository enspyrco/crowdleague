library profile_pic;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'profile_pic.g.dart';

abstract class ProfilePic implements Built<ProfilePic, ProfilePicBuilder> {
  String get id;
  String get url;
  bool get deleting;

  ProfilePic._();

  factory ProfilePic(
      {@required String id,
      @required String url,
      @required bool deleting}) = _$ProfilePic._;

  factory ProfilePic.by([void Function(ProfilePicBuilder) updates]) =
      _$ProfilePic;

  Object toJson() => serializers.serializeWith(ProfilePic.serializer, this);

  static ProfilePic fromJson(String jsonString) => serializers.deserializeWith(
      ProfilePic.serializer, json.decode(jsonString));

  static Serializer<ProfilePic> get serializer => _$profilePicSerializer;
}
