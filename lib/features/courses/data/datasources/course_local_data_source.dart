import 'dart:convert';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/course_model.dart';

/// Local data source interface for offline caching of courses.
abstract class CourseLocalDataSource {
  /// Retrieves cached courses.
  /// Throws [CacheException] if no data is found or if parsing fails.
  Future<List<CourseModel>> getCachedCourses();

  /// Caches a list of courses.
  /// Throws [CacheException] if saving fails.
  Future<void> cacheCourses(List<CourseModel> courses);
}

/// Implementation of [CourseLocalDataSource] using [LocalStorage].
class CourseLocalDataSourceImpl implements CourseLocalDataSource {
  final LocalStorage localStorage;

  CourseLocalDataSourceImpl({required this.localStorage});

  @override
  Future<List<CourseModel>> getCachedCourses() async {
    final jsonString = await localStorage.getString(
      StorageConstants.cachedCoursesKey,
    );
    if (jsonString != null) {
      try {
        final List<dynamic> jsonMap = json.decode(jsonString);
        return jsonMap.map((course) => CourseModel.fromJson(course)).toList();
      } catch (e) {
        throw const CacheException(message: 'Malformed cache data');
      }
    } else {
      throw const CacheException(message: 'No cached courses found');
    }
  }

  @override
  Future<void> cacheCourses(List<CourseModel> courses) async {
    try {
      final List<Map<String, dynamic>> jsonList = courses
          .map((course) => course.toJson())
          .toList();
      final jsonString = json.encode(jsonList);
      final success = await localStorage.setString(
        StorageConstants.cachedCoursesKey,
        jsonString,
      );
      if (!success) {
        throw const CacheException(message: 'Failed to write courses to cache');
      }
    } catch (e) {
      throw const CacheException(message: 'Failed to cache courses');
    }
  }
}
