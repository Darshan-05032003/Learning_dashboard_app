import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

/// Business Logic Component for managing course-related state.
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase getCoursesUseCase;

  CourseBloc({required this.getCoursesUseCase}) : super(const CourseInitial()) {
    on<FetchCourses>(_onFetchCourses);
  }

  Future<void> _onFetchCourses(
    FetchCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await getCoursesUseCase.execute();

    if (result.isSuccess) {
      final courses = result.dataOrNull!;
      if (courses.isEmpty) {
        emit(const CourseEmpty());
      } else {
        emit(CourseLoaded(courses));
      }
    } else {
      final failure = result.failureOrNull!;
      emit(CourseError(_mapFailureToMessage(failure)));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Unable to load courses. Server error occurred.';
    } else if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else {
      return 'Unable to load courses. Please try again.';
    }
  }
}
