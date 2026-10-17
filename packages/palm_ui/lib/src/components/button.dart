import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';

/// Visual style of a [PalmUIButton].
enum PalmUIButtonVariant {
  /// Solid button in the theme's primary color. Use for the main action.
  primary,

  /// Transparent button with a border, for secondary actions.
  outline,

  /// Borderless transparent button for low-emphasis actions.
  ghost,

  /// Solid button in the destructive color, for delete and other risky actions.
  destructive,

  /// Solid button in the secondary color.
  secondary,

  /// Underlined text in the primary color that behaves like a link.
  link,
}

/// Size of a [PalmUIButton]. Every size keeps the minimum touch target.
enum PalmUIButtonSize {
  /// Compact horizontal padding.
  sm,

  /// The default size.
  md,

  /// Wider padding and larger text.
  lg,

  /// No horizontal padding, for square icon-only buttons.
  icon,
}

/// A themed, mobile-sized button with Palm UI variants and sizes.
///
/// The button is at least [kPalmUIMinTouchTarget] logical pixels in each
/// direction. It is announced to screen readers as a button, can be focused and
/// activated from a keyboard, and is disabled (dimmed, no ripple, reported as
/// disabled) when [onPressed] is null or [enabled] is false.
///
/// ```dart
/// PalmUIButton(
///   onPressed: save,
///   variant: PalmUIButtonVariant.outline,
///   child: const Text('Save draft'),
/// )
/// ```
class PalmUIButton extends StatelessWidget {
  /// Creates a button that shows [child] and calls [onPressed] when tapped.
  const PalmUIButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = PalmUIButtonVariant.primary,
    this.size = PalmUIButtonSize.md,
    this.enabled = true,
    this.semanticLabel,
  });

  /// The button content, usually a [Text] or a [Row] with an icon and text.
  final Widget child;

  /// Called when the button is tapped. A null value disables the button.
  final VoidCallback? onPressed;

  /// The visual style. Defaults to [PalmUIButtonVariant.primary].
  final PalmUIButtonVariant variant;

  /// The horizontal padding and text size. Defaults to [PalmUIButtonSize.md].
  final PalmUIButtonSize size;

  /// Whether the button responds to taps. When false the button is disabled
  /// even if [onPressed] is set.
  final bool enabled;

  /// An optional label for screen readers, for example on icon-only buttons.
  /// When null the text inside [child] is announced.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final colors = _colorsFor(theme, variant);
    final padding = switch (size) {
      PalmUIButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12),
      PalmUIButtonSize.md => const EdgeInsets.symmetric(horizontal: 16),
      PalmUIButtonSize.lg => const EdgeInsets.symmetric(horizontal: 24),
      PalmUIButtonSize.icon => EdgeInsets.zero,
    };
    final active = enabled && onPressed != null;
    return Semantics(
      container: true,
      button: true,
      enabled: active,
      label: semanticLabel,
      child: Opacity(
        opacity: active ? 1 : 0.5,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: kPalmUIMinTouchTarget,
            minHeight: kPalmUIMinTouchTarget,
          ),
          child: Material(
            color: colors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(theme.radius),
              side: BorderSide(color: colors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              // A null callback disables the ink ripple, hover and focus.
              onTap: active ? onPressed : null,
              focusColor: theme.ring.withValues(alpha: 0.24),
              child: Padding(
                padding: padding,
                child: IconTheme(
                  data: IconThemeData(color: colors.foreground, size: 18),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: colors.foreground,
                      fontSize: size == PalmUIButtonSize.lg ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      decoration: variant == PalmUIButtonVariant.link
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: colors.foreground,
                    ),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonColors {
  const _ButtonColors(this.background, this.foreground, this.border);
  final Color background;
  final Color foreground;
  final Color border;
}

_ButtonColors _colorsFor(PalmUIThemeData theme, PalmUIButtonVariant variant) {
  return switch (variant) {
    PalmUIButtonVariant.primary => _ButtonColors(
      theme.primary,
      theme.primaryForeground,
      theme.primary,
    ),
    PalmUIButtonVariant.destructive => _ButtonColors(
      theme.destructive,
      theme.destructiveForeground,
      theme.destructive,
    ),
    PalmUIButtonVariant.secondary => _ButtonColors(
      theme.secondary,
      theme.secondaryForeground,
      theme.secondary,
    ),
    PalmUIButtonVariant.outline => _ButtonColors(
      Colors.transparent,
      theme.foreground,
      theme.border,
    ),
    PalmUIButtonVariant.ghost => _ButtonColors(
      Colors.transparent,
      theme.foreground,
      Colors.transparent,
    ),
    PalmUIButtonVariant.link => _ButtonColors(
      Colors.transparent,
      theme.primary,
      Colors.transparent,
    ),
  };
}

/// A horizontal, bordered strip of buttons that share dividers.
///
/// Scrolls horizontally when the buttons do not fit.
class PalmUIButtonGroup extends StatelessWidget {
  /// Creates a button group from [children].
  const PalmUIButtonGroup({super.key, required this.children});

  /// The buttons in the group, usually ghost [PalmUIButton]s.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.radius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.border),
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) Container(width: 1, height: 44, color: theme.border),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
