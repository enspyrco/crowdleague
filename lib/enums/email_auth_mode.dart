import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'email_auth_mode.g.dart';

class EmailAuthMode extends EnumClass {
  static Serializer<EmailAuthMode> get serializer => _$emailAuthModeSerializer;

  static const EmailAuthMode signIn = _$signIn;
  static const EmailAuthMode signUp = _$signUp;
  static const Map<EmailAuthMode, int> _$indexMap = {signIn: 0, signUp: 1};

  const EmailAuthMode._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<EmailAuthMode> get values => _$values;
  static EmailAuthMode valueOf(String name) => _$valueOf(name);

  Object toJson() => serializers.serializeWith(EmailAuthMode.serializer, this);
}
