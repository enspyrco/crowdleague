import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'new_conversation_page_leaguers_state.g.dart';

class NewConversationPageLeaguersState extends EnumClass {
  static const NewConversationPageLeaguersState waiting = _$waiting;
  static const NewConversationPageLeaguersState ready = _$ready;

  const NewConversationPageLeaguersState._(String name) : super(name);

  static final _$indexMap =
      BuiltMap<NewConversationPageLeaguersState, int>({waiting: 0, ready: 1});
  int get index => _$indexMap[this];

  static BuiltSet<NewConversationPageLeaguersState> get values => _$values;
  static NewConversationPageLeaguersState valueOf(String name) =>
      _$valueOf(name);

  static Serializer<NewConversationPageLeaguersState> get serializer =>
      _$newConversationPageLeaguersStateSerializer;

  Object toJson() => serializers.serializeWith(
      NewConversationPageLeaguersState.serializer, this);
}
