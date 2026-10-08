import 'package:equatable/equatable.dart';
import '../../domain/entities/course.dart';

/// Base state class for the Course feature.
abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any actions occur.
class CourseInitial extends CourseState {
  const CourseInitial();
}

/// Loading state while fetching courses.
class CourseLoading extends CourseState {
  const CourseLoading();
}

/// Success state with a non-empty list of courses.
class CourseLoaded extends CourseState {
  final List<Course> courses;

  const CourseLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

/// Success state but the course list is empty.
class CourseEmpty extends CourseState {
  const CourseEmpty();
}

/// Error state if the course fetch fails.
class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object?> get props => [message];
}
