import 'package:crowdleague/models/storage/upload_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ///
  /// -- Non-nullable
  ///
  /// int get code;
  /// String get description;
  ///
  ///

  group('UploadFailure', () {
    test('.toString() prints code and description', () {
      final error = UploadFailure((b) => b
        ..code = 1
        ..description = 'hello');

      expect(
          error.toString(),
          'UploadFailure {\n'
          '  code=1,\n'
          '  description=hello,\n'
          '}');
    });
  });
}
