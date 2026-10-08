import 'package:equatable/equatable.dart';

/// Base event class for the Course feature.
abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers fetching of the course list.
class FetchCourses extends CourseEvent {
  const FetchCourses();
}
