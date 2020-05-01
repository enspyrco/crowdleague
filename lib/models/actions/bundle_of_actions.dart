library bundle_of_actions;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/serializers.dart';

part 'bundle_of_actions.g.dart';

abstract class BundleOfActions extends Object
    with ReduxAction
    implements Built<BundleOfActions, BundleOfActionsBuilder> {
  BuiltList<ReduxAction> get actions;

  BundleOfActions._();

  factory BundleOfActions([void Function(BundleOfActionsBuilder) updates]) =
      _$BundleOfActions;

  Object toJson() =>
      serializers.serializeWith(BundleOfActions.serializer, this);

  static BundleOfActions fromJson(String jsonString) => serializers
      .deserializeWith(BundleOfActions.serializer, json.decode(jsonString));

  static Serializer<BundleOfActions> get serializer =>
      _$bundleOfActionsSerializer;

  @override
  String toString() => 'BUNDLE_OF_ACTIONS';
}
