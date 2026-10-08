import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_dashboard/features/courses/domain/usecases/complete_lesson_usecase.dart';
import 'course_details_event.dart';
import 'course_details_state.dart';

class CourseDetailsBloc extends Bloc<CourseDetailsEvent, CourseDetailsState> {
  final CompleteLessonUseCase completeLessonUseCase;

  CourseDetailsBloc({required this.completeLessonUseCase})
    : super(const CourseDetailsInitial()) {
    on<InitializeCourseDetails>(_onInitializeCourseDetails);
    on<CompleteLesson>(_onCompleteLesson);
  }

  void _onInitializeCourseDetails(
    InitializeCourseDetails event,
    Emitter<CourseDetailsState> emit,
  ) {
    emit(CourseDetailsLoaded(event.course));
  }

  Future<void> _onCompleteLesson(
    CompleteLesson event,
    Emitter<CourseDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is CourseDetailsLoaded) {
      final currentCourse = currentState.course;

      final result = await completeLessonUseCase.execute(
        currentCourse,
        event.lessonId,
      );

      if (result.isSuccess) {
        emit(CourseDetailsLoaded(result.dataOrNull!));
      } else if (result.isFailure) {
        emit(CourseDetailsError(result.failureOrNull!.message));
        // We could revert back to the loaded state after showing the error
        emit(CourseDetailsLoaded(currentCourse));
      }
    }
  }
}
