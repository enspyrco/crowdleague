library navigator_pop_all;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'navigator_pop_all.g.dart';

abstract class NavigatorPopAll extends Object
    with ReduxAction
    implements Built<NavigatorPopAll, NavigatorPopAllBuilder> {
  NavigatorPopAll._();

  factory NavigatorPopAll([void Function(NavigatorPopAllBuilder) updates]) =
      _$NavigatorPopAll;

  Object toJson() =>
      serializers.serializeWith(NavigatorPopAll.serializer, this);

  static NavigatorPopAll fromJson(String jsonString) => serializers
      .deserializeWith(NavigatorPopAll.serializer, json.decode(jsonString));

  static Serializer<NavigatorPopAll> get serializer =>
      _$navigatorPopAllSerializer;

  @override
  String toString() => 'NAVIGATOR_POP_ALL';
}
