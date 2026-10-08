import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_bloc.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_event.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_state.dart';
import 'package:learning_dashboard/features/courses/presentation/pages/dashboard_page.dart';
import 'package:learning_dashboard/features/courses/presentation/widgets/course_card.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseBloc extends MockBloc<CourseEvent, CourseState>
    implements CourseBloc {}

void main() {
  late MockCourseBloc mockCourseBloc;

  setUp(() {
    mockCourseBloc = MockCourseBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<CourseBloc>.value(
        value: mockCourseBloc,
        child: const DashboardPage(),
      ),
    );
  }

  testWidgets('shows loading indicator when state is CourseLoading', (
    tester,
  ) async {
    when(() => mockCourseBloc.state).thenReturn(const CourseLoading());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty message when state is CourseEmpty', (tester) async {
    when(() => mockCourseBloc.state).thenReturn(const CourseEmpty());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('No courses available.'), findsOneWidget);
  });

  testWidgets(
    'shows error message and retry button when state is CourseError',
    (tester) async {
      when(
        () => mockCourseBloc.state,
      ).thenReturn(const CourseError('Error occurred'));

      await tester.pumpWidget(makeTestableWidget());

      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    },
  );

  testWidgets('shows list of courses when state is CourseLoaded', (
    tester,
  ) async {
    final tCourses = [
      const Course(
        id: 1,
        title: 'Python Programming',
        instructor: 'John Doe',
        lessons: 10,
        lessonItems: [],
      ),
    ];

    when(() => mockCourseBloc.state).thenReturn(CourseLoaded(tCourses));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CourseCard), findsOneWidget);
    expect(find.text('Python Programming'), findsOneWidget);
  });
}
