library store_profile_pics;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'store_profile_pics.g.dart';

abstract class StoreProfilePics extends Object
    with ReduxAction
    implements Built<StoreProfilePics, StoreProfilePicsBuilder> {
  BuiltList<ProfilePic> get profilePics;

  StoreProfilePics._();

  factory StoreProfilePics({@required BuiltList<ProfilePic> profilePics}) =
      _$StoreProfilePics._;

  factory StoreProfilePics.by(
      [void Function(StoreProfilePicsBuilder) updates]) = _$StoreProfilePics;

  Object toJson() =>
      serializers.serializeWith(StoreProfilePics.serializer, this);

  static StoreProfilePics fromJson(String jsonString) => serializers
      .deserializeWith(StoreProfilePics.serializer, json.decode(jsonString));

  static Serializer<StoreProfilePics> get serializer =>
      _$storeProfilePicsSerializer;

  @override
  String toString() => 'STORE_PROFILE_PICS';
}
