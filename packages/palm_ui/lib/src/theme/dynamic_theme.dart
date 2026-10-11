import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'palm_ui_theme.dart';

/// Light and dark Palm UI themes built from the device dynamic palette.
///
/// [isAvailable] is false on phones without a system dynamic palette
/// (pre-Android 12, and platforms that do not expose one). Callers should
/// fall back to [PalmUIThemeData.light] or [PalmUIThemeData.dark].
class PalmUIDynamicThemes {
  const PalmUIDynamicThemes({this.light, this.dark});

  final PalmUIThemeData? light;
  final PalmUIThemeData? dark;

  bool get isAvailable => light != null && dark != null;

  /// Reads the Android system dynamic colors and maps them to Palm UI roles.
  ///
  /// Completes with [isAvailable] false when the device has no dynamic palette.
  /// The returned themes keep the shared [radius].
  static Future<PalmUIDynamicThemes> load({double radius = 10}) async {
    final result = await DynamicColorPlugin.channel.invokeMethod(
      DynamicColorPlugin.methodName,
    );
    if (result == null) {
      return const PalmUIDynamicThemes();
    }
    // The platform channel decodes the ARGB list as List<Object?>, which
    // CorePalette.fromList will not accept directly. Android still sends this
    // CorePalette tone list.
    // ignore: deprecated_member_use
    final palette = CorePalette.fromList((result as List).cast<int>());
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
