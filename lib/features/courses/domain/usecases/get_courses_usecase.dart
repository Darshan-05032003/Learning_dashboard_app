import '../../../../core/error/result.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Use case for retrieving the list of available courses.
class GetCoursesUseCase {
  final CourseRepository repository;

  GetCoursesUseCase(this.repository);

  /// Executes the operation to get courses.
  Future<Result<List<Course>>> execute() {
    return repository.getCourses();
  }
}
