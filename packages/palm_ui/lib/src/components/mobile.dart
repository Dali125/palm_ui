import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';

/// A themed top app bar with a title, optional leading widget and actions.
///
/// Adds the status bar inset to its height.
class PalmUIAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an app bar.
  const PalmUIAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.height = 56,
  });

  /// The title, usually a [Text].
  final Widget title;

  /// A widget before the title, such as a back button.
  final Widget? leading;

  /// Widgets after the title, usually icon buttons.
  final List<Widget>? actions;

  /// The bar height in logical pixels, not counting the status bar. Defaults
  /// to 56.
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final top = MediaQuery.paddingOf(context).top;
    return Material(
      color: theme.background,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.border)),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: top),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: IconTheme(
                data: IconThemeData(color: theme.foreground),
                child: Row(
                  children: [
                    ?leading,
                    const SizedBox(width: 4),
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: theme.foreground,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: title,
                      ),
                    ),
                    ...?actions,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A round floating action button in the primary color.
class PalmUIFab extends StatelessWidget {
  /// Creates a floating action button.
  const PalmUIFab({super.key, required this.onPressed, required this.child});

  /// Called when the button is tapped. A null value disables it.
  final VoidCallback? onPressed;

  /// The button content, usually an [Icon].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: theme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radius + 6),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: IconTheme(
            data: IconThemeData(color: theme.primaryForeground),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// A full-width list row with a title, optional subtitle and side widgets.
class PalmUIListTile extends StatelessWidget {
  /// Creates a list tile.
  const PalmUIListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  /// The main text.
  final Widget title;

  /// Secondary text shown under [title].
  final Widget? subtitle;

  /// A widget before the text, such as an icon or avatar.
  final Widget? leading;

  /// A widget after the text, such as a switch or chevron.
  final Widget? trailing;

  /// Called when the row is tapped. When null the row is not tappable.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: kPalmUIMinTouchTarget,
            minHeight: kPalmUIMinTouchTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                if (leading != null) ...[
                  IconTheme(
                    data: IconThemeData(color: theme.mutedForeground),
                    child: leading!,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          color: theme.foreground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        child: title,
                      ),
                      if (subtitle != null)
                        DefaultTextStyle(
                          style: TextStyle(
                            color: theme.mutedForeground,
                            fontSize: 13,
                          ),
                          child: subtitle!,
                        ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
