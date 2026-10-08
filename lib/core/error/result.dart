import 'failures.dart';

/// A type-safe representation of the outcome of an operation.
/// Encapsulates either a [Success] with value [T] or a [FailureResult] with [Failure].
sealed class Result<T> {
  const Result();

  /// Returns true if the result represents a successful operation.
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result represents a failure.
  bool get isFailure => this is FailureResult<T>;

  /// Returns data if success, or null if failure.
  T? get dataOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Returns failure if failed, or null if successful.
  Failure? get failureOrNull {
    if (this is FailureResult<T>) {
      return (this as FailureResult<T>).failure;
    }
    return null;
  }

  /// Transforms the result by applying [onSuccess] or [onFailure].
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as FailureResult<T>).failure);
    }
  }
}

/// Represents a successful result carrying [data].
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success<T> && other.data == data);

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success(data: $data)';
}

/// Represents a failed result carrying a [failure].
final class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FailureResult<T> && other.failure == failure);

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'FailureResult(failure: $failure)';
}
