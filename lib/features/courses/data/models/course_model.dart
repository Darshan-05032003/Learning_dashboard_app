import '../../domain/entities/course.dart';

/// Data transfer object for [Course].
/// Handles JSON serialization for data layer separation.
class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.instructor,
    required super.progress,
    required super.lessons,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      progress: json['progress'] as int,
      lessons: json['lessons'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'progress': progress,
      'lessons': lessons,
    };
  }
}
