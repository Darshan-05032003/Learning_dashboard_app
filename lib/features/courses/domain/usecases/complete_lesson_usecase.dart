import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/course.dart';
import '../entities/lesson.dart';

import '../repositories/course_repository.dart';

/// Use case for marking a lesson as completed within a course.
class CompleteLessonUseCase {
  final CourseRepository repository;

  CompleteLessonUseCase(this.repository);

  /// Executes the completion logic and persists the changes.
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

      // Persist the updated course
      final saveResult = await repository.updateCourse(updatedCourse);

      if (saveResult.isSuccess) {
        return Success(updatedCourse);
      } else {
        return saveResult;
      }
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }
}
