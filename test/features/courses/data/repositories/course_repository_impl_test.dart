import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_dashboard/core/error/exceptions.dart';
import 'package:learning_dashboard/core/error/failures.dart';
import 'package:learning_dashboard/core/network/network_info.dart';
import 'package:learning_dashboard/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:learning_dashboard/features/courses/data/models/course_model.dart';
import 'package:learning_dashboard/features/courses/data/repositories/course_repository_impl.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CourseRepositoryImpl repository;
  late MockCourseRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCourseRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CourseRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
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
      'should return remote data when the call to remote data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.fetchCourses(),
        ).thenAnswer((_) async => tCoursesModelList);

        final result = await repository.getCourses();

        expect(result.isSuccess, true);
        expect(result.dataOrNull, equals(tCoursesModelList));
        verify(() => mockRemoteDataSource.fetchCourses()).called(1);
      },
    );

    test(
      'should return ServerFailure when the call to remote data source throws ServerException',
      () async {
        when(() => mockRemoteDataSource.fetchCourses()).thenThrow(
          const ServerException(message: 'Server Error', statusCode: 500),
        );

        final result = await repository.getCourses();

        expect(result.isFailure, true);
        expect(result.failureOrNull, isA<ServerFailure>());
      },
    );

    test('should return UnknownFailure on other exceptions', () async {
      when(
        () => mockRemoteDataSource.fetchCourses(),
      ).thenThrow(Exception('Unknown Error'));

      final result = await repository.getCourses();

      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });
}
