import 'package:equatable/equatable.dart';
import '../../../domain/entities/course.dart';

abstract class CourseDetailsEvent extends Equatable {
  const CourseDetailsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCourseDetails extends CourseDetailsEvent {
  final Course course;

  const InitializeCourseDetails(this.course);

  @override
  List<Object?> get props => [course];
}

class CompleteLesson extends CourseDetailsEvent {
  final int lessonId;

  const CompleteLesson(this.lessonId);

  @override
  List<Object?> get props => [lessonId];
}
