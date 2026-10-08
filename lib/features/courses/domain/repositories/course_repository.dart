import '../../../../core/error/result.dart';
import '../entities/course.dart';

/// Repository interface for course operations.
abstract class CourseRepository {
  /// Fetches a list of available courses.
  Future<Result<List<Course>>> getCourses();
}
