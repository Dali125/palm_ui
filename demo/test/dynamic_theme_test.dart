import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_demo/main.dart';
import 'package:palm_ui/palm_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('dynamic theme can be selected beside light and dark', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PalmUIDemoApp());
    await tester.pumpAndSettle();

    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app().theme!.brightness, Brightness.light);
    expect(find.text('Light'), findsOneWidget);

    await tester.tap(find.byTooltip('Dynamic theme unavailable'));
    await tester.pump();
    expect(find.text('Dynamic'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(PalmUISwitch));
    await tester.pump();
    expect(app().theme!.brightness, Brightness.dark);
    expect(find.text('Dark'), findsOneWidget);
  });
}
