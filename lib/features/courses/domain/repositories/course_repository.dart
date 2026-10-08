import '../../../../core/error/result.dart';
import '../entities/course.dart';

/// Repository interface for course operations.
abstract class CourseRepository {
  /// Fetches a list of available courses.
  Future<Result<List<Course>>> getCourses();

  /// Updates a specific course (e.g. for persisting lesson completions)
  Future<Result<Course>> updateCourse(Course course);
}
