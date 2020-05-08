library store_leaguers;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';

part 'store_leaguers.g.dart';

abstract class StoreLeaguers extends Object
    with ReduxAction
    implements Built<StoreLeaguers, StoreLeaguersBuilder> {
  BuiltList<Leaguer> get leaguers;

  StoreLeaguers._();

  factory StoreLeaguers([void Function(StoreLeaguersBuilder) updates]) =
      _$StoreLeaguers;

  Object toJson() => serializers.serializeWith(StoreLeaguers.serializer, this);

  static StoreLeaguers fromJson(String jsonString) => serializers
      .deserializeWith(StoreLeaguers.serializer, json.decode(jsonString));

  static Serializer<StoreLeaguers> get serializer => _$storeLeaguersSerializer;

  @override
  String toString() => 'STORE_LEAGUERS: x${leaguers.length}';
}
