import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';

enum PalmUIButtonVariant {
  primary,
  outline,
  ghost,
  destructive,
  secondary,
  link,
}

enum PalmUIButtonSize { sm, md, lg, icon }

class PalmUIButton extends StatelessWidget {
  const PalmUIButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = PalmUIButtonVariant.primary,
    this.size = PalmUIButtonSize.md,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final PalmUIButtonVariant variant;
  final PalmUIButtonSize size;
  final bool enabled;

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
    return Opacity(
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
            onTap: () {
              if (!active) return;
              onPressed!();
            },
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
                  child: Center(widthFactor: 1, heightFactor: 1, child: child),
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

class PalmUIButtonGroup extends StatelessWidget {
  const PalmUIButtonGroup({super.key, required this.children});

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
