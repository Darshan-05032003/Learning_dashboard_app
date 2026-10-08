import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_dashboard/features/courses/domain/entities/course.dart';
import 'package:learning_dashboard/features/courses/domain/entities/lesson.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_bloc.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_event.dart';
import 'package:learning_dashboard/features/courses/presentation/bloc/course_details/course_details_state.dart';

class CourseDetailsPage extends StatefulWidget {
  final Course course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CourseDetailsBloc>().add(
      InitializeCourseDetails(widget.course),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseDetailsBloc, CourseDetailsState>(
      listener: (context, state) {
        if (state is CourseDetailsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is CourseDetailsLoaded) {
          final course = state.course;

          return Scaffold(
            appBar: AppBar(
              title: Text(course.title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Return the updated course to the dashboard so it can update its state
                  Navigator.of(context).pop(course);
                },
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressSection(context, course),
                    const SizedBox(height: 24),
                    Text(
                      '${course.lessonItems.length} Lessons',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: course.lessonItems.length,
                        itemBuilder: (context, index) {
                          final lesson = course.lessonItems[index];
                          return LessonTile(
                            lesson: lesson,
                            onComplete: () {
                              context.read<CourseDetailsBloc>().add(
                                CompleteLesson(lesson.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show a simple loading or initial state
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildProgressSection(BuildContext context, Course course) {
    final progressFraction = (course.progress.clamp(0, 100)) / 100.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Course Progress',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${course.progress}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progressFraction,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonTile extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onComplete;

  const LessonTile({super.key, required this.lesson, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(
          lesson.isCompleted
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: lesson.isCompleted ? Colors.green : Colors.grey,
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            decoration: lesson.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(lesson.isCompleted ? 'Completed' : 'Pending'),
        trailing: lesson.isCompleted
            ? null
            : IconButton(
                icon: const Icon(Icons.check),
                onPressed: onComplete,
                tooltip: 'Mark as completed',
              ),
      ),
    );
  }
}
