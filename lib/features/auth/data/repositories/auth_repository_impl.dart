import '../../../../core/constants/storage_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/local_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementation of [AuthRepository] handling data sources and error translation.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final LocalStorage localStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localStorage,
  });

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final authSessionModel = await remoteDataSource.login(
          email: email,
          password: password,
        );

        // Minimal session persistence for this assignment.
        // In a production application, this should use secure storage
        // (e.g., flutter_secure_storage backed by Keystore/Keychain).
        await localStorage.setString(
          StorageConstants.authTokenKey,
          authSessionModel.token,
        );
        await localStorage.setString(
          StorageConstants.userEmailKey,
          authSessionModel.email,
        );

        return Success(authSessionModel);
      } on ServerException catch (e) {
        return FailureResult(
          ServerFailure(message: e.message, code: e.statusCode),
        );
      } catch (e) {
        return FailureResult(UnknownFailure(message: e.toString()));
      }
    } else {
      return const FailureResult(
        NetworkFailure(message: 'No internet connection'),
      );
    }
  }
}
