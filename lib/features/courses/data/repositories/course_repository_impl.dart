import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

/// Implementation of [CourseRepository] handling data sources and error translation.
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<List<Course>>> getCourses() async {
    // Note: We are currently fetching mock data from local JSON.
    // We intentionally bypass the `networkInfo.isConnected` check here because
    // the local asset can be loaded without an active internet connection.
    // In a real REST API implementation, we would check network status here
    // and potentially fallback to a local cache data source.
    try {
      final courses = await remoteDataSource.fetchCourses();
      return Success(courses);
    } on ServerException catch (e) {
      return FailureResult(
        ServerFailure(message: e.message, code: e.statusCode),
      );
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }
}
