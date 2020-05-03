library leaguer;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'leaguer.g.dart';

abstract class Leaguer implements Built<Leaguer, LeaguerBuilder> {
  String get id;
  String get name;
  String get photoUrl;

  Leaguer._();

  factory Leaguer([void Function(LeaguerBuilder) updates]) = _$Leaguer;

  Object toJson() => serializers.serializeWith(Leaguer.serializer, this);

  static Leaguer fromJson(String jsonString) =>
      serializers.deserializeWith(Leaguer.serializer, json.decode(jsonString));

  static Serializer<Leaguer> get serializer => _$leaguerSerializer;
}
