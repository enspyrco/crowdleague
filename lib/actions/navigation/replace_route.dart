library replace_route;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'replace_route.g.dart';

abstract class ReplaceRoute extends Object
    with ReduxAction
    implements Built<ReplaceRoute, ReplaceRouteBuilder> {
  String get oldRouteName;
  String get newRouteName;

  ReplaceRoute._();

  factory ReplaceRoute([void Function(ReplaceRouteBuilder) updates]) =
      _$ReplaceRoute;

  Object toJson() => serializers.serializeWith(ReplaceRoute.serializer, this);

  static ReplaceRoute fromJson(String jsonString) => serializers
      .deserializeWith(ReplaceRoute.serializer, json.decode(jsonString));

  static Serializer<ReplaceRoute> get serializer => _$replaceRouteSerializer;

  @override
  String toString() => 'REPLACE_ROUTE';
}
