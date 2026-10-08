import '../../domain/entities/lesson.dart';

/// Data transfer object for [Lesson].
class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.isCompleted,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted};
  }
}
