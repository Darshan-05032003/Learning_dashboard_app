import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes application dependencies.
/// Accepts [mockPrefs] for deterministic unit testing.
Future<void> initServiceLocator({SharedPreferences? mockPrefs}) async {
  // ---------------------------------------------------------------------------
  // Core & External Services
  // ---------------------------------------------------------------------------
  final sharedPreferences = mockPrefs ?? await SharedPreferences.getInstance();

  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }

  if (!sl.isRegistered<LocalStorage>()) {
    sl.registerLazySingleton<LocalStorage>(
      () => SharedPreferencesStorage(sl<SharedPreferences>()),
    );
  }

  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  }

  // ---------------------------------------------------------------------------
  // Feature Modules (Placeholders for upcoming phases)
  // ---------------------------------------------------------------------------
  _initAuthDependencies();
  _initCoursesDependencies();
}

/// Registration placeholder for Auth feature dependencies.
void _initAuthDependencies() {
  // Data Sources
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => MockAuthRemoteDataSourceImpl(),
    );
  }

  // Repositories
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
        localStorage: sl(),
      ),
    );
  }

  // Use Cases
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton(() => LoginUseCase(sl()));
  }

  // BLoC
  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
  }
}

/// Registration placeholder for Courses feature dependencies.
void _initCoursesDependencies() {
  // Will register: CoursesRemoteDataSource, CoursesLocalDataSource,
  // CoursesRepository, GetCoursesUseCase, UpdateLessonStatusUseCase, CoursesBloc
}
