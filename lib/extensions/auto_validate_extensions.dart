import 'package:crowdleague/enums/auto_validate.dart';
import 'package:flutter/cupertino.dart';

extension AutoValidateExt on AutoValidate {
  AutovalidateMode toAutovalidateMode() => AutovalidateMode.values[index];
}
