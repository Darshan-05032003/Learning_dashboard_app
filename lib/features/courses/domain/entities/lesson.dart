import 'package:equatable/equatable.dart';

/// Represents a single lesson within a course.
class Lesson extends Equatable {
  final int id;
  final String title;
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  /// Creates a copy of this lesson with the given fields replaced.
  Lesson copyWith({int? id, String? title, bool? isCompleted}) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted];
}
