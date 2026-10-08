import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/courses/data/datasources/course_remote_data_source.dart';
import '../../features/courses/data/repositories/course_repository_impl.dart';
import '../../features/courses/domain/repositories/course_repository.dart';
import '../../features/courses/domain/usecases/complete_lesson_usecase.dart';
import '../../features/courses/domain/usecases/get_courses_usecase.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/courses/presentation/bloc/course_details/course_details_bloc.dart';

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
  // Data Sources
  if (!sl.isRegistered<CourseRemoteDataSource>()) {
    sl.registerLazySingleton<CourseRemoteDataSource>(
      () => MockCourseRemoteDataSourceImpl(),
    );
  }

  // Repositories
  if (!sl.isRegistered<CourseRepository>()) {
    sl.registerLazySingleton<CourseRepository>(
      () => CourseRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
  }

  // Use Cases
  if (!sl.isRegistered<GetCoursesUseCase>()) {
    sl.registerLazySingleton(() => GetCoursesUseCase(sl()));
  }
  if (!sl.isRegistered<CompleteLessonUseCase>()) {
    sl.registerLazySingleton(() => CompleteLessonUseCase());
  }

  // BLoC
  if (!sl.isRegistered<CourseBloc>()) {
    sl.registerFactory(() => CourseBloc(getCoursesUseCase: sl()));
  }
  if (!sl.isRegistered<CourseDetailsBloc>()) {
    sl.registerFactory(() => CourseDetailsBloc(completeLessonUseCase: sl()));
  }
}
