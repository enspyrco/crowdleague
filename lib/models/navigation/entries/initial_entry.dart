library initial_entry;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/navigation/entries/navigator_entry.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'initial_entry.g.dart';

abstract class InitialEntry
    implements NavigatorEntry, Built<InitialEntry, InitialEntryBuilder> {
  InitialEntry._();

  factory InitialEntry() = _$InitialEntry._;

  Object toJson() => serializers.serializeWith(InitialEntry.serializer, this);

  static InitialEntry fromJson(String jsonString) => serializers
      .deserializeWith(InitialEntry.serializer, json.decode(jsonString));

  static Serializer<InitialEntry> get serializer => _$initialEntrySerializer;
}
