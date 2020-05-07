import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/serializers.dart';

part 'problem_type.g.dart';

class ProblemType extends EnumClass {
  static Serializer<ProblemType> get serializer => _$problemTypeSerializer;

  static const ProblemType googleSignIn = _$googleSignIn;
  static const ProblemType appleSignIn = _$appleSignIn;
  static const ProblemType emailSignIn = _$emailSignIn;
  static const ProblemType emailSignUp = _$emailSignUp;
  static const ProblemType signOut = _$signOut;
  static const ProblemType retrieveLeaguers = _$retrieveLeaguers;
  static const ProblemType createConversation = _$createConversation;

  const ProblemType._(String name) : super(name);

  static BuiltSet<ProblemType> get values => _$values;
  static ProblemType valueOf(String name) => _$valueOf(name);

  Object toJson() => serializers.serializeWith(ProblemType.serializer, this);
}
