import 'package:flutter_test/flutter_test.dart';

import 'package:first_flutter_app/app/app.dart';

void main() {
  testWidgets('shows login after boot check', (WidgetTester tester) async {
    await tester.pumpWidget(const BlobApp());
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Sign in'), findsOneWidget);
  });
}
