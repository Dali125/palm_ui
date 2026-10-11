import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_demo/main.dart';
import 'package:palm_ui/palm_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const names = <String, Type>{
    'Accordion': PalmUIAccordion,
    'Alert': PalmUIAlert,
    'Alert Dialog': PalmUIAlertDialog,
    'Aspect Ratio': PalmUIAspectRatio,
    'Avatar': PalmUIAvatar,
    'Badge': PalmUIBadge,
    'Breadcrumb': PalmUIBreadcrumb,
    'Button': PalmUIButton,
    'Button Group': PalmUIButtonGroup,
    'Calendar': PalmUICalendar,
    'Card': PalmUICard,
    'Carousel': PalmUICarousel,
    'Checkbox': PalmUICheckbox,
    'Collapsible': PalmUICollapsible,
    'Combobox': PalmUICombobox,
    'Command': PalmUICommand,
    'Context Menu': PalmUIContextMenu,
    'Data Table': PalmUIDataTable,
    'Date Picker': PalmUIDatePicker,
    'Dialog': PalmUIDialog,
    'Drawer': PalmUIDrawer,
    'Dropdown Menu': PalmUIDropdownMenu,
    'Empty': PalmUIEmpty,
    'Field': PalmUIField,
    'Hover Card': PalmUIHoverCard,
    'Input': PalmUIInput,
    'Input Group': PalmUIInputGroup,
    'Input OTP': PalmUIInputOtp,
    'Item': PalmUIItem,
    'Kbd': PalmUIKbd,
    'Label': PalmUILabel,
    'Menubar': PalmUIMenubar,
    'Navigation Menu': PalmUINavigationMenu,
    'Pagination': PalmUIPagination,
    'Popover': PalmUIPopover,
    'Progress': PalmUIProgress,
    'Radio Group': PalmUIRadioGroup<String>,
    'Scroll Area': PalmUIScrollArea,
    'Select': PalmUISelect<String>,
    'Separator': PalmUISeparator,
    'Sheet': PalmUISheet,
    'Sidebar': PalmUISidebar,
    'Skeleton': PalmUISkeleton,
    'Slider': PalmUISlider,
    'Spinner': PalmUISpinner,
    'Switch': PalmUISwitch,
    'Table': PalmUITable,
    'Tabs': PalmUITabs,
    'Textarea': PalmUITextarea,
    'Toast': PalmUIToastCard,
    'Toggle': PalmUIToggle,
    'Toggle Group': PalmUIToggleGroup,
    'Tooltip': PalmUITooltip,
    'Typography': PalmUIText,
    'Bottom Navigation Bar': PalmUIBottomNav,
    'App Bar': PalmUIAppBar,
    'Floating Action Button': PalmUIFab,
    'List/Settings Row': PalmUIListTile,
  };

  testWidgets('demo catalog, safe area, theme, and live button at phone size', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);

    await tester.pumpWidget(const PalmUIDemoApp());
    await tester.pump();

    expect(tester.takeException(), isNull);
    for (final name in names.keys) {
      expect(find.text(name), findsWidgets, reason: name);
    }

    final scroll = tester.getRect(find.byKey(const Key('catalog-scroll')));
    expect(scroll.top, greaterThanOrEqualTo(47));
    expect(scroll.bottom, lessThanOrEqualTo(844 - 34 + 0.5));
    expect(scroll.height, greaterThan(0));
    expect(scroll.width, greaterThan(0));

    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app().theme!.brightness, Brightness.light);
    await tester.tap(find.byType(PalmUISwitch));
    await tester.pump();
    expect(app().theme!.brightness, Brightness.dark);
    await tester.pump(const Duration(milliseconds: 250));

    final catalogScroll = find.descendant(
      of: find.byKey(const Key('catalog-scroll')),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Button'),
      200,
      scrollable: catalogScroll,
    );
    await tester.tap(find.text('Button'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(PalmUIButton), findsWidgets);
    expect(find.text('Pressed 0'), findsOneWidget);
    await tester.tap(find.text('Tap me'));
    await tester.pump();
    expect(find.text('Pressed 1'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    for (final entry in names.entries) {
      final tile = find.text(entry.key);
      await tester.scrollUntilVisible(tile, 220, scrollable: catalogScroll);
      await tester.tap(tile);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        find.byType(entry.value),
        findsWidgets,
        reason: '${entry.key} should render ${entry.value}',
      );
      expect(tester.takeException(), isNull, reason: entry.key);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
