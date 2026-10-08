import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/course_model.dart';

/// Interface for the remote course data source.
abstract class CourseRemoteDataSource {
  /// Fetches a list of courses.
  /// 
  /// Throws a [ServerException] if an error occurs.
  Future<List<CourseModel>> fetchCourses();
}

/// Mock implementation simulating an API call using local JSON.
/// 
/// Note: This simulates a remote data source. A real REST API
/// implementation would replace this class and implement the same interface.
class MockCourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  @override
  Future<List<CourseModel>> fetchCourses() async {
    try {
      // Simulate network delay
      await Future.delayed(AppConstants.mockNetworkDelay);

      // Load JSON from assets
      final jsonString = await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList
          .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch courses: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
