import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_morphism/main.dart';
import 'package:glass_morphism/glass_modal_page.dart';

void main() {
  testWidgets('Modal grows upward, settles, reverses, and returns home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.bySemanticsLabel('Open glass modal'));
    await tester.pumpAndSettle();
    final surface = find.byKey(const Key('glass-modal-surface'));
    final collapsed = tester.getRect(surface);
    await tester.tap(surface);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getRect(surface).width, greaterThan(collapsed.width));
    await tester.pump(const Duration(milliseconds: 200));
    final middle = tester.getRect(surface);
    expect(middle.height, greaterThan(collapsed.height));
    expect(middle.bottom, lessThan(collapsed.bottom));
    await tester.pump(const Duration(milliseconds: 84));
    expect(tester.getRect(surface).bottom, greaterThan(collapsed.bottom));
    await tester.pumpAndSettle();
    final expanded = tester.getRect(surface);
    expect(expanded.height, closeTo(260, .01));
    expect(expanded.bottom, closeTo(collapsed.bottom, .01));
    await tester.tap(surface);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 170));
    expect(tester.getRect(surface).height, lessThan(expanded.height));
    expect(tester.getRect(surface).bottom, greaterThan(expanded.bottom));
    final beforeReversal = tester.getRect(surface).bottom;
    await tester.tap(surface);
    await tester.pump();
    expect(tester.getRect(surface).bottom, closeTo(beforeReversal, .01));
    await tester.pumpAndSettle();
    expect(tester.getRect(surface).height, closeTo(expanded.height, .01));
    await tester.drag(surface, const Offset(0, 80));
    await tester.pumpAndSettle();
    expect(tester.getRect(surface).height, closeTo(collapsed.height, .01));
    expect(tester.getRect(surface).bottom, closeTo(collapsed.bottom, .01));
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Back to calm'));
    await tester.pumpAndSettle();
    expect(find.text('Evening unwind'), findsOneWidget);
  });

  testWidgets('Small screen and reduced motion remain usable', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(320, 568), disableAnimations: true),
          child: GlassModalPage(),
        ),
      ),
    );
    final surface = find.byKey(const Key('glass-modal-surface'));
    await tester.tap(surface);
    await tester.pump();
    expect(tester.getSize(surface).height, closeTo(221, .01));
    expect(tester.takeException(), isNull);
  });
}
