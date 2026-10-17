import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Minimum hit target for mobile controls, in logical pixels.
const double kPalmUIMinTouchTarget = 44;

/// Palm UI semantic roles, shared corner radius, and light/dark presets.
@immutable
class PalmUIThemeData {
  /// Creates a theme from explicit role colors and a corner [radius].
  ///
  /// Most apps start from [PalmUIThemeData.light], [PalmUIThemeData.dark] or
  /// [PalmUIThemeData.fromColorScheme] and adjust them with [copyWith].
  const PalmUIThemeData({
    required this.brightness,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.radius,
  });

  /// Whether this is a light or dark theme.
  final Brightness brightness;

  /// The page background color.
  final Color background;

  /// The default text and icon color on [background].
  final Color foreground;

  /// The surface color of cards.
  final Color card;

  /// Text and icon color on [card].
  final Color cardForeground;

  /// The surface color of menus, dialogs, sheets and toasts.
  final Color popover;

  /// Text and icon color on [popover].
  final Color popoverForeground;

  /// The brand color for primary buttons, selected states and progress.
  final Color primary;

  /// Text and icon color on [primary].
  final Color primaryForeground;

  /// The fill color of secondary buttons and progress tracks.
  final Color secondary;

  /// Text and icon color on [secondary].
  final Color secondaryForeground;

  /// Subtle fill color for skeletons, table headers and switch tracks.
  final Color muted;

  /// Color for placeholders, hints and secondary text.
  final Color mutedForeground;

  /// Highlight color for selected tabs, toggles and hovered items.
  final Color accent;

  /// Text and icon color on [accent].
  final Color accentForeground;

  /// Color for errors and destructive actions.
  final Color destructive;

  /// Text and icon color on [destructive].
  final Color destructiveForeground;

  /// Color of borders and dividers.
  final Color border;

  /// Border color of inputs and selects.
  final Color input;

  /// Focus ring color, also used for the text cursor.
  final Color ring;

  /// Corner radius in logical pixels. the default 0.625rem is 10.
  final double radius;

  /// Neutral light preset. Near-white background, near-black foreground and
  /// primary, red destructive, radius 10.
  factory PalmUIThemeData.light() {
    return PalmUIThemeData(
      brightness: Brightness.light,
      background: oklch(1, 0, 0),
      foreground: oklch(0.145, 0, 0),
      card: oklch(1, 0, 0),
      cardForeground: oklch(0.145, 0, 0),
      popover: oklch(1, 0, 0),
      popoverForeground: oklch(0.145, 0, 0),
      primary: oklch(0.205, 0, 0),
      primaryForeground: oklch(0.985, 0, 0),
      secondary: oklch(0.97, 0, 0),
      secondaryForeground: oklch(0.205, 0, 0),
      muted: oklch(0.97, 0, 0),
      mutedForeground: oklch(0.556, 0, 0),
      accent: oklch(0.97, 0, 0),
      accentForeground: oklch(0.205, 0, 0),
      destructive: oklch(0.577, 0.245, 27.325),
      destructiveForeground: oklch(0.985, 0, 0),
      border: oklch(0.922, 0, 0),
      input: oklch(0.922, 0, 0),
      ring: oklch(0.708, 0, 0),
      radius: 10,
    );
  }

  /// Neutral dark preset. Near-black background, near-white foreground and
  /// primary, red destructive, radius 10.
  factory PalmUIThemeData.dark() {
    return PalmUIThemeData(
      brightness: Brightness.dark,
      background: oklch(0.145, 0, 0),
      foreground: oklch(0.985, 0, 0),
      card: oklch(0.205, 0, 0),
      cardForeground: oklch(0.985, 0, 0),
      popover: oklch(0.205, 0, 0),
      popoverForeground: oklch(0.985, 0, 0),
      primary: oklch(0.922, 0, 0),
      primaryForeground: oklch(0.205, 0, 0),
      secondary: oklch(0.269, 0, 0),
      secondaryForeground: oklch(0.985, 0, 0),
      muted: oklch(0.269, 0, 0),
      mutedForeground: oklch(0.708, 0, 0),
      accent: oklch(0.269, 0, 0),
      accentForeground: oklch(0.985, 0, 0),
      destructive: oklch(0.704, 0.191, 22.216),
      destructiveForeground: oklch(0.985, 0, 0),
      border: oklch(1, 0, 0, 0.10),
      input: oklch(1, 0, 0, 0.15),
      ring: oklch(0.556, 0, 0),
      radius: 10,
    );
  }

  /// Maps a Material [ColorScheme] onto Palm UI roles.
  ///
  /// Used for Android dynamic color, where the scheme comes from the system
  /// wallpaper palette. [radius] stays the shared corner radius.
  factory PalmUIThemeData.fromColorScheme(
    ColorScheme scheme, {
    double radius = 10,
  }) {
    return PalmUIThemeData(
      brightness: scheme.brightness,
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

  /// Returns a copy of this theme with the given roles replaced.
  PalmUIThemeData copyWith({
    Brightness? brightness,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    double? radius,
  }) {
    return PalmUIThemeData(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      radius: radius ?? this.radius,
    );
  }

  /// Builds a Material [ThemeData] that matches this theme, for
  /// [MaterialApp.theme], so Material widgets used beside Palm UI look
  /// consistent.
  ThemeData toThemeData() {
    final base = brightness == Brightness.dark
        ? ColorScheme.dark()
        : ColorScheme.light();
    final scheme = base.copyWith(
      primary: primary,
      onPrimary: primaryForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      error: destructive,
      onError: destructiveForeground,
      surface: background,
      onSurface: foreground,
    );
    final text = TextStyle(color: foreground);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: border,
      iconTheme: IconThemeData(color: foreground),
      textTheme: TextTheme(
        bodyLarge: text,
        bodyMedium: text.copyWith(fontSize: 14),
        bodySmall: text.copyWith(fontSize: 12, color: mutedForeground),
        titleLarge: text.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: text.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        labelLarge: text.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PalmUIThemeData &&
        other.brightness == brightness &&
        other.background == background &&
        other.foreground == foreground &&
        other.card == card &&
        other.cardForeground == cardForeground &&
        other.popover == popover &&
        other.popoverForeground == popoverForeground &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.muted == muted &&
        other.mutedForeground == mutedForeground &&
        other.accent == accent &&
        other.accentForeground == accentForeground &&
        other.destructive == destructive &&
        other.destructiveForeground == destructiveForeground &&
        other.border == border &&
        other.input == input &&
        other.ring == ring &&
        other.radius == radius;
  }

  @override
  int get hashCode => Object.hashAll([
    brightness,
    background,
    foreground,
    card,
    cardForeground,
    popover,
    popoverForeground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    input,
    ring,
    radius,
  ]);
}

/// Provides [PalmUIThemeData] to descendant Palm UI widgets.
class PalmUITheme extends InheritedWidget {
  /// Provides [data] to the Palm UI widgets below it.
  const PalmUITheme({super.key, required this.data, required super.child});

  /// The theme for this subtree.
  final PalmUIThemeData data;

  /// The nearest theme above [context], or [PalmUIThemeData.light] when there
  /// is none.
  static PalmUIThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PalmUITheme>();
    return scope?.data ?? PalmUIThemeData.light();
  }

  @override
  bool updateShouldNotify(PalmUITheme oldWidget) => oldWidget.data != data;
}

/// Converts an OKLCH color (OKLCH token space) to Flutter [Color].
Color oklch(double l, double c, double h, [double alpha = 1]) {
  final radians = h * math.pi / 180;
  final a = c * math.cos(radians);
  final b = c * math.sin(radians);
  final lmsL = l + 0.3963377774 * a + 0.2158037573 * b;
  final lmsM = l - 0.1055613458 * a - 0.0638541728 * b;
  final lmsS = l - 0.0894841775 * a - 1.2914855480 * b;
  final l3 = lmsL * lmsL * lmsL;
  final m3 = lmsM * lmsM * lmsM;
  final s3 = lmsS * lmsS * lmsS;
  final red = _srgb(4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3);
  final green = _srgb(
    -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3,
  );
  final blue = _srgb(
    -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3,
  );
  return Color.fromARGB(
    (alpha.clamp(0, 1) * 255).round(),
    (red * 255).round(),
    (green * 255).round(),
    (blue * 255).round(),
  );
}

double _srgb(double channel) {
  if (channel <= 0) return 0;
  if (channel >= 1) return 1;
  if (channel <= 0.0031308) return 12.92 * channel;
  return 1.055 * math.pow(channel, 1 / 2.4) - 0.055;
}

/// Linear interpolate between two theme presets. Useful for theme toggles.
PalmUIThemeData lerpPalmUITheme(
  PalmUIThemeData a,
  PalmUIThemeData b,
  double t,
) {
  if (t <= 0) return a;
  if (t >= 1) return b;
  Color mix(Color x, Color y) => Color.lerp(x, y, t)!;
  return PalmUIThemeData(
    brightness: t < 0.5 ? a.brightness : b.brightness,
    background: mix(a.background, b.background),
    foreground: mix(a.foreground, b.foreground),
    card: mix(a.card, b.card),
    cardForeground: mix(a.cardForeground, b.cardForeground),
    popover: mix(a.popover, b.popover),
    popoverForeground: mix(a.popoverForeground, b.popoverForeground),
    primary: mix(a.primary, b.primary),
    primaryForeground: mix(a.primaryForeground, b.primaryForeground),
    secondary: mix(a.secondary, b.secondary),
    secondaryForeground: mix(a.secondaryForeground, b.secondaryForeground),
    muted: mix(a.muted, b.muted),
    mutedForeground: mix(a.mutedForeground, b.mutedForeground),
    accent: mix(a.accent, b.accent),
    accentForeground: mix(a.accentForeground, b.accentForeground),
    destructive: mix(a.destructive, b.destructive),
    destructiveForeground: mix(
      a.destructiveForeground,
      b.destructiveForeground,
    ),
    border: mix(a.border, b.border),
    input: mix(a.input, b.input),
    ring: mix(a.ring, b.ring),
    radius: lerpDouble(a.radius, b.radius, t)!,
  );
}
