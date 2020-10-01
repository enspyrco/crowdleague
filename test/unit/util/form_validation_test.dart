// Import the test package and Counter class
import 'package:crowdleague/utils/form_validation.dart';
import 'package:test/test.dart';

void main() {
  group('form validation', () {
    test('checks for valid email', () {
      // valid email
      final email = 'test@email.com';
      expect(validEmail(email), true);

      // invalid email
      final invalidEmail = 'test@@12.com';
      expect(validEmail(invalidEmail), false);

      // invalid email 2
      final invalidEmail2 = 'te@12"".email';
      expect(validEmail(invalidEmail2), false);
    });
    test('checks password is min 6 and max 30 characters', () {
      // valid password
      final password = 'test123';
      expect(validPassword(password), true);

      // invalid password
      final invalidPassword = 'te12';
      expect(validPassword(invalidPassword), false);
    });
    test('checks repeatPassword matches password', () {
      // valid repeatPassword
      final password1 = 'test123';
      final repeatPassword1 = 'test123';
      expect(validRepeatPassword(password1, repeatPassword1), true);

      // invalid repeatPassword
      final password2 = 'te12';
      final repeatPassword2 = 'fjdsbkf';
      expect(validRepeatPassword(password2, repeatPassword2), false);
    });
  });
}
