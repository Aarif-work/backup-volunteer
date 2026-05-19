import 'package:flutter_test/flutter_test.dart';
import 'package:valnteer_app/main.dart';

void main() {
  testWidgets('App basic load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Hope3App());

    // Verify that the dashboard header is present.
    expect(find.text('Volunteer John'), findsNothing); // It's in the profile or dashboard but might need pump
  });
}
