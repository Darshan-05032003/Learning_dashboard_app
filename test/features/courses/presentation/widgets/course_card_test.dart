import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/presentation/widgets/course_card.dart';

import 'package:learning_dashboard/features/courses/domain/entities/lesson.dart';

void main() {
  const tCourse = Course(
    id: 1,
    title: 'Flutter Mastery',
    instructor: 'Jane Smith',
    lessons: 42,
    lessonItems: [
      Lesson(id: 1, title: 'Intro', isCompleted: true),
      Lesson(id: 2, title: 'Basics', isCompleted: true),
      Lesson(id: 3, title: 'Advanced', isCompleted: true),
      Lesson(id: 4, title: 'Pro', isCompleted: false),
    ],
  );

  testWidgets('displays correct course information', (tester) async {
    bool onContinuePressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CourseCard(
            course: tCourse,
            onContinue: () {
              onContinuePressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Flutter Mastery'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('42 lessons'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    expect(onContinuePressed, true);
  });
}
