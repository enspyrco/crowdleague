library navigate_to;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'navigate_to.g.dart';

abstract class NavigateTo extends Object
    with ReduxAction
    implements Built<NavigateTo, NavigateToBuilder> {
  String get location;

  NavigateTo._();

  factory NavigateTo([void Function(NavigateToBuilder) updates]) = _$NavigateTo;

  Object toJson() => serializers.serializeWith(NavigateTo.serializer, this);

  static NavigateTo fromJson(String jsonString) => serializers.deserializeWith(
      NavigateTo.serializer, json.decode(jsonString));

  static Serializer<NavigateTo> get serializer => _$navigateToSerializer;

  @override
  String toString() => 'NAVIGATE_TO: $location';
}
