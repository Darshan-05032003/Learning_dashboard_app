import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_dashboard/core/error/failures.dart';
import 'package:learning_dashboard/core/error/result.dart';
import 'package:learning_dashboard/features/auth/domain/entities/auth_session.dart';
import 'package:learning_dashboard/features/auth/domain/usecases/login_usecase.dart';
import 'package:learning_dashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_dashboard/features/auth/presentation/bloc/auth_event.dart';
import 'package:learning_dashboard/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authBloc = AuthBloc(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    const tEmail = 'demo@example.com';
    const tPassword = 'password123';
    const tAuthSession = AuthSession(email: tEmail, token: 'token123');

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthFailure] when input validation fails (invalid email)',
      build: () => authBloc,
      act: (bloc) =>
          bloc.add(const LoginSubmitted(email: 'invalid', password: tPassword)),
      expect: () => [const AuthFailure('Please enter a valid email address')],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthSuccess] when login is successful',
      build: () {
        when(
          () => mockLoginUseCase.execute(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => const Success(tAuthSession));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const LoginSubmitted(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), const AuthSuccess(tAuthSession)],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(
          () => mockLoginUseCase.execute(email: tEmail, password: tPassword),
        ).thenAnswer(
          (_) async => const FailureResult(
            ServerFailure(message: 'Invalid credentials'),
          ),
        );
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const LoginSubmitted(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), const AuthFailure('Invalid credentials')],
    );
  });
}
