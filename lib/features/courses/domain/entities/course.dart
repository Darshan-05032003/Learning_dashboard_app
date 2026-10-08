import 'package:equatable/equatable.dart';

/// Represents a course in the domain layer.
/// 
/// Design decisions:
/// - [id] is an int as per the mock data ("id": 1). If a real API uses UUIDs, this would change to String.
/// - [progress] is an int representing a percentage (0-100) as per the mock data.
/// - [lessons] is an int representing the total number of lessons.
class Course extends Equatable {
  final int id;
  final String title;
  final String instructor;
  final int progress;
  final int lessons;

  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.lessons,
  });

  @override
  List<Object?> get props => [id, title, instructor, progress, lessons];
}
