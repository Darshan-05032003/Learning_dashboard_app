import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('returns error when email is null or empty', () {
        expect(Validators.validateEmail(null), equals('Email is required'));
        expect(Validators.validateEmail(''), equals('Email is required'));
        expect(Validators.validateEmail('   '), equals('Email is required'));
      });

      test('returns error when email format is invalid', () {
        expect(
          Validators.validateEmail('invalid-email'),
          equals('Please enter a valid email address'),
        );
        expect(
          Validators.validateEmail('user@'),
          equals('Please enter a valid email address'),
        );
        expect(
          Validators.validateEmail('@domain.com'),
          equals('Please enter a valid email address'),
        );
      });

      test('returns null when email format is valid', () {
        expect(Validators.validateEmail('student@example.com'), isNull);
        expect(Validators.validateEmail('john.doe@company.org'), isNull);
      });
    });

    group('validatePassword', () {
      test('returns error when password is null or empty', () {
        expect(
          Validators.validatePassword(null),
          equals('Password is required'),
        );
        expect(Validators.validatePassword(''), equals('Password is required'));
      });

      test('returns error when password is shorter than minLength', () {
        expect(
          Validators.validatePassword('12345'),
          equals('Password must be at least 6 characters'),
        );
      });

      test('returns null when password is valid', () {
        expect(Validators.validatePassword('password123'), isNull);
        expect(Validators.validatePassword('securePass'), isNull);
      });
    });
  });
}
