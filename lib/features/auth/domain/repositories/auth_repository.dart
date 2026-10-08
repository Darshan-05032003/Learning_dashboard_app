import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';

/// Repository interface for authentication operations.
abstract class AuthRepository {
  /// Attempts to log in with the provided [email] and [password].
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  });
}
