extension BoolParsing on String {
  bool parseBool() {
    if (this == 'true') {
      return true;
    } else if (this == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }
}
