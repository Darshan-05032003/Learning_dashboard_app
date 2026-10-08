import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_dashboard/core/constants/route_constants.dart';
import 'package:learning_dashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_dashboard/features/auth/presentation/bloc/auth_state.dart';
import 'package:learning_dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:learning_dashboard/core/theme/app_theme.dart';

import 'package:learning_dashboard/features/auth/presentation/bloc/auth_event.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
  });
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    // Setting up the initial state for the mock bloc
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginPage(),
      ),
      routes: {
        AppRoutes.dashboard: (_) => const Scaffold(body: Text('Dashboard')),
      },
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets(
      'shows validation error when fields are empty and login is pressed',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Find the login button and tap it
        final loginButton = find.byType(ElevatedButton);
        await tester.tap(loginButton);
        await tester.pump(); // Trigger rebuild

        // Verify validation messages appear
        expect(find.text('Email is required'), findsOneWidget);
        expect(find.text('Password is required'), findsOneWidget);

        // Verify AuthBloc was NOT called because of local validation failure
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    testWidgets('shows loading indicator when state is AuthLoading', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      // Verify CircularProgressIndicator is present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify text fields are disabled
      final emailField = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      expect(emailField.enabled, false);
    });
  });
}
