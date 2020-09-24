import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'nav_bar_selection.g.dart';

class NavBarSelection extends EnumClass {
  static Serializer<NavBarSelection> get serializer =>
      _$navBarSelectionSerializer;
  static const NavBarSelection home = _$home;
  static const NavBarSelection business = _$business;
  static const NavBarSelection conversations = _$conversations;
  static const NavBarSelection more = _$more;

  static const Map<NavBarSelection, int> _$indexMap = {
    home: 0,
    business: 1,
    conversations: 2,
    more: 3,
  };

  const NavBarSelection._(String name) : super(name);

  int get index => _$indexMap[this];
  static BuiltSet<NavBarSelection> get values => _$values;
  static NavBarSelection valueOf(String name) => _$valueOf(name);
  static NavBarSelection valueOfIndex(int index) {
    switch (index) {
      case 0:
        return _$home;
      case 1:
        return _$business;
      case 2:
        return _$conversations;
      case 3:
        return _$more;
      default:
        throw ArgumentError(index);
    }
  }

  Object toJson() =>
      serializers.serializeWith(NavBarSelection.serializer, this);
}
