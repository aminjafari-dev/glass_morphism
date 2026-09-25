import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_morphism/main.dart';
import 'package:glass_morphism/liquid_glass.dart';

void main() {
  testWidgets('Liquid dashboard reuses working controls and returns home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Explore liquid glass'));
    await tester.pumpAndSettle();
    expect(find.byType(LiquidGlass), findsWidgets);
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(find.text('Find your flow'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Connection'), 120);
    await tester.tap(find.text('Connection'));
    await tester.pumpAndSettle();
    expect(find.text('Disconnected'), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(Slider), 120);
    await tester.drag(find.byType(Slider), const Offset(-60, 0));
    await tester.pumpAndSettle();
    expect(find.text('68%'), findsNothing);
    await tester.scrollUntilVisible(find.bySemanticsLabel('Play preview'), 120);
    await tester.tap(find.bySemanticsLabel('Play preview'));
    await tester.pumpAndSettle();
    expect(find.text('Soundscape · Preview playing'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Back to original'), -250);
    await tester.tap(find.text('Back to original'));
    await tester.pumpAndSettle();
    expect(find.text('Evening unwind'), findsOneWidget);
    expect(find.byType(LiquidGlass), findsNothing);
  });
}
