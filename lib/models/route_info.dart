library route_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/serializers.dart';

part 'route_info.g.dart';

abstract class RouteInfo implements Built<RouteInfo, RouteInfoBuilder> {
  String get name;
  @nullable
  Object get arguments;

  RouteInfo._();

  factory RouteInfo([void Function(RouteInfoBuilder) updates]) = _$RouteInfo;

  Object toJson() => serializers.serializeWith(RouteInfo.serializer, this);

  static RouteInfo fromJson(String jsonString) => serializers.deserializeWith(
      RouteInfo.serializer, json.decode(jsonString));

  static Serializer<RouteInfo> get serializer => _$routeInfoSerializer;
}
