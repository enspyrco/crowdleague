library store_profile_pics;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'store_profile_pics.g.dart';

abstract class StoreProfilePics extends Object
    with ReduxAction
    implements Built<StoreProfilePics, StoreProfilePicsBuilder> {
  BuiltList<String> get profilePicIds;

  StoreProfilePics._();

  factory StoreProfilePics([void Function(StoreProfilePicsBuilder) updates]) =
      _$StoreProfilePics;

  Object toJson() =>
      serializers.serializeWith(StoreProfilePics.serializer, this);

  static StoreProfilePics fromJson(String jsonString) => serializers
      .deserializeWith(StoreProfilePics.serializer, json.decode(jsonString));

  static Serializer<StoreProfilePics> get serializer =>
      _$storeProfilePicsSerializer;

  @override
  String toString() => 'STORE_PROFILE_PICS';
}
