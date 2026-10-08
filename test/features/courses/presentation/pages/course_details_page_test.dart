import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/domain/entities/lesson.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_bloc.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_event.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_state.dart';
import 'package:learning_dashboard/features/courses/presentation/pages/course_details_page.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseDetailsBloc
    extends MockBloc<CourseDetailsEvent, CourseDetailsState>
    implements CourseDetailsBloc {}

void main() {
  late MockCourseDetailsBloc mockBloc;

  setUp(() {
    mockBloc = MockCourseDetailsBloc();
  });

  Widget makeTestableWidget(Course course) {
    return MaterialApp(
      home: BlocProvider<CourseDetailsBloc>.value(
        value: mockBloc,
        child: CourseDetailsPage(course: course),
      ),
    );
  }

  const tCourse = Course(
    id: 1,
    title: 'Python Mastery',
    instructor: 'Jane Doe',
    lessons: 2,
    lessonItems: [
      Lesson(id: 1, title: 'Intro', isCompleted: true),
      Lesson(id: 2, title: 'Advanced', isCompleted: false),
    ],
  );

  testWidgets('displays course details and lesson list', (tester) async {
    when(() => mockBloc.state).thenReturn(const CourseDetailsLoaded(tCourse));

    await tester.pumpWidget(makeTestableWidget(tCourse));

    expect(find.text('Python Mastery'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget); // 1 out of 2 completed
    expect(find.text('Intro'), findsOneWidget);
    expect(find.text('Advanced'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
  });

  testWidgets('tapping check icon dispatches CompleteLesson event', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const CourseDetailsLoaded(tCourse));

    await tester.pumpWidget(makeTestableWidget(tCourse));

    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    verify(() => mockBloc.add(const CompleteLesson(2))).called(1);
  });
}
