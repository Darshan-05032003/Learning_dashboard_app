import 'package:equatable/equatable.dart';
import '../../../domain/entities/course.dart';

abstract class CourseDetailsState extends Equatable {
  const CourseDetailsState();

  @override
  List<Object?> get props => [];
}

class CourseDetailsInitial extends CourseDetailsState {
  const CourseDetailsInitial();
}

class CourseDetailsLoading extends CourseDetailsState {
  const CourseDetailsLoading();
}

class CourseDetailsLoaded extends CourseDetailsState {
  final Course course;

  const CourseDetailsLoaded(this.course);

  @override
  List<Object?> get props => [course];
}

class CourseDetailsError extends CourseDetailsState {
  final String message;

  const CourseDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
