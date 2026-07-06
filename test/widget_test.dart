import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:one_tap/main.dart';
import 'package:one_tap/firebase_options.dart';

void main() {
  testWidgets('shows splash screen on startup', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await tester.pumpWidget(const ProviderScope(child: SkillSwapApp()));

    expect(find.byIcon(Icons.school), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Organize Your Study'), findsOneWidget);
  });
}
