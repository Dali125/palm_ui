import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'palm_ui_theme.dart';

/// Light and dark Palm UI themes built from the device dynamic palette.
///
/// [isAvailable] is false on phones without a system dynamic palette
/// (pre-Android 12, and platforms that do not expose one). Callers should
/// fall back to [PalmUIThemeData.light] or [PalmUIThemeData.dark].
class PalmUIDynamicThemes {
  /// Creates a pair of dynamic themes. Both are null when no palette exists.
  const PalmUIDynamicThemes({this.light, this.dark});

  /// The light theme from the system palette, or null when unavailable.
  final PalmUIThemeData? light;

  /// The dark theme from the system palette, or null when unavailable.
  final PalmUIThemeData? dark;

  /// Whether both [light] and [dark] were built from a system palette.
  bool get isAvailable => light != null && dark != null;

  /// Reads the Android system dynamic colors and maps them to Palm UI roles.
  ///
  /// Completes with [isAvailable] false when the device has no dynamic palette,
  /// and also when the platform has no dynamic color plugin (for example iOS
  /// and web) or the plugin reports an error. It never throws for those cases.
  /// The returned themes keep the shared [radius].
  static Future<PalmUIDynamicThemes> load({double radius = 10}) async {
    final Object? result;
    try {
      result = await DynamicColorPlugin.channel.invokeMethod(
        DynamicColorPlugin.methodName,
      );
    } on MissingPluginException {
      // iOS, web, and any platform without the native plugin.
      return const PalmUIDynamicThemes();
    } on PlatformException {
      // The plugin is present but could not read a palette.
      return const PalmUIDynamicThemes();
    }
    if (result is! List) {
      return const PalmUIDynamicThemes();
    }
    // The platform channel decodes the ARGB list as List<Object?>, which
    // CorePalette.fromList will not accept directly. Android still sends this
    // CorePalette tone list.
    // ignore: deprecated_member_use
    final palette = CorePalette.fromList(result.cast<int>());
    return PalmUIDynamicThemes(
      light: _fromDynamicPalette(
        palette,
        brightness: Brightness.light,
        radius: radius,
      ),
      dark: _fromDynamicPalette(
        palette,
        brightness: Brightness.dark,
        radius: radius,
      ),
    );
  }

  /// The dynamic theme for [brightness], or the neutral preset when the
  /// device did not provide a palette.
  PalmUIThemeData resolve(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return dark ?? PalmUIThemeData.dark();
    }
    return light ?? PalmUIThemeData.light();
  }
}

/// Builds a Palm UI theme from the dynamic core palette.
///
/// `dynamic_color` converts the palette with the `material_ui` package's
/// `ColorScheme`, which is a different type from Flutter's own
/// [ColorScheme], so it cannot be handed to [PalmUIThemeData.fromColorScheme]
/// directly. The role mapping below must stay identical to that factory; the
/// test suite checks that both produce the same theme.
PalmUIThemeData _fromDynamicPalette(
  // ignore: deprecated_member_use
  CorePalette palette, {
  required Brightness brightness,
  required double radius,
}) {
  final scheme = palette.toColorScheme(brightness: brightness);
  return PalmUIThemeData(
    brightness: brightness,
    background: scheme.surface,
    foreground: scheme.onSurface,
    card: scheme.surfaceContainerLow,
    cardForeground: scheme.onSurface,
    popover: scheme.surfaceContainer,
    popoverForeground: scheme.onSurface,
    primary: scheme.primary,
    primaryForeground: scheme.onPrimary,
    secondary: scheme.secondaryContainer,
    secondaryForeground: scheme.onSecondaryContainer,
    muted: scheme.surfaceContainerHighest,
    mutedForeground: scheme.onSurfaceVariant,
    accent: scheme.tertiaryContainer,
    accentForeground: scheme.onTertiaryContainer,
    destructive: scheme.error,
    destructiveForeground: scheme.onError,
    border: scheme.outlineVariant,
    input: scheme.outlineVariant,
    ring: scheme.primary,
    radius: radius,
  );
}
