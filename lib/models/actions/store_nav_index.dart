library store_main_page_index;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/serializers.dart';

part 'store_nav_index.g.dart';

abstract class StoreNavIndex extends Object
    with ReduxAction
    implements Built<StoreNavIndex, StoreNavIndexBuilder> {
  int get index;

  StoreNavIndex._();

  factory StoreNavIndex([void Function(StoreNavIndexBuilder) updates]) =
      _$StoreNavIndex;

  Object toJson() => serializers.serializeWith(StoreNavIndex.serializer, this);

  static StoreNavIndex fromJson(String jsonString) => serializers
      .deserializeWith(StoreNavIndex.serializer, json.decode(jsonString));

  static Serializer<StoreNavIndex> get serializer => _$storeNavIndexSerializer;

  @override
  String toString() => 'STORE_NAV_INDEX';
}
