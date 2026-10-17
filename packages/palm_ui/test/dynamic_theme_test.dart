import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:palm_ui/dynamic_color.dart';
import 'package:palm_ui/palm_ui.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  void mockPalette(List<int>? colors) {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      DynamicColorPlugin.channel,
      (MethodCall call) async {
        if (call.method == DynamicColorPlugin.methodName) return colors;
        return null;
      },
    );
  }

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      DynamicColorPlugin.channel,
      null,
    );
  });

  test(
    'dynamic themes are unavailable when the device has no palette',
    () async {
      mockPalette(null);

      final themes = await PalmUIDynamicThemes.load();

      expect(themes.isAvailable, isFalse);
      expect(
        themes.resolve(Brightness.light).primary,
        PalmUIThemeData.light().primary,
      );
      expect(
        themes.resolve(Brightness.dark).background,
        PalmUIThemeData.dark().background,
      );
    },
  );

  test('load falls back when the plugin is missing (iOS, web)', () async {
    // No mock handler: the channel throws MissingPluginException.
    final themes = await PalmUIDynamicThemes.load();

    expect(themes.isAvailable, isFalse);
    expect(themes.resolve(Brightness.dark), PalmUIThemeData.dark());
  });

  test('load falls back when the plugin reports an error', () async {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      DynamicColorPlugin.channel,
      (MethodCall call) async {
        throw PlatformException(code: 'unavailable');
      },
    );

    final themes = await PalmUIDynamicThemes.load();

    expect(themes.isAvailable, isFalse);
    expect(themes.resolve(Brightness.light), PalmUIThemeData.light());
  });

  test('dynamic themes use the Android system core palette', () async {
    // ignore: deprecated_member_use
    final palette = CorePalette.of(0xFF006E1C);
    // ignore: deprecated_member_use
    mockPalette(palette.asList());

    final themes = await PalmUIDynamicThemes.load();
    final light = themes.light!;
    final dark = themes.dark!;

    expect(themes.isAvailable, isTrue);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    expect(light.primary.toARGB32(), palette.primary.get(40));
    expect(dark.primary.toARGB32(), palette.primary.get(80));
    expect(light.background.toARGB32(), palette.neutral.get(99));
    expect(dark.background.toARGB32(), palette.neutral.get(10));
    expect(light.destructive.toARGB32(), palette.error.get(40));
    expect(light.primary, isNot(PalmUIThemeData.light().primary));
    expect(light.radius, 10);
  });

  test('dynamic mapping matches PalmUIThemeData.fromColorScheme', () async {
    // ignore: deprecated_member_use
    final palette = CorePalette.of(0xFF6750A4);
    // ignore: deprecated_member_use
    mockPalette(palette.asList());

    final themes = await PalmUIDynamicThemes.load(radius: 14);
    for (final brightness in Brightness.values) {
      final scheme = palette.toColorScheme(brightness: brightness);
      final expected = PalmUIThemeData.fromColorScheme(
        ColorScheme(
          brightness: brightness,
          primary: scheme.primary,
          onPrimary: scheme.onPrimary,
          secondary: scheme.secondary,
          onSecondary: scheme.onSecondary,
          secondaryContainer: scheme.secondaryContainer,
          onSecondaryContainer: scheme.onSecondaryContainer,
          tertiaryContainer: scheme.tertiaryContainer,
          onTertiaryContainer: scheme.onTertiaryContainer,
          error: scheme.error,
          onError: scheme.onError,
          surface: scheme.surface,
          onSurface: scheme.onSurface,
          onSurfaceVariant: scheme.onSurfaceVariant,
          surfaceContainerLow: scheme.surfaceContainerLow,
          surfaceContainer: scheme.surfaceContainer,
          surfaceContainerHighest: scheme.surfaceContainerHighest,
          outlineVariant: scheme.outlineVariant,
        ),
        radius: 14,
      );
      expect(themes.resolve(brightness), expected);
    }
  });

  testWidgets('a color scheme is what the default button paints', (
    tester,
  ) async {
    const seed = Color(0xFF006E1C);
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    final theme = PalmUIThemeData.fromColorScheme(scheme);

    expect(theme.primary, scheme.primary);
    expect(theme.background, scheme.surface);
    expect(theme.destructive, scheme.error);
    expect(theme.card, scheme.surfaceContainerLow);

    await tester.pumpWidget(
      PalmUITheme(
        data: theme,
        child: MaterialApp(
          theme: theme.toThemeData(),
          home: const Scaffold(
            body: PalmUIButton(onPressed: _noop, child: Text('Go')),
          ),
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
    expect(material.color, scheme.primary);
    final shape = material.shape! as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(theme.radius));
  });
}

void _noop() {}
