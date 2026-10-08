import 'package:flutter/material.dart';
import '../constants/route_constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../di/service_locator.dart';

/// Centralized application router handling navigation and argument passing.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.login:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const LoginPage(),
          ),
          settings: settings,
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute<void>(
          builder: (_) => const FoundationPlaceholderPage(
            title: 'Course Dashboard (Foundation)',
            message: 'Course Dashboard feature foundation is established.',
          ),
          settings: settings,
        );
      case AppRoutes.courseDetails:
        return MaterialPageRoute<void>(
          builder: (_) => const FoundationPlaceholderPage(
            title: 'Course Details (Foundation)',
            message: 'Course Details feature foundation is established.',
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Route Not Found')),
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}

/// A minimal foundation placeholder widget used prior to feature implementation.
class FoundationPlaceholderPage extends StatelessWidget {
  final String title;
  final String message;

  const FoundationPlaceholderPage({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Phase 1: $title',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
