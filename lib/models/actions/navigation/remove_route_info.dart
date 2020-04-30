library remove_route_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/route_info.dart';
import 'package:crowdleague/models/serializers.dart';

part 'remove_route_info.g.dart';

abstract class RemoveRouteInfo extends Object
    with ReduxAction
    implements Built<RemoveRouteInfo, RemoveRouteInfoBuilder> {
  RouteInfo get info;

  RemoveRouteInfo._();

  factory RemoveRouteInfo([void Function(RemoveRouteInfoBuilder) updates]) =
      _$RemoveRouteInfo;

  Object toJson() =>
      serializers.serializeWith(RemoveRouteInfo.serializer, this);

  static RemoveRouteInfo fromJson(String jsonString) => serializers
      .deserializeWith(RemoveRouteInfo.serializer, json.decode(jsonString));

  static Serializer<RemoveRouteInfo> get serializer =>
      _$removeRouteInfoSerializer;

  @override
  String toString() => 'REMOVE_ROUTE_INFO: ${info.name}';
}
