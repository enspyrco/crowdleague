library navigator_replace_current;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'navigator_replace_current.g.dart';

abstract class NavigatorReplaceCurrent extends Object
    with ReduxAction
    implements Built<NavigatorReplaceCurrent, NavigatorReplaceCurrentBuilder> {
  String get newLocation;

  NavigatorReplaceCurrent._();

  factory NavigatorReplaceCurrent({@required String newLocation}) =
      _$NavigatorReplaceCurrent._;

  factory NavigatorReplaceCurrent.by(
          [void Function(NavigatorReplaceCurrentBuilder) updates]) =
      _$NavigatorReplaceCurrent;

  Object toJson() =>
      serializers.serializeWith(NavigatorReplaceCurrent.serializer, this);

  static NavigatorReplaceCurrent fromJson(String jsonString) =>
      serializers.deserializeWith(
          NavigatorReplaceCurrent.serializer, json.decode(jsonString));

  static Serializer<NavigatorReplaceCurrent> get serializer =>
      _$navigatorReplaceCurrentSerializer;

  @override
  String toString() => 'NAVIGATOR_REPLACE_CURRENT: with $newLocation';
}
