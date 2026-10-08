import 'package:equatable/equatable.dart';

/// Base Failure class representing business and operational failures.
/// Failures are returned by Repositories and Use Cases to avoid
/// throwing raw exceptions into the presentation layer.
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Represents failures originating from remote API calls or mock server responses.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Represents connectivity failures (e.g. no internet connection).
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Represents failures related to local cache or persistent storage.
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Represents user input or client-side validation failures.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Represents unexpected or unhandled failures.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}
