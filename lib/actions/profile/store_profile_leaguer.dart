library store_profile_leaguer;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

part 'store_profile_leaguer.g.dart';

abstract class StoreProfileLeaguer extends Object
    with ReduxAction
    implements Built<StoreProfileLeaguer, StoreProfileLeaguerBuilder> {
  Leaguer get leaguer;

  StoreProfileLeaguer._();

  factory StoreProfileLeaguer(
          [void Function(StoreProfileLeaguerBuilder) updates]) =
      _$StoreProfileLeaguer;

  Object toJson() =>
      serializers.serializeWith(StoreProfileLeaguer.serializer, this);

  static StoreProfileLeaguer fromJson(String jsonString) => serializers
      .deserializeWith(StoreProfileLeaguer.serializer, json.decode(jsonString));

  static Serializer<StoreProfileLeaguer> get serializer =>
      _$storeProfileLeaguerSerializer;

  @override
  String toString() => 'STORE_PROFILE_LEAGUER';
}
