import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_dashboard/core/error/exceptions.dart';
import 'package:learning_dashboard/core/error/failures.dart';
import 'package:learning_dashboard/core/network/network_info.dart';
import 'package:learning_dashboard/features/courses/data/datasources/course_local_data_source.dart';
import 'package:learning_dashboard/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:learning_dashboard/features/courses/data/models/course_model.dart';
import 'package:learning_dashboard/features/courses/data/repositories/course_repository_impl.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

class MockCourseLocalDataSource extends Mock implements CourseLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CourseRepositoryImpl repository;
  late MockCourseRemoteDataSource mockRemoteDataSource;
  late MockCourseLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCourseRemoteDataSource();
    mockLocalDataSource = MockCourseLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CourseRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getCourses', () {
    const tCourseModel = CourseModel(
      id: 1,
      title: 'Python Programming',
      instructor: 'John Smith',
      lessons: 20,
      lessonItems: [],
    );
    final tCoursesModelList = [tCourseModel];

    test(
      'should return remote data and cache it when connected and remote succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.fetchCourses(),
        ).thenAnswer((_) async => tCoursesModelList);
        when(
          () => mockLocalDataSource.cacheCourses(any()),
        ).thenAnswer((_) async => Future.value());

        final result = await repository.getCourses();

        expect(result.isSuccess, true);
        expect(result.dataOrNull, equals(tCoursesModelList));
        verify(() => mockRemoteDataSource.fetchCourses()).called(1);
        verify(
          () => mockLocalDataSource.cacheCourses(tCoursesModelList),
        ).called(1);
      },
    );

    test(
      'should fallback to local cache when connected but remote throws NetworkException',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.fetchCourses(),
        ).thenThrow(const ServerException(message: 'Server Error'));
        when(
          () => mockLocalDataSource.getCachedCourses(),
        ).thenAnswer((_) async => tCoursesModelList);

        final result = await repository.getCourses();

        expect(result.isSuccess, true);
        expect(result.dataOrNull, equals(tCoursesModelList));
        verify(() => mockRemoteDataSource.fetchCourses()).called(1);
        verify(() => mockLocalDataSource.getCachedCourses()).called(1);
      },
    );

    test('should return cached data when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedCourses(),
      ).thenAnswer((_) async => tCoursesModelList);

      final result = await repository.getCourses();

      expect(result.isSuccess, true);
      expect(result.dataOrNull, equals(tCoursesModelList));
      verify(() => mockLocalDataSource.getCachedCourses()).called(1);
      verifyNever(() => mockRemoteDataSource.fetchCourses());
    });

    test('should return failure when offline and cache fails', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCachedCourses(),
      ).thenThrow(const CacheException(message: 'No cache'));

      final result = await repository.getCourses();

      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<ServerFailure>());
      expect(result.failureOrNull?.message, 'No internet connection');
    });
  });

  group('updateCourse', () {
    const tCourseModel = CourseModel(
      id: 1,
      title: 'Python Programming',
      instructor: 'John Smith',
      lessons: 20,
      lessonItems: [],
    );

    test('should update local cache with the new course data', () async {
      when(
        () => mockLocalDataSource.getCachedCourses(),
      ).thenAnswer((_) async => []);
      when(
        () => mockLocalDataSource.cacheCourses(any()),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.updateCourse(tCourseModel);

      expect(result.isSuccess, true);
      expect(result.dataOrNull, equals(tCourseModel));
      verify(() => mockLocalDataSource.cacheCourses([tCourseModel])).called(1);
    });
  });
}
