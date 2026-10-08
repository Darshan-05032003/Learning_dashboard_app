import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/core/error/result.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/domain/entities/lesson.dart';
import 'package:learning_dashboard/features/courses/domain/usecases/complete_lesson_usecase.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_bloc.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_event.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_state.dart';
import 'package:mocktail/mocktail.dart';

class MockCompleteLessonUseCase extends Mock implements CompleteLessonUseCase {}

void main() {
  late CourseDetailsBloc bloc;
  late MockCompleteLessonUseCase mockCompleteLessonUseCase;

  setUp(() {
    mockCompleteLessonUseCase = MockCompleteLessonUseCase();
    bloc = CourseDetailsBloc(completeLessonUseCase: mockCompleteLessonUseCase);
  });

  const tLesson = Lesson(id: 1, title: 'Intro', isCompleted: false);
  const tCourse = Course(
    id: 1,
    title: 'Python',
    instructor: 'John Doe',
    lessons: 1,
    lessonItems: [tLesson],
  );

  test('initial state should be CourseDetailsInitial', () {
    expect(bloc.state, const CourseDetailsInitial());
  });

  blocTest<CourseDetailsBloc, CourseDetailsState>(
    'emits [CourseDetailsLoaded] when InitializeCourseDetails is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const InitializeCourseDetails(tCourse)),
    expect: () => [const CourseDetailsLoaded(tCourse)],
  );

  blocTest<CourseDetailsBloc, CourseDetailsState>(
    'emits [CourseDetailsLoaded(updated)] when CompleteLesson succeeds',
    build: () {
      final updatedCourse = tCourse.copyWith(
        lessonItems: [const Lesson(id: 1, title: 'Intro', isCompleted: true)],
      );
      when(
        () => mockCompleteLessonUseCase.execute(tCourse, 1),
      ).thenAnswer((_) async => Success(updatedCourse));
      return bloc;
    },
    seed: () => const CourseDetailsLoaded(tCourse),
    act: (bloc) => bloc.add(const CompleteLesson(1)),
    expect: () {
      final updatedCourse = tCourse.copyWith(
        lessonItems: [const Lesson(id: 1, title: 'Intro', isCompleted: true)],
      );
      return [CourseDetailsLoaded(updatedCourse)];
    },
  );
}
