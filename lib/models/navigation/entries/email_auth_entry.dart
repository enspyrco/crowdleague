library email_auth_entry;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/navigation/entries/navigator_entry.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'email_auth_entry.g.dart';

abstract class EmailAuthEntry
    implements NavigatorEntry, Built<EmailAuthEntry, EmailAuthEntryBuilder> {
  EmailAuthEntry._();

  factory EmailAuthEntry() = _$EmailAuthEntry._;

  Object toJson() => serializers.serializeWith(EmailAuthEntry.serializer, this);

  static EmailAuthEntry fromJson(String jsonString) => serializers
      .deserializeWith(EmailAuthEntry.serializer, json.decode(jsonString));

  static Serializer<EmailAuthEntry> get serializer =>
      _$emailAuthEntrySerializer;
}
