import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/core/error/failures.dart';
import 'package:learning_dashboard/core/error/result.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/domain/entities/lesson.dart';
import 'package:learning_dashboard/features/courses/domain/repositories/course_repository.dart';
import 'package:learning_dashboard/features/courses/domain/usecases/complete_lesson_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

class FakeCourse extends Fake implements Course {}

void main() {
  late CompleteLessonUseCase usecase;
  late MockCourseRepository mockCourseRepository;

  setUpAll(() {
    registerFallbackValue(FakeCourse());
  });

  setUp(() {
    mockCourseRepository = MockCourseRepository();
    usecase = CompleteLessonUseCase(mockCourseRepository);
  });

  const tLesson1 = Lesson(id: 1, title: 'L1', isCompleted: false);
  const tLesson2 = Lesson(id: 2, title: 'L2', isCompleted: false);

  const tCourse = Course(
    id: 1,
    title: 'C1',
    instructor: 'I1',
    lessons: 2,
    lessonItems: [tLesson1, tLesson2],
  );

  test(
    'should return updated course with lesson marked as completed and progress updated',
    () async {
      when(() => mockCourseRepository.updateCourse(any())).thenAnswer(
        (inv) async => Success(inv.positionalArguments[0] as Course),
      );

      final result = await usecase.execute(tCourse, 1);
      expect(result.isSuccess, true);

      final updatedCourse = result.dataOrNull!;
      expect(updatedCourse.lessonItems[0].isCompleted, true);
      expect(updatedCourse.progress, 50);
    },
  );

  test('should return same course if lesson is already completed', () async {
    final courseWithCompleted = tCourse.copyWith(
      lessonItems: [
        const Lesson(id: 1, title: 'L1', isCompleted: true),
        tLesson2,
      ],
    );

    final result = await usecase.execute(courseWithCompleted, 1);
    expect(result.isSuccess, true);

    final returnedCourse = result.dataOrNull!;
    expect(returnedCourse, same(courseWithCompleted));
  });

  test('should return failure if lesson not found', () async {
    final result = await usecase.execute(tCourse, 999);
    expect(result.isFailure, true);
    expect(result.failureOrNull, isA<UnknownFailure>());
  });
}
