library store_theme_colors;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/themes/theme_colors.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'store_theme_colors.g.dart';

abstract class StoreThemeColors extends Object
    with ReduxAction
    implements Built<StoreThemeColors, StoreThemeColorsBuilder> {
  ThemeColors get colors;

  StoreThemeColors._();

  factory StoreThemeColors({@required ThemeColors colors}) =
      _$StoreThemeColors._;

  factory StoreThemeColors.by(
      [void Function(StoreThemeColorsBuilder) updates]) = _$StoreThemeColors;

  Object toJson() =>
      serializers.serializeWith(StoreThemeColors.serializer, this);

  static StoreThemeColors fromJson(String jsonString) => serializers
      .deserializeWith(StoreThemeColors.serializer, json.decode(jsonString));

  static Serializer<StoreThemeColors> get serializer =>
      _$storeThemeColorsSerializer;

  @override
  String toString() => 'STORE_THEME_COLORS';
}
