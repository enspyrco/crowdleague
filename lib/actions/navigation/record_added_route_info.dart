library record_added_route_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/navigation/route_info.dart';

part 'record_added_route_info.g.dart';

abstract class RecordAddedRouteInfo extends Object
    with ReduxAction
    implements Built<RecordAddedRouteInfo, RecordAddedRouteInfoBuilder> {
  RouteInfo get info;

  RecordAddedRouteInfo._();

  factory RecordAddedRouteInfo(
          [void Function(RecordAddedRouteInfoBuilder) updates]) =
      _$RecordAddedRouteInfo;

  Object toJson() =>
      serializers.serializeWith(RecordAddedRouteInfo.serializer, this);

  static RecordAddedRouteInfo fromJson(String jsonString) =>
      serializers.deserializeWith(
          RecordAddedRouteInfo.serializer, json.decode(jsonString));

  static Serializer<RecordAddedRouteInfo> get serializer =>
      _$recordAddedRouteInfoSerializer;

  @override
  String toString() => 'RECORD_ADDED_ROUTE_INFO: ${info.name}';
}
