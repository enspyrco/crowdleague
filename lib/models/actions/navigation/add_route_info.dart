library add_route_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/navigation/route_info.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'add_route_info.g.dart';

abstract class AddRouteInfo extends Object
    with ReduxAction
    implements Built<AddRouteInfo, AddRouteInfoBuilder> {
  RouteInfo get info;

  AddRouteInfo._();

  factory AddRouteInfo([void Function(AddRouteInfoBuilder) updates]) =
      _$AddRouteInfo;

  Object toJson() => serializers.serializeWith(AddRouteInfo.serializer, this);

  static AddRouteInfo fromJson(String jsonString) => serializers
      .deserializeWith(AddRouteInfo.serializer, json.decode(jsonString));

  static Serializer<AddRouteInfo> get serializer => _$addRouteInfoSerializer;

  @override
  String toString() => 'ADD_ROUTE: ${info.name}';
}
