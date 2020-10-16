import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'new_conversation_page_leaguers_state.g.dart';

class NewConversationPageLeaguersState extends EnumClass {
  static Serializer<NewConversationPageLeaguersState> get serializer =>
      _$newConversationPageLeaguersStateSerializer;
  static const NewConversationPageLeaguersState waiting = _$waiting;
  static const NewConversationPageLeaguersState ready = _$ready;
  static const Map<NewConversationPageLeaguersState, int> _$indexMap = {
    waiting: 0,
    ready: 1
  };

  const NewConversationPageLeaguersState._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<NewConversationPageLeaguersState> get values => _$values;
  static NewConversationPageLeaguersState valueOf(String name) =>
      _$valueOf(name);

  Object toJson() => serializers.serializeWith(
      NewConversationPageLeaguersState.serializer, this);
}
