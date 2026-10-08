import 'package:flutter_test/flutter_test.dart';
import 'package:learning_dashboard/core/di/service_locator.dart';
import 'package:learning_dashboard/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await initServiceLocator();
  });

  testWidgets('LearningDashboardApp smoke test displays initial placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LearningDashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Learning Dashboard'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
