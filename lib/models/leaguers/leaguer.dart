library leaguer;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:meta/meta.dart';

part 'leaguer.g.dart';

abstract class Leaguer implements Built<Leaguer, LeaguerBuilder> {
  String get uid;
  @nullable
  String get displayName;
  @nullable
  String get photoURL;

  Leaguer._();

  factory Leaguer({@required String uid, String displayName, String photoURL}) =
      _$Leaguer._;

  factory Leaguer.by([void Function(LeaguerBuilder) updates]) = _$Leaguer;

  Object toJson() => serializers.serializeWith(Leaguer.serializer, this);

  static Leaguer fromJson(String jsonString) =>
      serializers.deserializeWith(Leaguer.serializer, json.decode(jsonString));

  static Serializer<Leaguer> get serializer => _$leaguerSerializer;
}
