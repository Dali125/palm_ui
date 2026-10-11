import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';

class PalmUIAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PalmUIAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.height = 56,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
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

class PalmUIFab extends StatelessWidget {
  const PalmUIFab({super.key, required this.onPressed, required this.child});

  final VoidCallback? onPressed;
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

class PalmUIListTile extends StatelessWidget {
  const PalmUIListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
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
