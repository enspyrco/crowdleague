library record_removed_route_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/navigation/route_info.dart';

part 'record_removed_route_info.g.dart';

abstract class RecordRemovedRouteInfo extends Object
    with ReduxAction
    implements Built<RecordRemovedRouteInfo, RecordRemovedRouteInfoBuilder> {
  RouteInfo get info;

  RecordRemovedRouteInfo._();

  factory RecordRemovedRouteInfo(
          [void Function(RecordRemovedRouteInfoBuilder) updates]) =
      _$RecordRemovedRouteInfo;

  Object toJson() =>
      serializers.serializeWith(RecordRemovedRouteInfo.serializer, this);

  static RecordRemovedRouteInfo fromJson(String jsonString) =>
      serializers.deserializeWith(
          RecordRemovedRouteInfo.serializer, json.decode(jsonString));

  static Serializer<RecordRemovedRouteInfo> get serializer =>
      _$recordRemovedRouteInfoSerializer;

  @override
  String toString() => 'RECORD_REMOVED_ROUTE_INFO: ${info.name}';
}
