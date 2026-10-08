import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/course.dart';
import '../entities/lesson.dart';

/// Use case for marking a lesson as completed within a course.
class CompleteLessonUseCase {
  /// Executes the completion logic.
  /// In this phase, it operates purely on the provided domain objects and
  /// returns a newly updated [Course] instance reflecting the changes.
  ///
  /// In a future phase, this use case would interact with a Repository
  /// to persist the changes to a local database or remote API.
  Future<Result<Course>> execute(Course course, int lessonId) async {
    try {
      final lessonIndex = course.lessonItems.indexWhere(
        (l) => l.id == lessonId,
      );

      if (lessonIndex == -1) {
        return const FailureResult(UnknownFailure(message: 'Lesson not found'));
      }

      final existingLesson = course.lessonItems[lessonIndex];

      if (existingLesson.isCompleted) {
        // Already completed, just return the course as is
        return Success(course);
      }

      // Create updated lesson
      final updatedLesson = existingLesson.copyWith(isCompleted: true);

      // Create new list of lessons
      final newLessonItems = List<Lesson>.from(course.lessonItems);
      newLessonItems[lessonIndex] = updatedLesson;

      // Create new course with updated lessons
      final updatedCourse = course.copyWith(lessonItems: newLessonItems);

      return Success(updatedCourse);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }
}
