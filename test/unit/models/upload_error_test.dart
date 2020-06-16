import 'package:crowdleague/models/storage/upload_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ///
  /// -- Non-nullable
  ///
  /// int get code;
  /// String get description;
  ///
  ///

  group('UploadError', () {
    test('.toString() prints code and description', () {
      final error = UploadError((b) => b
        ..code = 1
        ..description = 'hello');

      expect(
          error.toString(),
          'UploadError {\n'
          '  code=1,\n'
          '  description=hello,\n'
          '}');
    });
  });
}
