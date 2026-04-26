import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:travans_mobile/app/app.dart';

void main() {
  testWidgets('renders app shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TravansApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Travans'), findsOneWidget);
  });
}
