import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

import '../datasources/course_local_data_source.dart';
import '../models/course_model.dart';

/// Implementation of [CourseRepository] handling data sources and error translation.
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  final CourseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<List<Course>>> getCourses() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCourses = await remoteDataSource.fetchCourses();
        await localDataSource.cacheCourses(remoteCourses);
        return Success(remoteCourses);
      } on ServerException catch (e) {
        return await _fallbackToCache(e.message);
      } catch (e) {
        return await _fallbackToCache(e.toString());
      }
    } else {
      return await _fallbackToCache('No internet connection');
    }
  }

  Future<Result<List<Course>>> _fallbackToCache(String originalError) async {
    try {
      final localCourses = await localDataSource.getCachedCourses();
      return Success(localCourses);
    } on CacheException {
      // If cache fails, return a failure representing the original issue.
      return FailureResult(ServerFailure(message: originalError));
    }
  }

  @override
  Future<Result<Course>> updateCourse(Course course) async {
    try {
      // First try to get cached courses to update the list
      List<CourseModel> localCourses;
      try {
        localCourses = await localDataSource.getCachedCourses();
      } on CacheException {
        // If cache is empty or fails, we initialize an empty list
        localCourses = [];
      }

      final index = localCourses.indexWhere((c) => c.id == course.id);

      final updatedList = List<CourseModel>.from(localCourses);

      final courseModel = CourseModel(
        id: course.id,
        title: course.title,
        instructor: course.instructor,
        lessons: course.lessons,
        lessonItems: course.lessonItems,
      );

      if (index != -1) {
        updatedList[index] = courseModel;
      } else {
        updatedList.add(courseModel);
      }

      await localDataSource.cacheCourses(updatedList);
      return Success(course);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }
}
