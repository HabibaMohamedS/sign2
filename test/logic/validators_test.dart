import 'package:flutter_test/flutter_test.dart';
import 'package:sign2/utils/validators.dart';

void main() {
  group('Email Validation', () {
    test('Valid email returns true', () {
      expect(Validators.isValidEmail('test@example.com'), true);
    });

    test('Invalid email returns false', () {
      expect(Validators.isValidEmail('test@com'), false);
    });
  });

  group('Password Validation', () {
    test('Valid password returns true', () {
      expect(Validators.isValidPassword('abc12345'), true);
      expect(Validators.isValidPassword('Password1'), true);
    });

    test('Password too short returns false', () {
      expect(Validators.isValidPassword('a1b2'), false);
    });

    test('Password with no number returns false', () {
      expect(Validators.isValidPassword('abcdefgh'), false);
    });

    test('Password with no letter returns false', () {
      expect(Validators.isValidPassword('12345678'), false);
    });
  });
}