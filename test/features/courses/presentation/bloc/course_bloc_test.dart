import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/core/error/failures.dart';
import 'package:learning_dashboard/core/error/result.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_bloc.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_event.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_state.dart';
import 'package:mocktail/mocktail.dart';

import 'package:learning_dashboard/features/courses/domain/entities/lesson.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

void main() {
  late CourseBloc bloc;
  late MockGetCoursesUseCase mockGetCoursesUseCase;

  setUp(() {
    mockGetCoursesUseCase = MockGetCoursesUseCase();
    bloc = CourseBloc(getCoursesUseCase: mockGetCoursesUseCase);
  });

  const tCourse = Course(
    id: 1,
    title: 'Python',
    instructor: 'John Doe',
    lessons: 10,
    lessonItems: [
      Lesson(id: 1, title: 'Intro', isCompleted: true),
      Lesson(id: 2, title: 'Functions', isCompleted: false),
    ],
  );
  final tCoursesList = [tCourse];

  test('initial state should be CourseInitial', () {
    expect(bloc.state, equals(const CourseInitial()));
  });

  blocTest<CourseBloc, CourseState>(
    'emits [CourseLoading, CourseLoaded] when FetchCourses succeeds with non-empty list',
    build: () {
      when(
        () => mockGetCoursesUseCase.execute(),
      ).thenAnswer((_) async => Success(tCoursesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchCourses()),
    expect: () => [const CourseLoading(), CourseLoaded(tCoursesList)],
  );

  blocTest<CourseBloc, CourseState>(
    'emits [CourseLoading, CourseEmpty] when FetchCourses succeeds with empty list',
    build: () {
      when(
        () => mockGetCoursesUseCase.execute(),
      ).thenAnswer((_) async => const Success(<Course>[]));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchCourses()),
    expect: () => [const CourseLoading(), const CourseEmpty()],
  );

  blocTest<CourseBloc, CourseState>(
    'emits [CourseLoading, CourseError] when FetchCourses fails',
    build: () {
      when(() => mockGetCoursesUseCase.execute()).thenAnswer(
        (_) async =>
            const FailureResult(ServerFailure(message: 'Server failure')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchCourses()),
    expect: () => [
      const CourseLoading(),
      const CourseError('Unable to load courses. Server error occurred.'),
    ],
  );
}
