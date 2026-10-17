import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palm_ui/palm_ui.dart';

Widget _frame(Widget child) {
  final theme = PalmUIThemeData.light();
  return PalmUITheme(
    data: theme,
    child: MaterialApp(
      theme: theme.toThemeData(),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('semantics', () {
    testWidgets('checkbox reports checked state, label and enabled', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var value = false;
      await tester.pumpWidget(
        _frame(
          StatefulBuilder(
            builder: (context, setState) => PalmUICheckbox(
              value: value,
              label: 'Accept terms',
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(PalmUICheckbox)),
        containsSemantics(
          label: 'Accept terms',
          hasCheckedState: true,
          isChecked: false,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );

      await tester.tap(find.byType(PalmUICheckbox));
      await tester.pump();
      expect(value, isTrue);
      expect(
        tester.getSemantics(find.byType(PalmUICheckbox)),
        containsSemantics(label: 'Accept terms', isChecked: true),
      );
      handle.dispose();
    });

    testWidgets('checkbox without onChanged is disabled', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          const PalmUICheckbox(value: true, onChanged: null, label: 'Locked'),
        ),
      );
      expect(
        tester.getSemantics(find.byType(PalmUICheckbox)),
        containsSemantics(
          label: 'Locked',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('radios report checked state in an exclusive group', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          PalmUIRadioGroup<String>(
            value: 'momo',
            onChanged: (_) {},
            children: const [
              PalmUIRadio(value: 'momo', label: 'Mobile money'),
              PalmUIRadio(value: 'card', label: 'Card'),
            ],
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(PalmUIRadio<String>).first),
        containsSemantics(
          label: 'Mobile money',
          hasCheckedState: true,
          isChecked: true,
          isInMutuallyExclusiveGroup: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.byType(PalmUIRadio<String>).last),
        containsSemantics(
          label: 'Card',
          hasCheckedState: true,
          isChecked: false,
          isInMutuallyExclusiveGroup: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('switch reports toggled state and label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          PalmUISwitch(
            value: true,
            semanticLabel: 'Notifications',
            onChanged: (_) {},
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(PalmUISwitch)),
        containsSemantics(
          label: 'Notifications',
          hasToggledState: true,
          isToggled: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('tabs and bottom nav items report selected buttons', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PalmUITab(label: 'Stock', selected: true, onTap: () {}),
                  PalmUITab(label: 'Sales', selected: false, onTap: () {}),
                ],
              ),
              PalmUIBottomNav(
                destinations: const [
                  PalmUINavDestination(icon: Icons.home, label: 'Home'),
                  PalmUINavDestination(icon: Icons.person, label: 'Profile'),
                ],
                selectedIndex: 1,
                onSelected: (_) {},
              ),
            ],
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(PalmUITab).first),
        containsSemantics(
          label: 'Stock',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.byType(PalmUITab).last),
        containsSemantics(
          label: 'Sales',
          isButton: true,
          hasSelectedState: true,
          isSelected: false,
        ),
      );
      expect(
        tester.getSemantics(find.byType(PalmUIBottomNavItem).last),
        containsSemantics(
          label: 'Profile',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('button is a labelled, enabled button', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(PalmUIButton(onPressed: () {}, child: const Text('Pay now'))),
      );
      expect(
        tester.getSemantics(find.byType(PalmUIButton)),
        containsSemantics(
          label: 'Pay now',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });
  });

  group('disabled button', () {
    testWidgets('has no tap handler, no ripple and reads as disabled', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpWidget(
        _frame(
          PalmUIButton(
            enabled: false,
            onPressed: () => taps++,
            child: const Text('Submit'),
          ),
        ),
      );

      final ink = tester.widget<InkWell>(
        find.descendant(
          of: find.byType(PalmUIButton),
          matching: find.byType(InkWell),
        ),
      );
      expect(ink.onTap, isNull);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(PalmUIButton)),
      );
      await tester.pump(const Duration(milliseconds: 200));
      final inkFeatures = tester.allRenderObjects.firstWhere(
        (object) => object.runtimeType.toString() == '_RenderInkFeatures',
      );
      expect(inkFeatures, isNot(paints..circle()));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(taps, 0);

      expect(
        tester.getSemantics(find.byType(PalmUIButton)),
        containsSemantics(
          label: 'Submit',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('null onPressed is also disabled', (tester) async {
      await tester.pumpWidget(
        _frame(const PalmUIButton(onPressed: null, child: Text('Submit'))),
      );
      final ink = tester.widget<InkWell>(
        find.descendant(
          of: find.byType(PalmUIButton),
          matching: find.byType(InkWell),
        ),
      );
      expect(ink.onTap, isNull);
    });
  });

  group('keyboard', () {
    testWidgets('checkbox and switch toggle with Tab then Space or Enter', (
      tester,
    ) async {
      var checked = false;
      var on = false;
      await tester.pumpWidget(
        _frame(
          StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PalmUICheckbox(
                  value: checked,
                  label: 'Remember me',
                  onChanged: (next) => setState(() => checked = next),
                ),
                PalmUISwitch(
                  value: on,
                  semanticLabel: 'Dark mode',
                  onChanged: (next) => setState(() => on = next),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(checked, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(on, isTrue);
    });

    testWidgets('tab activates with the keyboard', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _frame(PalmUITab(label: 'Stock', selected: false, onTap: () => taps++)),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);
    });
  });

  testWidgets('controls meet the tap target and labelling guidelines', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _frame(
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PalmUIButton(onPressed: () {}, child: const Text('Save')),
              PalmUIButton(
                size: PalmUIButtonSize.icon,
                semanticLabel: 'Add',
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              PalmUICheckbox(value: true, onChanged: (_) {}, label: 'Terms'),
              PalmUICheckbox(
                value: false,
                onChanged: (_) {},
                semanticLabel: 'Select row',
              ),
              PalmUIRadioGroup<int>(
                value: 1,
                onChanged: (_) {},
                children: const [
                  PalmUIRadio(value: 1, label: 'One'),
                  PalmUIRadio(value: 2, label: 'Two'),
                ],
              ),
              PalmUISwitch(
                value: false,
                semanticLabel: 'Wi-Fi',
                onChanged: (_) {},
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PalmUITab(label: 'A', selected: true, onTap: () {}),
                  PalmUITab(label: 'B', selected: false, onTap: () {}),
                ],
              ),
              PalmUIBottomNav(
                destinations: const [
                  PalmUINavDestination(icon: Icons.home, label: 'Home'),
                  PalmUINavDestination(icon: Icons.settings, label: 'Settings'),
                ],
                selectedIndex: 0,
                onSelected: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });
}
