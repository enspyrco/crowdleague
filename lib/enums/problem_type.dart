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
  static const ProblemType databaseStoreController = _$databaseStoreController;
  static const ProblemType retrieveLeaguers = _$retrieveLeaguers;
  static const ProblemType createConversation = _$createConversation;
  static const ProblemType observeMessages = _$observeMessages;
  static const ProblemType disregardMessages = _$disregardMessages;
  static const ProblemType saveMessage = _$saveMessage;
  static const ProblemType uploadTaskFailure = _$uploadTaskFailure;
  static const ProblemType observeProfilePics = _$observeProfilePics;
  static const ProblemType disregardProfilePics = _$disregardProfilePics;
  static const ProblemType observeProfile = _$observeProfile;
  static const ProblemType disregardProfile = _$disregardProfile;
  static const ProblemType observeConversations = _$observeConversations;
  static const ProblemType disregardConversations = _$disregardConversations;
  static const ProblemType retrieveConversations = _$retrieveConversations;
  static const ProblemType updateLeaguer = _$updateLeaguer;
  static const ProblemType deleteProfilePic = _$deleteProfilePic;
  static const ProblemType observeProcessingFailures =
      _$observeProcessingFailures;
  static const ProblemType processingFailure = _$processingFailure;

  const ProblemType._(String name) : super(name);

  static BuiltSet<ProblemType> get values => _$values;
  static ProblemType valueOf(String name) => _$valueOf(name);

  Object toJson() => serializers.serializeWith(ProblemType.serializer, this);
}
