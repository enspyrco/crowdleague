library upload_profile_pic;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'upload_profile_pic.g.dart';

abstract class UploadProfilePic extends Object
    with ReduxAction
    implements Built<UploadProfilePic, UploadProfilePicBuilder> {
  String get filePath;

  UploadProfilePic._();

  factory UploadProfilePic([void Function(UploadProfilePicBuilder) updates]) =
      _$UploadProfilePic;

  Object toJson() =>
      serializers.serializeWith(UploadProfilePic.serializer, this);

  static UploadProfilePic fromJson(String jsonString) => serializers
      .deserializeWith(UploadProfilePic.serializer, json.decode(jsonString));

  static Serializer<UploadProfilePic> get serializer =>
      _$uploadProfilePicSerializer;

  @override
  String toString() => 'UPLOAD_PROFILE_PIC';
}
