import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_dashboard/core/error/exceptions.dart';
import 'package:learning_dashboard/core/error/failures.dart';
import 'package:learning_dashboard/core/network/network_info.dart';
import 'package:learning_dashboard/core/storage/local_storage.dart';
import 'package:learning_dashboard/core/constants/storage_constants.dart';
import 'package:learning_dashboard/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:learning_dashboard/features/auth/data/models/auth_session_model.dart';
import 'package:learning_dashboard/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockLocalStorage = MockLocalStorage();

    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
      localStorage: mockLocalStorage,
    );
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tAuthSessionModel = AuthSessionModel(
      email: tEmail,
      token: 'test_token',
    );

    test(
      'should return NetworkFailure when there is no internet connection',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await repository.login(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isFailure, true);
        expect(result.failureOrNull, isA<NetworkFailure>());
      },
    );

    test(
      'should return Success and save token when login is successful',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.login(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => tAuthSessionModel);
        when(
          () => mockLocalStorage.setString(any(), any()),
        ).thenAnswer((_) async => true);

        final result = await repository.login(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isSuccess, true);
        expect(result.dataOrNull, equals(tAuthSessionModel));

        verify(
          () => mockLocalStorage.setString(
            StorageConstants.authTokenKey,
            tAuthSessionModel.token,
          ),
        ).called(1);
      },
    );

    test(
      'should return ServerFailure when data source throws ServerException',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.login(email: tEmail, password: tPassword),
        ).thenThrow(
          const ServerException(
            message: 'Invalid credentials',
            statusCode: 401,
          ),
        );

        final result = await repository.login(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isFailure, true);
        expect(result.failureOrNull, isA<ServerFailure>());
        expect(result.failureOrNull?.message, 'Invalid credentials');
      },
    );
  });
}
