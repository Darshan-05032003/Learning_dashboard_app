import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // Validate inputs before triggering business logic
    final emailError = Validators.validateEmail(event.email);
    final passwordError = Validators.validatePassword(event.password);

    if (emailError != null || passwordError != null) {
      final errorMessage = emailError ?? passwordError ?? 'Invalid input';
      emit(AuthFailure(errorMessage));
      return;
    }

    emit(AuthLoading());

    final result = await loginUseCase.execute(
      email: event.email,
      password: event.password,
    );

    result.fold(
      onFailure: (failure) => emit(AuthFailure(failure.message)),
      onSuccess: (session) => emit(AuthSuccess(session)),
    );
  }
}
