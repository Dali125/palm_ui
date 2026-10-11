import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';
import 'button.dart';

enum PalmUISheetSide { top, bottom, left, right }

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

class PalmUIDialog extends StatelessWidget {
  const PalmUIDialog({super.key, this.title, this.content, this.actions});

  final Widget? title;
  final Widget? content;
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

class PalmUIAlertDialog extends StatelessWidget {
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

  final Widget title;
  final Widget? description;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
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

class PalmUISheet extends StatelessWidget {
  const PalmUISheet({
    super.key,
    required this.child,
    this.side = PalmUISheetSide.bottom,
  });

  final Widget child;
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

class PalmUIDrawer extends StatelessWidget {
  const PalmUIDrawer({super.key, required this.child, this.title});

  final Widget child;
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

class PalmUIPopover extends StatefulWidget {
  const PalmUIPopover({
    super.key,
    required this.trigger,
    required this.content,
  });

  final Widget trigger;
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

class PalmUIHoverCard extends StatefulWidget {
  const PalmUIHoverCard({
    super.key,
    required this.trigger,
    required this.content,
  });

  final Widget trigger;
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

class PalmUITooltip extends StatefulWidget {
  const PalmUITooltip({super.key, required this.message, required this.child});

  final String message;
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

class PalmUIToaster extends StatefulWidget {
  const PalmUIToaster({super.key, required this.child});

  final Widget child;

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

class PalmUIToasterState extends State<PalmUIToaster> {
  String? message;

  void show(String value) => setState(() => message = value);

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

class PalmUIToast {
  const PalmUIToast._();

  static void show(BuildContext context, {required String message}) {
    PalmUIToaster.of(context).show(message);
  }

  static void dismiss(BuildContext context) {
    PalmUIToaster.of(context).dismiss();
  }
}

class PalmUIToastCard extends StatelessWidget {
  const PalmUIToastCard({super.key, required this.message, this.onDismiss});

  final String message;
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
