import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_dashboard/core/error/result.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/domain/repositories/course_repository.dart';
import 'package:learning_dashboard/features/courses/domain/usecases/get_courses_usecase.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late GetCoursesUseCase usecase;
  late MockCourseRepository mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepository();
    usecase = GetCoursesUseCase(mockCourseRepository);
  });

  final tCourses = [
    const Course(
      id: 1,
      title: 'Python Programming',
      instructor: 'John Smith',
      progress: 65,
      lessons: 20,
    ),
  ];

  test('should get courses from the repository', () async {
    when(
      () => mockCourseRepository.getCourses(),
    ).thenAnswer((_) async => Success(tCourses));

    final result = await usecase.execute();

    expect(result.isSuccess, true);
    expect(result.dataOrNull, equals(tCourses));
    verify(() => mockCourseRepository.getCourses()).called(1);
    verifyNoMoreInteractions(mockCourseRepository);
  });
}
