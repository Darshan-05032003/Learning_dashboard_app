import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/features/courses/data/models/course_model.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';

void main() {
  const tCourseModel = CourseModel(
    id: 1,
    title: 'Python Programming',
    instructor: 'John Smith',
    progress: 65,
    lessons: 20,
  );

  test('should be a subclass of Course entity', () {
    expect(tCourseModel, isA<Course>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON is valid', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'title': 'Python Programming',
        'instructor': 'John Smith',
        'progress': 65,
        'lessons': 20,
      };

      final result = CourseModel.fromJson(jsonMap);

      expect(result, equals(tCourseModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tCourseModel.toJson();

      final expectedMap = {
        'id': 1,
        'title': 'Python Programming',
        'instructor': 'John Smith',
        'progress': 65,
        'lessons': 20,
      };

      expect(result, equals(expectedMap));
    });
  });
}
