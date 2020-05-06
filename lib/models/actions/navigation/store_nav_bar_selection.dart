library store_nav_bar_selection;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:crowdleague/models/actions/redux_action.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/enums/nav_bar_selection.dart';

part 'store_nav_bar_selection.g.dart';

abstract class StoreNavBarSelection extends Object
    with ReduxAction
    implements Built<StoreNavBarSelection, StoreNavBarSelectionBuilder> {
  NavBarSelection get selection;

  StoreNavBarSelection._();

  factory StoreNavBarSelection(
          [void Function(StoreNavBarSelectionBuilder) updates]) =
      _$StoreNavBarSelection;

  Object toJson() =>
      serializers.serializeWith(StoreNavBarSelection.serializer, this);

  static StoreNavBarSelection fromJson(String jsonString) =>
      serializers.deserializeWith(
          StoreNavBarSelection.serializer, json.decode(jsonString));

  static Serializer<StoreNavBarSelection> get serializer =>
      _$storeNavBarSelectionSerializer;

  @override
  String toString() => 'STORE_NAV_BAR_SELECTION: ${selection.name}';
}
