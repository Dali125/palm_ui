import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/palm_ui_theme.dart';

/// Internal building block for Palm UI's custom tappable controls.
///
/// Not exported from `package:palm_ui/palm_ui.dart`. It combines:
///
/// * a single [Semantics] node describing the control (its role, state,
///   enabled flag and label) so screen readers announce it correctly,
/// * keyboard focus and activation with Enter or Space through
///   [FocusableActionDetector],
/// * a visible focus ring drawn in [PalmUIThemeData.ring] while the control
///   has keyboard focus, and
/// * an opaque tap area.
///
/// When [onTap] is null the control is reported as disabled, is skipped by
/// focus traversal, and ignores taps.
class PalmUITapTarget extends StatefulWidget {
  /// Creates an accessible tap target around [child].
  const PalmUITapTarget({
    super.key,
    required this.child,
    required this.onTap,
    this.semanticLabel,
    this.excludeChildSemantics = false,
    this.button = false,
    this.checked,
    this.toggled,
    this.selected,
    this.inMutuallyExclusiveGroup = false,
    this.borderRadius,
  });

  /// The visual content of the control.
  final Widget child;

  /// Called when the control is tapped or activated from the keyboard.
  /// A null value disables the control.
  final VoidCallback? onTap;

  /// The label announced by assistive technologies.
  final String? semanticLabel;

  /// Whether to drop the semantics of [child], for example when [child]
  /// paints the same text as [semanticLabel].
  final bool excludeChildSemantics;

  /// Whether the control should be announced as a button.
  final bool button;

  /// The checked state for checkbox and radio style controls, or null when
  /// the control has no checked state.
  final bool? checked;

  /// The on/off state for switch style controls, or null when the control
  /// has no toggled state.
  final bool? toggled;

  /// The selected state for tabs and navigation items, or null when the
  /// control has no selected state.
  final bool? selected;

  /// Whether only one control in the surrounding group can be checked at a
  /// time, as for radio buttons.
  final bool inMutuallyExclusiveGroup;

  /// The radius of the focus ring. Defaults to the theme radius.
  final BorderRadius? borderRadius;

  @override
  State<PalmUITapTarget> createState() => _PalmUITapTargetState();
}

class _PalmUITapTargetState extends State<PalmUITapTarget> {
  bool _focused = false;

  late final Map<Type, Action<Intent>> _actions = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (_) => _activate(),
    ),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: (_) => _activate(),
    ),
  };

  static const Map<ShortcutActivator, Intent> _shortcuts =
      <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      };

  Object? _activate() {
    widget.onTap?.call();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final enabled = widget.onTap != null;
    Widget child = widget.child;
    if (widget.excludeChildSemantics) {
      child = ExcludeSemantics(child: child);
    }
    return Semantics(
      container: true,
      button: widget.button,
      enabled: enabled,
      checked: widget.checked,
      toggled: widget.toggled,
      selected: widget.selected,
      inMutuallyExclusiveGroup: widget.inMutuallyExclusiveGroup ? true : null,
      label: widget.semanticLabel,
      onTap: widget.onTap,
      child: FocusableActionDetector(
        enabled: enabled,
        actions: _actions,
        shortcuts: _shortcuts,
        mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onShowFocusHighlight: (value) {
          if (value != _focused) setState(() => _focused = value);
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: widget.onTap,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius:
                  widget.borderRadius ?? BorderRadius.circular(theme.radius),
              border: _focused && enabled
                  ? Border.all(color: theme.ring, width: 2)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
