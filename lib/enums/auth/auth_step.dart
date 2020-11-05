import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'auth_step.g.dart';

class AuthStep extends EnumClass {
  static const AuthStep waitingForInput = _$waitingForInput;
  static const AuthStep signingInWithEmail = _$signingInWithEmail;
  static const AuthStep signingUpWithEmail = _$signingUpWithEmail;
  static const AuthStep signingInWithGoogle = _$signingInWithGoogle;
  static const AuthStep signingInWithApple = _$signingInWithApple;
  static const AuthStep signingInWithFirebase = _$signingInWithFirebase;

  const AuthStep._(String name) : super(name);

  static final _$indexMap = BuiltMap<AuthStep, int>({
    waitingForInput: 0,
    signingInWithEmail: 1,
    signingUpWithEmail: 2,
    signingInWithGoogle: 3,
    signingInWithApple: 4,
    signingInWithFirebase: 5,
  });
  int get index => _$indexMap[this];

  static BuiltSet<AuthStep> get values => _$values;
  static AuthStep valueOf(String name) => _$valueOf(name);

  static Serializer<AuthStep> get serializer => _$authStepSerializer;

  Object toJson() => serializers.serializeWith(AuthStep.serializer, this);
}
