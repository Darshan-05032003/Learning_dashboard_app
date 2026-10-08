import 'package:equatable/equatable.dart';

/// Represents an authenticated user session in the domain layer.
class AuthSession extends Equatable {
  final String email;
  final String token;

  const AuthSession({required this.email, required this.token});

  @override
  List<Object?> get props => [email, token];
}
