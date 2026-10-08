import 'package:equatable/equatable.dart';
import 'lesson.dart';

/// Represents a course in the domain layer.
///
/// Design decisions:
/// - [id] is an int as per the mock data.
/// - [progress] is a computed property derived from [lessonItems]. This ensures
///   it is always perfectly consistent with the lesson completion state.
/// - [lessons] is an int representing the total number of lessons (kept for dashboard fast access, though it should match lessonItems.length).
class Course extends Equatable {
  final int id;
  final String title;
  final String instructor;
  final int lessons;
  final List<Lesson> lessonItems;

  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.lessons,
    required this.lessonItems,
  });

  /// Computed progress percentage based on completed lessons.
  /// If there are no lessons, progress is 0.
  int get progress {
    if (lessonItems.isEmpty) return 0;
    final completed = lessonItems.where((l) => l.isCompleted).length;
    return ((completed / lessonItems.length) * 100).round();
  }

  /// Creates a copy of this course with the given fields replaced.
  Course copyWith({
    int? id,
    String? title,
    String? instructor,
    int? lessons,
    List<Lesson>? lessonItems,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      lessons: lessons ?? this.lessons,
      lessonItems: lessonItems ?? this.lessonItems,
    );
  }

  @override
  List<Object?> get props => [id, title, instructor, lessons, lessonItems];
}
