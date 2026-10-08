import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Use case for authenticating a user.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Executes the login operation.
  Future<Result<AuthSession>> execute({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
