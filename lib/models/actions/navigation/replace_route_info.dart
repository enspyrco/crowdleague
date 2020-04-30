library replace_route_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/route_info.dart';
import 'package:crowdleague/models/serializers.dart';

part 'replace_route_info.g.dart';

abstract class ReplaceRouteInfo extends Object
    with ReduxAction
    implements Built<ReplaceRouteInfo, ReplaceRouteInfoBuilder> {
  RouteInfo get oldInfo;
  RouteInfo get newInfo;

  ReplaceRouteInfo._();

  factory ReplaceRouteInfo([void Function(ReplaceRouteInfoBuilder) updates]) =
      _$ReplaceRouteInfo;

  Object toJson() =>
      serializers.serializeWith(ReplaceRouteInfo.serializer, this);

  static ReplaceRouteInfo fromJson(String jsonString) => serializers
      .deserializeWith(ReplaceRouteInfo.serializer, json.decode(jsonString));

  static Serializer<ReplaceRouteInfo> get serializer =>
      _$replaceRouteInfoSerializer;

  @override
  String toString() =>
      'REPLACE_ROUTE_INFO: ${oldInfo.name} with ${newInfo.name}';
}
