import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';

/// Reusable card widget to display course information.
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onContinue;

  const CourseCard({super.key, required this.course, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              course.instructor,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (course.progress.clamp(0, 100)) / 100.0,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 12),
                Text('${course.progress}%'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${course.lessons} ${course.lessons == 1 ? 'lesson' : 'lessons'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ElevatedButton(
                  onPressed: onContinue,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
