import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/core/constants/storage_constants.dart';
import 'package:learning_dashboard/core/error/exceptions.dart';
import 'package:learning_dashboard/core/storage/local_storage.dart';
import 'package:learning_dashboard/features/courses/data/datasources/course_local_data_source.dart';
import 'package:learning_dashboard/features/courses/data/models/course_model.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late CourseLocalDataSourceImpl dataSource;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = CourseLocalDataSourceImpl(localStorage: mockLocalStorage);
  });

  const tCourseModel = CourseModel(
    id: 1,
    title: 'Python Programming',
    instructor: 'John Doe',
    lessons: 1,
    lessonItems: [],
  );

  final tCoursesList = [tCourseModel];
  final tJsonString = json.encode(tCoursesList.map((c) => c.toJson()).toList());

  group('getCachedCourses', () {
    test('should return list of courses when cache exists', () async {
      when(
        () => mockLocalStorage.getString(StorageConstants.cachedCoursesKey),
      ).thenAnswer((_) async => tJsonString);

      final result = await dataSource.getCachedCourses();

      expect(result, equals(tCoursesList));
    });

    test('should throw CacheException when there is no cached data', () async {
      when(
        () => mockLocalStorage.getString(StorageConstants.cachedCoursesKey),
      ).thenAnswer((_) async => null);

      expect(
        () => dataSource.getCachedCourses(),
        throwsA(isA<CacheException>()),
      );
    });

    test('should throw CacheException when cached data is malformed', () async {
      when(
        () => mockLocalStorage.getString(StorageConstants.cachedCoursesKey),
      ).thenAnswer((_) async => 'Invalid JSON');

      expect(
        () => dataSource.getCachedCourses(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cacheCourses', () {
    test('should call LocalStorage to cache data', () async {
      when(
        () => mockLocalStorage.setString(
          StorageConstants.cachedCoursesKey,
          tJsonString,
        ),
      ).thenAnswer((_) async => true);

      await dataSource.cacheCourses(tCoursesList);

      verify(
        () => mockLocalStorage.setString(
          StorageConstants.cachedCoursesKey,
          tJsonString,
        ),
      ).called(1);
    });

    test('should throw CacheException when cache fails', () async {
      when(
        () => mockLocalStorage.setString(
          StorageConstants.cachedCoursesKey,
          tJsonString,
        ),
      ).thenAnswer((_) async => false);

      expect(
        () => dataSource.cacheCourses(tCoursesList),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
