import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/core/error/failures.dart';
import 'package:learning_dashboard/core/error/result.dart';

void main() {
  group('Result', () {
    test('Success should hold data and fold correctly', () {
      const result = Success<int>(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals(42));
      expect(result.failureOrNull, isNull);

      final folded = result.fold(
        onFailure: (failure) => 'failed',
        onSuccess: (data) => 'success: $data',
      );

      expect(folded, equals('success: 42'));
    });

    test('FailureResult should hold failure and fold correctly', () {
      const failure = ServerFailure(message: 'Server error', code: 500);
      const result = FailureResult<int>(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, equals(failure));

      final folded = result.fold(
        onFailure: (f) => 'failed: ${f.message}',
        onSuccess: (data) => 'success: $data',
      );

      expect(folded, equals('failed: Server error'));
    });
  });
}
