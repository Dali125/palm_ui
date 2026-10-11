import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palm_ui/palm_ui.dart';

Widget frame(Widget child, {PalmUIThemeData? theme}) {
  final data = theme ?? PalmUIThemeData.light();
  return PalmUITheme(
    data: data,
    child: MaterialApp(
      theme: data.toThemeData(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'light and dark presets use semantic luminance and red destructive',
    (tester) async {
      for (final preset in [PalmUIThemeData.light(), PalmUIThemeData.dark()]) {
        await tester.pumpWidget(
          frame(
            const PalmUIButton(onPressed: _noop, child: Text('Go')),
            theme: preset,
          ),
        );
        final theme = tester.widget<PalmUITheme>(find.byType(PalmUITheme)).data;
        final button = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(PalmUIButton),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(button.color, theme.primary);
        if (preset.brightness == Brightness.light) {
          expect(theme.background.computeLuminance(), greaterThan(0.9));
          expect(theme.foreground.computeLuminance(), lessThan(0.15));
          expect(theme.primary.computeLuminance(), lessThan(0.2));
        } else {
          expect(theme.background.computeLuminance(), lessThan(0.15));
          expect(theme.foreground.computeLuminance(), greaterThan(0.9));
          expect(theme.primary.computeLuminance(), greaterThan(0.7));
        }
        final destructive = HSVColor.fromColor(theme.destructive);
        expect(destructive.saturation, greaterThan(0.45));
        expect(
          destructive.hue <= 40 || destructive.hue >= 340,
          isTrue,
          reason: 'destructive hue ${destructive.hue} should stay red',
        );
      }
    },
  );

  testWidgets(
    'button, card, and input paint caller primary, background, and radius',
    (tester) async {
      const primary = Color(0xFF0055FF);
      const background = Color(0xFFFFEECC);
      final theme = PalmUIThemeData.light().copyWith(
        primary: primary,
        background: background,
        radius: 22,
      );
      await tester.pumpWidget(
        frame(
          const Column(
            children: [
              PalmUIButton(onPressed: _noop, child: Text('Go')),
              PalmUICard(child: Text('Card')),
              PalmUIInput(),
            ],
          ),
          theme: theme,
        ),
      );

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(PalmUIButton),
              matching: find.byType(Material),
            )
            .first,
      );
      final shape = material.shape! as RoundedRectangleBorder;
      expect(material.color, primary);
      expect(shape.borderRadius, BorderRadius.circular(22));

      final card = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(PalmUICard),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final decoration = card.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(22));

      final input = tester.widget<TextField>(find.byType(TextField));
      expect(input.decoration!.fillColor, background);
      final border = input.decoration!.enabledBorder! as OutlineInputBorder;
      expect(border.borderRadius, BorderRadius.circular(22));
    },
  );

  testWidgets('button variants differ and a disabled button does not call back', (
    tester,
  ) async {
    final signatures = <String>{};
    for (final variant in PalmUIButtonVariant.values) {
      await tester.pumpWidget(
        frame(
          PalmUIButton(
            variant: variant,
            onPressed: _noop,
            child: Text(variant.name),
          ),
        ),
      );
      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(PalmUIButton),
              matching: find.byType(Material),
            )
            .first,
      );
      final border = (material.shape! as RoundedRectangleBorder).side.color;
      final style = DefaultTextStyle.of(tester.element(find.text(variant.name)))
          .style;
      signatures.add(
        '${material.color!.toARGB32()}-${style.color!.toARGB32()}-${border.toARGB32()}-${style.decoration}',
      );
    }
    expect(signatures, hasLength(PalmUIButtonVariant.values.length));

    var taps = 0;
    await tester.pumpWidget(
      frame(
        PalmUIButton(
          enabled: false,
          onPressed: () => taps++,
          child: const Text('Save'),
        ),
      ),
    );
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(taps, 0);
  });

  testWidgets(
    'input, switch, checkbox, radio, slider, and select change value',
    (tester) async {
      final harness = _FormProbe();
      await tester.pumpWidget(frame(_ValueHarness(harness)));
      await tester.enterText(find.byType(TextField), 'hello');
      expect(harness.text, 'hello');

      await tester.tap(find.byType(PalmUISwitch));
      await tester.pump();
      expect(harness.on, isTrue);

      await tester.tap(find.byType(PalmUICheckbox));
      await tester.pump();
      expect(harness.checked, isTrue);

      await tester.tap(find.text('Beta'));
      await tester.pump();
      expect(harness.choice, 'beta');

      await tester.drag(find.byType(Slider), const Offset(80, 0));
      await tester.pump();
      expect(harness.amount, greaterThan(0.2));

      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Blue'));
      await tester.pumpAndSettle();
      expect(harness.colorName, 'blue');
    },
  );

  testWidgets('accordion toggles and tabs swap the visible panel', (
    tester,
  ) async {
    await tester.pumpWidget(
      frame(
        const Column(
          children: [
            PalmUIAccordion(
              entries: [
                PalmUIAccordionEntry(
                  title: Text('Section'),
                  content: Text('Secret'),
                ),
              ],
            ),
            PalmUITabs(
              tabs: ['One', 'Two'],
              children: [Text('Panel A'), Text('Panel B')],
            ),
          ],
        ),
      ),
    );
    expect(find.text('Secret'), findsNothing);
    expect(find.text('Panel A'), findsOneWidget);
    expect(find.text('Panel B'), findsNothing);

    await tester.tap(find.text('Section'));
    await tester.pump();
    expect(find.text('Secret'), findsOneWidget);
    await tester.tap(find.text('Section'));
    await tester.pump();
    expect(find.text('Secret'), findsNothing);

    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(find.text('Panel A'), findsNothing);
    expect(find.text('Panel B'), findsOneWidget);
  });

  testWidgets(
    'dialog opens and dismisses; alert dialog splits confirm and cancel',
    (tester) async {
      final result = ValueNotifier<bool?>(null);
      await tester.pumpWidget(
        frame(
          Builder(
            builder: (context) {
              return Column(
                children: [
                  PalmUIButton(
                    onPressed: () {
                      showPalmUIDialog<void>(
                        context: context,
                        builder: (dialogContext) => PalmUIDialog(
                          title: const Text('Hello dialog'),
                          actions: [
                            PalmUIButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Open dialog'),
                  ),
                  PalmUIButton(
                    onPressed: () async {
                      result.value = await showPalmUIAlertDialog(
                        context: context,
                        title: const Text('Delete?'),
                        cancelLabel: 'Keep',
                        confirmLabel: 'Delete',
                      );
                    },
                    child: const Text('Ask'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open dialog'));
      await tester.pumpAndSettle();
      expect(find.text('Hello dialog'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Hello dialog'), findsNothing);

      await tester.tap(find.text('Ask'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep'));
      await tester.pumpAndSettle();
      expect(result.value, isFalse);

      await tester.tap(find.text('Ask'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(result.value, isTrue);
    },
  );

  testWidgets('sheet and drawer open from an edge', (tester) async {
    await tester.pumpWidget(
      frame(
        Builder(
          builder: (context) {
            return Column(
              children: [
                PalmUIButton(
                  onPressed: () => showPalmUISheet<void>(
                    context: context,
                    builder: (context) => const PalmUISheet(
                      child: SizedBox(height: 160, child: Text('Sheet body')),
                    ),
                  ),
                  child: const Text('Open sheet'),
                ),
                PalmUIButton(
                  onPressed: () => showPalmUIDrawer<void>(
                    context: context,
                    title: const Text('Drawer'),
                    builder: (context) => const Text('Drawer body'),
                  ),
                  child: const Text('Open drawer'),
                ),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    final sheet = tester.getRect(find.byType(PalmUISheet));
    expect(sheet.bottom, closeTo(screen.height, 1));
    expect(sheet.left, lessThanOrEqualTo(1));
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();
    final drawer = tester.getRect(find.byType(PalmUIDrawer));
    expect(drawer.left, closeTo(0, 1));
    expect(drawer.top, closeTo(0, 1));
    expect(drawer.height, greaterThan(100));
  });

  testWidgets('dropdown invokes the chosen item and toast shows its message', (
    tester,
  ) async {
    var picked = '';
    await tester.pumpWidget(
      frame(
        PalmUIToaster(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  PalmUIDropdownMenu(
                    items: [
                      PalmUIMenuItem(
                        label: 'Edit',
                        onSelected: () => picked = 'Edit',
                      ),
                    ],
                    child: const Text('Menu'),
                  ),
                  PalmUIButton(
                    onPressed: () =>
                        PalmUIToast.show(context, message: 'Saved'),
                    child: const Text('Notify'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(picked, 'Edit');

    await tester.tap(find.text('Notify'));
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
    await tester.tap(find.text('Dismiss'));
    await tester.pump();
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('data table sort order and page change', (tester) async {
    await tester.pumpWidget(
      frame(
        const PalmUIDataTable(
          pageSize: 2,
          columns: [
            PalmUIDataColumn(id: 'name', label: 'Name'),
            PalmUIDataColumn(id: 'role', label: 'Role'),
          ],
          rows: [
            PalmUIDataRow(cells: {'name': 'Bravo', 'role': 'Dev'}),
            PalmUIDataRow(cells: {'name': 'Alpha', 'role': 'QA'}),
            PalmUIDataRow(cells: {'name': 'Charlie', 'role': 'Design'}),
          ],
        ),
      ),
    );

    expect(_tableTexts(tester)[2], 'Bravo');
    await tester.tap(find.text('Name'));
    await tester.pump();
    expect(_tableTexts(tester)[2], 'Alpha');
    expect(find.text('Charlie'), findsNothing);

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(find.text('Charlie'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);
  });

  testWidgets('bottom nav changes the visible child and the fab fires', (
    tester,
  ) async {
    await tester.pumpWidget(frame(const _NavAndFab()));
    expect(find.text('Home body'), findsOneWidget);
    await tester.tap(find.text('Search'));
    await tester.pump();
    expect(find.text('Search body'), findsOneWidget);
    expect(find.text('Home body'), findsNothing);

    await tester.tap(find.byType(PalmUIFab));
    await tester.pump();
    expect(find.text('Fab 1'), findsOneWidget);
  });

  testWidgets('mobile controls are at least 44 logical pixels at phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      frame(
        const Column(
          children: [
            PalmUIButton(onPressed: _noop, child: Text('Tap')),
            PalmUIInput(),
            PalmUISwitch(value: false, onChanged: _ignoreBool),
            PalmUITabs(
              tabs: ['First', 'Second'],
              children: [Text('A'), Text('B')],
            ),
            PalmUIListTile(title: Text('Row'), onTap: _noop),
            PalmUIBottomNav(
              selectedIndex: 0,
              onSelected: _ignoreInt,
              destinations: [
                PalmUINavDestination(icon: Icons.home, label: 'Home'),
                PalmUINavDestination(icon: Icons.search, label: 'Search'),
              ],
            ),
          ],
        ),
      ),
    );

    void expectTarget(Finder finder) {
      final size = tester.getSize(finder);
      expect(size.width, greaterThanOrEqualTo(44), reason: '$finder width');
      expect(size.height, greaterThanOrEqualTo(44), reason: '$finder height');
    }

    expectTarget(find.byType(PalmUIButton));
    expectTarget(find.byType(PalmUIInput));
    expectTarget(find.byType(PalmUISwitch));
    expectTarget(find.byType(PalmUITab).first);
    expectTarget(find.byType(PalmUIListTile));
    expectTarget(find.byType(PalmUIBottomNavItem).first);
  });

  testWidgets('carousel, otp, combobox, command, calendar, and date picker', (
    tester,
  ) async {
    final host = _PickerProbe();
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(frame(_PickerHost(host)));

    await tester.fling(find.byType(PageView), const Offset(-500, 0), 1200);
    await tester.pumpAndSettle();
    expect(host.page, 1);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '1');
    await tester.enterText(fields.at(1), '2');
    await tester.enterText(fields.at(2), '3');
    await tester.enterText(fields.at(3), '4');
    expect(host.code, '1234');

    await tester.enterText(fields.at(4), 'ap');
    await tester.pump();
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
    await tester.tap(find.text('Apple'));
    await tester.pump();
    expect(host.fruit, 'Apple');

    await tester.enterText(fields.at(5), 'theme');
    await tester.pump();
    expect(find.text('Toggle theme'), findsOneWidget);
    expect(find.text('New file'), findsNothing);
    await tester.tap(find.text('Toggle theme'));
    expect(host.command, 'Toggle theme');

    await tester.tap(find.text('15'));
    expect(host.calendar, DateTime(2026, 1, 15));

    await tester.tap(find.byType(PalmUIDatePicker));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(PalmUIDialog), matching: find.text('10')),
    );
    await tester.pumpAndSettle();
    expect(host.picked, DateTime(2026, 3, 10));
  });

  testWidgets(
    'tooltip, hover card, and context menu open from tap or long-press',
    (tester) async {
      var copied = '';
      await tester.pumpWidget(
        frame(
          Column(
            children: [
              const PalmUITooltip(
                message: 'Hint text',
                child: Text('Hover me'),
              ),
              const SizedBox(height: 80),
              const PalmUIHoverCard(
                trigger: Text('Profile'),
                content: Text('Profile card'),
              ),
              const SizedBox(height: 80),
              PalmUIContextMenu(
                items: [
                  PalmUIMenuItem(
                    label: 'Copy',
                    onSelected: () => copied = 'Copy',
                  ),
                ],
                child: const Text('Target'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Hover me'));
      await tester.pump();
      expect(find.text('Hint text'), findsOneWidget);
      await tester.tap(find.text('Hover me'));
      await tester.pump();

      await tester.tap(find.text('Profile'));
      await tester.pump();
      expect(find.text('Profile card'), findsOneWidget);
      await tester.tap(find.text('Profile'));
      await tester.pump();

      await tester.longPress(find.text('Target'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();
      expect(copied, 'Copy');
    },
  );

  testWidgets(
    'progress reflects its value and a narrow sidebar is an overlay',
    (tester) async {
      await tester.pumpWidget(
        frame(
          const Center(
            child: SizedBox(width: 200, child: PalmUIProgress(value: 0.5)),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(PalmUIProgressIndicator)).width,
        closeTo(100, 1),
      );

      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(frame(const _SidebarHarness()));
      expect(find.byKey(const Key('shad-sidebar-panel')), findsNothing);
      expect(
        tester.getSize(find.byKey(const Key('shad-sidebar-body'))).width,
        closeTo(390, 1),
      );
      await tester.tap(find.byKey(const Key('shad-sidebar-trigger')));
      await tester.pump();
      final panel = tester.getRect(find.byKey(const Key('shad-sidebar-panel')));
      expect(panel.left, closeTo(0, 1));
      expect(
        tester.getSize(find.byKey(const Key('shad-sidebar-body'))).width,
        closeTo(390, 1),
      );

      tester.view.physicalSize = const Size(1024, 800);
      await tester.pumpWidget(frame(const _SidebarHarness()));
      expect(find.byKey(const Key('shad-sidebar-panel')), findsOneWidget);
      expect(find.byKey(const Key('shad-sidebar-trigger')), findsNothing);
      expect(
        tester.getSize(find.byKey(const Key('shad-sidebar-body'))).width,
        lessThan(900),
      );
    },
  );

  testWidgets('collapsible toggles its child', (tester) async {
    await tester.pumpWidget(
      frame(
        const PalmUICollapsible(
          title: Text('More'),
          child: Text('Hidden copy'),
        ),
      ),
    );
    expect(find.text('Hidden copy'), findsNothing);
    await tester.tap(find.text('More'));
    await tester.pump();
    expect(find.text('Hidden copy'), findsOneWidget);
  });
}

List<String> _tableTexts(WidgetTester tester) {
  return tester
      .widgetList<Text>(
        find.descendant(of: find.byType(Table), matching: find.byType(Text)),
      )
      .map((text) => text.data ?? '')
      .toList();
}

void _noop() {}

void _ignoreBool(bool _) {}

void _ignoreInt(int _) {}

class _FormProbe {
  String text = '';
  bool on = false;
  bool checked = false;
  String choice = 'alpha';
  double amount = 0.2;
  String colorName = 'red';
}

class _ValueHarness extends StatefulWidget {
  const _ValueHarness(this.probe);

  final _FormProbe probe;

  @override
  State<_ValueHarness> createState() => _ValueHarnessState();
}

class _ValueHarnessState extends State<_ValueHarness> {
  @override
  Widget build(BuildContext context) {
    final probe = widget.probe;
    return SingleChildScrollView(
      child: Column(
        children: [
          PalmUIInput(onChanged: (value) => probe.text = value),
          PalmUISwitch(
            value: probe.on,
            onChanged: (value) => setState(() => probe.on = value),
          ),
          PalmUICheckbox(
            value: probe.checked,
            onChanged: (value) => setState(() => probe.checked = value),
          ),
          PalmUIRadioGroup<String>(
            value: probe.choice,
            onChanged: (value) => setState(() => probe.choice = value),
            children: const [
              PalmUIRadio(value: 'alpha', label: 'Alpha'),
              PalmUIRadio(value: 'beta', label: 'Beta'),
            ],
          ),
          PalmUISlider(
            value: probe.amount,
            onChanged: (value) => setState(() => probe.amount = value),
          ),
          PalmUISelect<String>(
            value: probe.colorName,
            onChanged: (value) => setState(() => probe.colorName = value),
            items: const [
              PalmUISelectItem(value: 'red', label: 'Red'),
              PalmUISelectItem(value: 'blue', label: 'Blue'),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavAndFab extends StatefulWidget {
  const _NavAndFab();

  @override
  State<_NavAndFab> createState() => _NavAndFabState();
}

class _NavAndFabState extends State<_NavAndFab> {
  int _index = 0;
  int _fabs = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_index == 0 ? 'Home body' : 'Search body'),
        Text('Fab $_fabs'),
        PalmUIFab(
          onPressed: () => setState(() => _fabs++),
          child: const Icon(Icons.add),
        ),
        PalmUIBottomNav(
          selectedIndex: _index,
          onSelected: (index) => setState(() => _index = index),
          destinations: const [
            PalmUINavDestination(icon: Icons.home, label: 'Home'),
            PalmUINavDestination(icon: Icons.search, label: 'Search'),
          ],
        ),
      ],
    );
  }
}

class _PickerProbe {
  int page = 0;
  String code = '';
  String fruit = '';
  String command = '';
  DateTime? calendar;
  DateTime? picked;
}

class _PickerHost extends StatefulWidget {
  const _PickerHost(this.probe);

  final _PickerProbe probe;

  @override
  State<_PickerHost> createState() => _PickerHostState();
}

class _PickerHostState extends State<_PickerHost> {
  @override
  Widget build(BuildContext context) {
    final probe = widget.probe;
    return Column(
      children: [
        PalmUICarousel(
          onPageChanged: (page) => probe.page = page,
          items: const [Text('Slide 1'), Text('Slide 2')],
        ),
        PalmUIInputOtp(length: 4, onChanged: (value) => probe.code = value),
        PalmUICombobox(
          options: const ['Apple', 'Apricot', 'Banana'],
          onSelected: (value) => probe.fruit = value,
        ),
        PalmUICommand(
          items: const [
            PalmUICommandItem(label: 'New file'),
            PalmUICommandItem(label: 'Toggle theme'),
          ],
          onSelected: (item) => probe.command = item.label,
        ),
        PalmUICalendar(
          initialMonth: DateTime(2026, 1),
          onSelected: (date) => probe.calendar = date,
        ),
        PalmUIDatePicker(
          initialMonth: DateTime(2026, 3),
          onChanged: (date) => setState(() => probe.picked = date),
        ),
      ],
    );
  }
}

class _SidebarHarness extends StatelessWidget {
  const _SidebarHarness();

  @override
  Widget build(BuildContext context) {
    return const PalmUISidebar(
      entries: [
        PalmUISidebarEntry(label: 'Inbox', icon: Icons.inbox),
        PalmUISidebarEntry(label: 'Sent', icon: Icons.send),
      ],
      body: Text('Mailbox'),
    );
  }
}
