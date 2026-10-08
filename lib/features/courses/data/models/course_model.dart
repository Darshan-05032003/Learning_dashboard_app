import '../../domain/entities/course.dart';
import 'lesson_model.dart';

/// Data transfer object for [Course].
/// Handles JSON serialization for data layer separation.
class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.instructor,
    required super.lessons,
    required super.lessonItems,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      lessons: json['lessons'] as int,
      lessonItems:
          (json['lessonItems'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'lessons': lessons,
      'lessonItems': lessonItems
          .map(
            (e) => LessonModel(
              id: e.id,
              title: e.title,
              isCompleted: e.isCompleted,
            ).toJson(),
          )
          .toList(),
    };
  }
}
