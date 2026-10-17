import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';

/// An entry in a Palm UI menu.
class PalmUIMenuItem {
  /// Creates a menu item with a [label].
  const PalmUIMenuItem({
    required this.label,
    this.onSelected,
    this.destructive = false,
  });

  /// The item text.
  final String label;

  /// Called when the item is chosen. The menu closes first.
  final VoidCallback? onSelected;

  /// Whether to show the item in the destructive color.
  final bool destructive;
}

/// The global rectangle of the widget for [context], used to place menus
/// and popovers next to it.
Rect palmUIAnchorRect(BuildContext context) {
  final box = context.findRenderObject()! as RenderBox;
  return box.localToGlobal(Offset.zero) & box.size;
}

/// Shows a popup menu of [items] next to [anchor].
///
/// Completes when the menu closes.
Future<void> showPalmUIMenu({
  required BuildContext context,
  required Rect anchor,
  required List<PalmUIMenuItem> items,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: const Color(0x33000000),
    transitionDuration: const Duration(milliseconds: 120),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _PalmUIMenuOverlay(anchor: anchor, items: items);
    },
  );
}

class _PalmUIMenuOverlay extends StatelessWidget {
  const _PalmUIMenuOverlay({required this.anchor, required this.items});

  final Rect anchor;
  final List<PalmUIMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    const width = 240.0;
    final estimated = math.min(320.0, items.length * kPalmUIMinTouchTarget + 8);
    var left = anchor.left;
    if (left + width > screen.width - 8) {
      left = screen.width - width - 8;
    }
    if (left < 8) left = 8;
    var top = anchor.bottom + 4;
    if (top + estimated > screen.height - 8) {
      top = math.max(8, anchor.top - estimated - 4);
    }
    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          width: width,
          child: _PalmUIMenuPanel(items: items),
        ),
      ],
    );
  }
}

class _PalmUIMenuPanel extends StatelessWidget {
  const _PalmUIMenuPanel({required this.items});

  final List<PalmUIMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: theme.popover,
      elevation: 8,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
        side: BorderSide(color: theme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 320),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in items)
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    item.onSelected?.call();
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: kPalmUIMinTouchTarget,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: item.destructive
                                ? theme.destructive
                                : theme.popoverForeground,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a menu of [items] below [child] when [child] is tapped.
class PalmUIDropdownMenu extends StatelessWidget {
  /// Creates a dropdown menu.
  const PalmUIDropdownMenu({
    super.key,
    required this.items,
    required this.child,
  });

  /// The menu entries.
  final List<PalmUIMenuItem> items;

  /// The trigger, usually a button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _PalmUIAnchorTrigger(
      onTap: (rect) =>
          showPalmUIMenu(context: context, anchor: rect, items: items),
      child: child,
    );
  }
}

/// Shows a menu of [items] when [child] is long-pressed.
class PalmUIContextMenu extends StatelessWidget {
  /// Creates a context menu.
  const PalmUIContextMenu({
    super.key,
    required this.items,
    required this.child,
  });

  /// The menu entries.
  final List<PalmUIMenuItem> items;

  /// The widget that opens the menu on long press.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showPalmUIMenu(
          context: context,
          anchor: palmUIAnchorRect(context),
          items: items,
        );
      },
      child: child,
    );
  }
}

class _PalmUIAnchorTrigger extends StatelessWidget {
  const _PalmUIAnchorTrigger({required this.onTap, required this.child});

  final void Function(Rect anchor) onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(palmUIAnchorRect(context)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1,
          child: child,
        ),
      ),
    );
  }
}
