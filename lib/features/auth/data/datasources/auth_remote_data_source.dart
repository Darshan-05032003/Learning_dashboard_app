import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_session_model.dart';

/// Interface for the remote authentication data source.
abstract class AuthRemoteDataSource {
  /// Calls the login endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });
}

/// Mock implementation of [AuthRemoteDataSource] to simulate API calls.
class MockAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Demo Credentials documented as required
  static const String demoEmail = 'demo@example.com';
  static const String demoPassword = 'password123';

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(AppConstants.mockNetworkDelay);

    if (email == demoEmail && password == demoPassword) {
      return AuthSessionModel(email: email, token: 'mock_jwt_token_1234567890');
    } else {
      throw const ServerException(
        message: 'Invalid email or password',
        statusCode: 401,
      );
    }
  }
}
