import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/serializers.dart';

part 'email_auth_step.g.dart';

class EmailAuthStep extends EnumClass {
  static Serializer<EmailAuthStep> get serializer => _$emailAuthStepSerializer;
  static const EmailAuthStep waitingForUser = _$waitingForUser;
  static const EmailAuthStep waitingForServer = _$waitingForServer;
  static const Map<EmailAuthStep, int> _$indexMap = {
    waitingForUser: 0,
    waitingForServer: 1
  };

  const EmailAuthStep._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<EmailAuthStep> get values => _$values;
  static EmailAuthStep valueOf(String name) => _$valueOf(name);

  Object toJson() => serializers.serializeWith(EmailAuthStep.serializer, this);
}
