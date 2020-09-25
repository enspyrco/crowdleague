library record_replaced_route_info;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/navigation/route_info.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'record_replaced_route_info.g.dart';

abstract class RecordReplacedRouteInfo extends Object
    with ReduxAction
    implements Built<RecordReplacedRouteInfo, RecordReplacedRouteInfoBuilder> {
  RouteInfo get oldInfo;
  RouteInfo get newInfo;

  RecordReplacedRouteInfo._();

  factory RecordReplacedRouteInfo(
      {@required RouteInfo oldInfo,
      @required RouteInfo newInfo}) = _$RecordReplacedRouteInfo._;

  factory RecordReplacedRouteInfo.by(
          [void Function(RecordReplacedRouteInfoBuilder) updates]) =
      _$RecordReplacedRouteInfo;

  Object toJson() =>
      serializers.serializeWith(RecordReplacedRouteInfo.serializer, this);

  static RecordReplacedRouteInfo fromJson(String jsonString) =>
      serializers.deserializeWith(
          RecordReplacedRouteInfo.serializer, json.decode(jsonString));

  static Serializer<RecordReplacedRouteInfo> get serializer =>
      _$recordReplacedRouteInfoSerializer;

  @override
  String toString() =>
      'RECORD_REPLACED_ROUTE_INFO: ${oldInfo.name} with ${newInfo.name}';
}
