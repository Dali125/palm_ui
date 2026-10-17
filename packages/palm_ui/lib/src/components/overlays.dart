import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';
import 'button.dart';

/// The screen edge a sheet or drawer slides in from.
enum PalmUISheetSide {
  /// The top edge.
  top,

  /// The bottom edge, the usual choice on phones.
  bottom,

  /// The left edge.
  left,

  /// The right edge.
  right,
}

/// Shows a centred, fading dialog built by [builder].
///
/// Returns the value passed to [Navigator.pop]. Tapping the barrier closes the
/// dialog unless [barrierDismissible] is false.
Future<T?> showPalmUIDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    barrierColor: const Color(0x99000000),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final width = MediaQuery.sizeOf(dialogContext).width;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: math.min(480, width - 48)),
            child: builder(dialogContext),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(animation),
          child: child,
        ),
      );
    },
  );
}

/// A dialog surface with an optional title, content and action row.
///
/// Show it with [showPalmUIDialog].
class PalmUIDialog extends StatelessWidget {
  /// Creates a dialog.
  const PalmUIDialog({super.key, this.title, this.content, this.actions});

  /// The dialog heading.
  final Widget? title;

  /// The dialog body.
  final Widget? content;

  /// Buttons shown in a row at the bottom.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: theme.popover,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
        side: BorderSide(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              DefaultTextStyle(
                style: TextStyle(
                  color: theme.popoverForeground,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                child: title!,
              ),
            if (content != null) ...[
              const SizedBox(height: 8),
              DefaultTextStyle(
                style: TextStyle(color: theme.mutedForeground, fontSize: 14),
                child: content!,
              ),
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A confirmation dialog with cancel and confirm buttons.
///
/// Usually shown with [showPalmUIAlertDialog].
class PalmUIAlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  const PalmUIAlertDialog({
    super.key,
    required this.title,
    this.description,
    this.cancelLabel = 'Cancel',
    this.confirmLabel = 'Continue',
    this.onCancel,
    this.onConfirm,
    this.destructive = false,
  });

  /// The question or heading.
  final Widget title;

  /// Supporting text under [title].
  final Widget? description;

  /// The cancel button text. Defaults to `Cancel`.
  final String cancelLabel;

  /// The confirm button text. Defaults to `Continue`.
  final String confirmLabel;

  /// Called when the cancel button is tapped.
  final VoidCallback? onCancel;

  /// Called when the confirm button is tapped.
  final VoidCallback? onConfirm;

  /// Whether the confirm button uses the destructive style.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return PalmUIDialog(
      title: title,
      content: description,
      actions: [
        PalmUIButton(
          variant: PalmUIButtonVariant.outline,
          onPressed: onCancel,
          child: Text(cancelLabel),
        ),
        PalmUIButton(
          variant: destructive
              ? PalmUIButtonVariant.destructive
              : PalmUIButtonVariant.primary,
          onPressed: onConfirm,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

/// Shows a [PalmUIAlertDialog] and completes with true when confirmed,
/// false when cancelled, or null when dismissed.
Future<bool?> showPalmUIAlertDialog({
  required BuildContext context,
  required Widget title,
  Widget? description,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Continue',
  bool destructive = false,
}) {
  return showPalmUIDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return PalmUIAlertDialog(
        title: title,
        description: description,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        destructive: destructive,
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      );
    },
  );
}

/// Slides in a panel built by [builder] from the given [side].
///
/// Returns the value passed to [Navigator.pop].
Future<T?> showPalmUISheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  PalmUISheetSide side = PalmUISheetSide.bottom,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: const Color(0x99000000),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final size = MediaQuery.sizeOf(dialogContext);
      final horizontal =
          side == PalmUISheetSide.left || side == PalmUISheetSide.right;
      return Align(
        alignment: switch (side) {
          PalmUISheetSide.bottom => Alignment.bottomCenter,
          PalmUISheetSide.top => Alignment.topCenter,
          PalmUISheetSide.left => Alignment.centerLeft,
          PalmUISheetSide.right => Alignment.centerRight,
        },
        child: SizedBox(
          width: horizontal ? math.min(320, size.width * 0.88) : size.width,
          height: horizontal ? size.height : null,
          child: builder(dialogContext),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final begin = switch (side) {
        PalmUISheetSide.bottom => const Offset(0, 1),
        PalmUISheetSide.top => const Offset(0, -1),
        PalmUISheetSide.left => const Offset(-1, 0),
        PalmUISheetSide.right => const Offset(1, 0),
      };
      return FractionalTranslation(
        translation: Offset(
          begin.dx * (1 - animation.value),
          begin.dy * (1 - animation.value),
        ),
        child: child,
      );
    },
  );
}

/// The panel surface used by [showPalmUISheet], with corners rounded on the
/// edge facing the screen.
class PalmUISheet extends StatelessWidget {
  /// Creates a sheet.
  const PalmUISheet({
    super.key,
    required this.child,
    this.side = PalmUISheetSide.bottom,
  });

  /// The sheet content.
  final Widget child;

  /// The screen edge the sheet is attached to. Defaults to the bottom.
  final PalmUISheetSide side;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final radius = Radius.circular(theme.radius);
    final borderRadius = switch (side) {
      PalmUISheetSide.bottom => BorderRadius.vertical(top: radius),
      PalmUISheetSide.top => BorderRadius.vertical(bottom: radius),
      PalmUISheetSide.left => BorderRadius.horizontal(right: radius),
      PalmUISheetSide.right => BorderRadius.horizontal(left: radius),
    };
    return Material(
      color: theme.popover,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: theme.border),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

/// A side panel with an optional title, shown with [showPalmUIDrawer].
class PalmUIDrawer extends StatelessWidget {
  /// Creates a drawer.
  const PalmUIDrawer({super.key, required this.child, this.title});

  /// The drawer content.
  final Widget child;

  /// The drawer heading.
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return PalmUISheet(
      side: PalmUISheetSide.left,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            DefaultTextStyle(
              style: TextStyle(
                color: theme.popoverForeground,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              child: title!,
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

/// Slides in a [PalmUIDrawer] from [side], which defaults to the left.
Future<T?> showPalmUIDrawer<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  PalmUISheetSide side = PalmUISheetSide.left,
  Widget? title,
}) {
  return showPalmUISheet<T>(
    context: context,
    side: side,
    builder: (dialogContext) {
      return PalmUIDrawer(title: title, child: builder(dialogContext));
    },
  );
}

/// Shows [content] in a floating card below [trigger] when it is tapped.
/// Tap the trigger again to close it.
class PalmUIPopover extends StatefulWidget {
  /// Creates a popover.
  const PalmUIPopover({
    super.key,
    required this.trigger,
    required this.content,
  });

  /// The widget that opens the popover.
  final Widget trigger;

  /// The content of the floating card.
  final Widget content;

  @override
  State<PalmUIPopover> createState() => _PalmUIPopoverState();
}

class _PalmUIPopoverState extends State<PalmUIPopover> {
  final _layer = _PalmUIFloatLayer();

  @override
  void dispose() {
    _layer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _layer.toggle(
          context: context,
          child: _FloatCard(child: widget.content),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1,
          child: widget.trigger,
        ),
      ),
    );
  }
}

/// Shows a preview card with [content] below [trigger] when it is tapped.
/// Tap the trigger again to close it.
class PalmUIHoverCard extends StatefulWidget {
  /// Creates a hover card.
  const PalmUIHoverCard({
    super.key,
    required this.trigger,
    required this.content,
  });

  /// The widget that opens the card.
  final Widget trigger;

  /// The content of the floating card.
  final Widget content;

  @override
  State<PalmUIHoverCard> createState() => _PalmUIHoverCardState();
}

class _PalmUIHoverCardState extends State<PalmUIHoverCard> {
  final _layer = _PalmUIFloatLayer();

  @override
  void dispose() {
    _layer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _layer.toggle(
          context: context,
          child: _FloatCard(child: widget.content),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1,
          child: widget.trigger,
        ),
      ),
    );
  }
}

/// Shows [message] in a small floating card when [child] is tapped.
class PalmUITooltip extends StatefulWidget {
  /// Creates a tooltip.
  const PalmUITooltip({super.key, required this.message, required this.child});

  /// The tooltip text.
  final String message;

  /// The widget the tooltip describes.
  final Widget child;

  @override
  State<PalmUITooltip> createState() => _PalmUITooltipState();
}

class _PalmUITooltipState extends State<PalmUITooltip> {
  final _layer = _PalmUIFloatLayer();

  @override
  void dispose() {
    _layer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _layer.toggle(
          context: context,
          child: _FloatCard(child: Text(widget.message)),
        );
      },
      child: widget.child,
    );
  }
}

class _FloatCard extends StatelessWidget {
  const _FloatCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: theme.popover,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
        side: BorderSide(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DefaultTextStyle(
          style: TextStyle(color: theme.popoverForeground, fontSize: 14),
          child: child,
        ),
      ),
    );
  }
}

class _PalmUIFloatLayer {
  OverlayEntry? entry;

  void close() {
    entry?.remove();
    entry = null;
  }

  void toggle({required BuildContext context, required Widget child}) {
    if (entry != null) {
      close();
      return;
    }
    final box = context.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero);
    final overlay = Overlay.of(context);
    entry = OverlayEntry(
      builder: (overlayContext) {
        final screen = MediaQuery.sizeOf(overlayContext);
        final left = origin.dx
            .clamp(8.0, math.max(8.0, screen.width - 220))
            .toDouble();
        final top = origin.dy + box.size.height + 4;
        return Positioned(left: left, top: top, width: 220, child: child);
      },
    );
    overlay.insert(entry!);
  }
}

/// Hosts toasts for its subtree. Place it once near the top of the app,
/// for example in [MaterialApp.builder].
///
/// Show toasts with [PalmUIToast.show].
class PalmUIToaster extends StatefulWidget {
  /// Creates a toaster around [child].
  const PalmUIToaster({super.key, required this.child});

  /// The app content.
  final Widget child;

  /// The nearest toaster state above [context]. Asserts that one exists.
  static PalmUIToasterState of(BuildContext context) {
    final state = context.findAncestorStateOfType<PalmUIToasterState>();
    assert(
      state != null,
      'PalmUIToast.show requires a PalmUIToaster ancestor.',
    );
    return state!;
  }

  @override
  State<PalmUIToaster> createState() => PalmUIToasterState();
}

/// State for [PalmUIToaster]. Shows one toast at a time.
class PalmUIToasterState extends State<PalmUIToaster> {
  /// The message currently shown, or null when no toast is visible.
  String? message;

  /// Shows a toast with [value], replacing any current toast.
  void show(String value) => setState(() => message = value);

  /// Hides the current toast.
  void dismiss() => setState(() => message = null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (message != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: PalmUIToastCard(message: message!, onDismiss: dismiss),
          ),
      ],
    );
  }
}

/// Static helpers for showing toasts through the nearest [PalmUIToaster].
class PalmUIToast {
  const PalmUIToast._();

  /// Shows a toast with [message].
  static void show(BuildContext context, {required String message}) {
    PalmUIToaster.of(context).show(message);
  }

  /// Hides the current toast.
  static void dismiss(BuildContext context) {
    PalmUIToaster.of(context).dismiss();
  }
}

/// The card used to render a toast.
class PalmUIToastCard extends StatelessWidget {
  /// Creates a toast card.
  const PalmUIToastCard({super.key, required this.message, this.onDismiss});

  /// The toast text.
  final String message;

  /// Called by the dismiss button. When null no button is shown.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: theme.popover,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
        side: BorderSide(color: theme.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: theme.popoverForeground),
                ),
              ),
              if (onDismiss != null)
                PalmUIButton(
                  variant: PalmUIButtonVariant.ghost,
                  onPressed: onDismiss,
                  child: const Text('Dismiss'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
