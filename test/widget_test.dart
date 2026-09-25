import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_morphism/main.dart';

void main() {
  testWidgets('Glass page opens, toggles both modes, and returns', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.bySemanticsLabel('Open glass toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Glass Toggle'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    await tester.tap(find.byKey(const Key('glass-mode-toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Light'), findsOneWidget);
    await tester.tap(find.byKey(const Key('glass-mode-toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Dark'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Back to calm'));
    await tester.pumpAndSettle();
    expect(find.text('Evening unwind'), findsOneWidget);
  });
  testWidgets('Scenes and focus controls respond without layout errors', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Evening unwind'), findsOneWidget);
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(find.text('Find your flow'), findsOneWidget);
    await tester.tap(find.byType(CupertinoSwitch));
    await tester.pumpAndSettle();
    expect(find.text('Open to the world'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.byType(Slider), 150);
    await tester.drag(find.byType(Slider), const Offset(-70, 0));
    await tester.pumpAndSettle();
    expect(find.text('68%'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
