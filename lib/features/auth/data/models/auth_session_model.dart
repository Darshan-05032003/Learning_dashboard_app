import '../../domain/entities/auth_session.dart';

/// Data transfer object for [AuthSession].
/// Handles JSON serialization for data layer separation.
class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.email, required super.token});

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'token': token};
  }
}
