library disregard_profile_pics;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:built_value/serializer.dart';

part 'disregard_profile_pics.g.dart';

abstract class DisregardProfilePics implements Problem, Built<DisregardProfilePics, DisregardProfilePicsBuilder> {

  DisregardProfilePics._();

  factory DisregardProfilePics.by([void Function(DisregardProfilePicsBuilder) updates]) = _$DisregardProfilePics;

  Object toJson() =>
    serializers.serializeWith(DisregardProfilePics.serializer, this);


  static DisregardProfilePics fromJson(String jsonString) =>
    serializers.deserializeWith(DisregardProfilePics.serializer, json.decode(jsonString));

  static Serializer<DisregardProfilePics> get serializer => _$disregardProfilePicsSerializer;
}