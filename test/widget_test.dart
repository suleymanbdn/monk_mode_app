import 'package:flutter_test/flutter_test.dart';
import 'package:monk_mode/app.dart';
import 'package:monk_mode/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home screen renders app title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();

    await tester.pumpWidget(App(storage: storage));
    await tester.pump();
    // [App] schedules a 1.8s delayed update check; advance past it so the test
    // can tear down without a pending timer.
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump();

    expect(find.text('MONK MODE'), findsOneWidget);
  });
}
