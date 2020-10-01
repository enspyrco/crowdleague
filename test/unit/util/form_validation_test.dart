// Import the test package and Counter class
import 'package:crowdleague/utils/form_validation.dart';
import 'package:test/test.dart';

void main() {
  group('form validation', () {
    test('checks password is min 6 and max 30 characters', () {
      // valid password
      final password = 'test123';
      final isValid = validPassword(password);
      expect(isValid, true);

      // invalid password
      final invalidPassword = 'te12';
      final isNotValid = validPassword(invalidPassword);
      expect(isNotValid, false);
    });
  });
}
