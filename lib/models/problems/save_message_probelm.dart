library save_message_probelm;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/utils/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:crowdleague/models/problems/problem_base.dart';
import 'package:built_value/serializer.dart';

part 'save_message_probelm.g.dart';

abstract class SaveMessageProbelm implements ProblemBase, Built<SaveMessageProbelm, SaveMessageProbelmBuilder> {

  SaveMessageProbelm._();

  factory SaveMessageProbelm.by([void Function(SaveMessageProbelmBuilder) updates]) = _$SaveMessageProbelm;

  Object toJson() =>
    serializers.serializeWith(SaveMessageProbelm.serializer, this);


  static SaveMessageProbelm fromJson(String jsonString) =>
    serializers.deserializeWith(SaveMessageProbelm.serializer, json.decode(jsonString));

  static Serializer<SaveMessageProbelm> get serializer => _$saveMessageProbelmSerializer;
}