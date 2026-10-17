import 'package:flutter/material.dart';

import '../foundation/tap_target.dart';
import '../theme/palm_ui_theme.dart';
import 'menu.dart';

/// Applies the Palm UI label style to [child].
class PalmUILabel extends StatelessWidget {
  /// Creates a label.
  const PalmUILabel({super.key, required this.child});

  /// The label content, usually a [Text].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return DefaultTextStyle(
      style: TextStyle(
        color: theme.foreground,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      child: child,
    );
  }
}

/// A form field layout: a label, the control, and a hint or error message.
class PalmUIField extends StatelessWidget {
  /// Creates a field around the control [child].
  const PalmUIField({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.error,
  });

  /// The form control, such as a [PalmUIInput].
  final Widget child;

  /// The label shown above the control.
  final Widget? label;

  /// Helper text shown under the control when there is no [error].
  final String? hint;

  /// An error message shown under the control in the destructive color.
  /// Replaces [hint] when not empty.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          PalmUILabel(child: label!),
          const SizedBox(height: 6),
        ],
        child,
        if (hint != null && (error == null || error!.isEmpty)) ...[
          const SizedBox(height: 6),
          Text(
            hint!,
            style: TextStyle(color: theme.mutedForeground, fontSize: 12),
          ),
        ],
        if (error != null && error!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            error!,
            style: TextStyle(color: theme.destructive, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

/// A themed single or multi-line text input.
class PalmUIInput extends StatelessWidget {
  /// Creates a text input.
  const PalmUIInput({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.focusNode,
    this.maxLines = 1,
    this.onSubmitted,
    this.bordered = true,
    this.textAlign = TextAlign.start,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Placeholder text shown when the input is empty.
  final String? hint;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Whether to hide the text, for passwords. Forces a single line.
  final bool obscureText;

  /// Whether the input accepts input. Defaults to true.
  final bool enabled;

  /// The type of keyboard to show.
  final TextInputType? keyboardType;

  /// The focus node for the input.
  final FocusNode? focusNode;

  /// The maximum number of lines. Defaults to 1.
  final int maxLines;

  /// Called when the user submits from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Whether to draw the input border. Defaults to true.
  final bool bordered;

  /// Padding around the text inside the input.
  final EdgeInsetsGeometry contentPadding;

  /// How the text is aligned horizontally.
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final radius = BorderRadius.circular(theme.radius);
    final border = bordered
        ? OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: theme.input),
          )
        : const OutlineInputBorder(borderSide: BorderSide.none);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      textAlign: textAlign,
      style: TextStyle(color: theme.foreground, fontSize: 14),
      cursorColor: theme.ring,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: theme.background,
        hintText: hint,
        hintStyle: TextStyle(color: theme.mutedForeground),
        contentPadding: contentPadding,
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: theme.ring, width: 2),
        ),
      ),
    );
  }
}

/// A multi-line [PalmUIInput] for longer text.
class PalmUITextarea extends StatelessWidget {
  /// Creates a textarea.
  const PalmUITextarea({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.minLines = 4,
    this.enabled = true,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Placeholder text shown when the textarea is empty.
  final String? hint;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// The visible number of lines. Defaults to 4.
  final int minLines;

  /// Whether the textarea accepts input. Defaults to true.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PalmUIInput(
      controller: controller,
      hint: hint,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: minLines,
      keyboardType: TextInputType.multiline,
    );
  }
}

/// A bordered row that places a [prefix] and [suffix] around an input.
class PalmUIInputGroup extends StatelessWidget {
  /// Creates an input group around [child].
  const PalmUIInputGroup({
    super.key,
    required this.child,
    this.prefix,
    this.suffix,
  });

  /// The input, usually a [PalmUIInput] with `bordered: false`.
  final Widget child;

  /// A widget before the input, such as an icon or currency symbol.
  final Widget? prefix;

  /// A widget after the input, such as a unit or button.
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(color: theme.input),
      ),
      child: Row(
        children: [
          if (prefix != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: IconTheme(
                data: IconThemeData(color: theme.mutedForeground, size: 18),
                child: DefaultTextStyle(
                  style: TextStyle(color: theme.mutedForeground, fontSize: 14),
                  child: prefix!,
                ),
              ),
            ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
              child: child,
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: IconTheme(
                data: IconThemeData(color: theme.mutedForeground, size: 18),
                child: DefaultTextStyle(
                  style: TextStyle(color: theme.mutedForeground, fontSize: 14),
                  child: suffix!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A row of single-character boxes for one-time codes.
///
/// Focus moves to the next box as the user types, and pasted codes are spread
/// across the boxes.
class PalmUIInputOtp extends StatefulWidget {
  /// Creates a one-time code input with [length] boxes.
  const PalmUIInputOtp({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
  });

  /// The number of characters. Defaults to 6.
  final int length;

  /// Called with the current code whenever a box changes.
  final ValueChanged<String>? onChanged;

  /// Called with the full code once every box is filled.
  final ValueChanged<String>? onCompleted;

  @override
  State<PalmUIInputOtp> createState() => _PalmUIInputOtpState();
}

class _PalmUIInputOtpState extends State<PalmUIInputOtp> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((controller) => controller.text).join();

  void _emit() {
    final value = _value;
    widget.onChanged?.call(value);
    if (value.length == widget.length &&
        _controllers.every((controller) => controller.text.isNotEmpty)) {
      widget.onCompleted?.call(value);
    }
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      final chars = value.replaceAll(RegExp(r'\s'), '').split('');
      for (var i = 0; i < chars.length && index + i < widget.length; i++) {
        _controllers[index + i].text = chars[i];
      }
      final next = _min(index + chars.length, widget.length - 1);
      _nodes[next].requestFocus();
      _emit();
      return;
    }
    if (value.isNotEmpty && index + 1 < widget.length) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          SizedBox(
            width: kPalmUIMinTouchTarget,
            child: PalmUIInput(
              controller: _controllers[i],
              focusNode: _nodes[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              onChanged: (value) => _onChanged(i, value),
            ),
          ),
        ],
      ],
    );
  }
}

int _min(int a, int b) => a < b ? a : b;

/// A themed checkbox with an optional text label.
///
/// The whole row, label included, is the tap target. It is announced as a
/// checkbox with its checked state and label, and can be toggled with the
/// keyboard. It is disabled when [onChanged] is null.
class PalmUICheckbox extends StatelessWidget {
  /// Creates a checkbox.
  const PalmUICheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.semanticLabel,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Called with the new value when the user toggles the checkbox. A null
  /// value disables it.
  final ValueChanged<bool>? onChanged;

  /// Text shown next to the box and used as the accessibility label.
  final String? label;

  /// A screen reader label to use instead of [label], for example when the
  /// checkbox has no visible label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final onChanged = this.onChanged;
    return PalmUITapTarget(
      onTap: onChanged == null ? null : () => onChanged(!value),
      checked: value,
      semanticLabel: semanticLabel ?? label,
      excludeChildSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: kPalmUIMinTouchTarget,
          minHeight: kPalmUIMinTouchTarget,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: value ? theme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: value ? theme.primary : theme.border,
                  width: 1.5,
                ),
              ),
              child: value
                  ? Icon(Icons.check, size: 14, color: theme.primaryForeground)
                  : null,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label!,
                  style: TextStyle(color: theme.foreground, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Groups [PalmUIRadio] buttons that share one selected [value].
class PalmUIRadioGroup<T> extends StatelessWidget {
  /// Creates a radio group.
  const PalmUIRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.children,
  });

  /// The selected value, or null when nothing is selected.
  final T? value;

  /// Called with the value of the radio the user selects. A null value
  /// disables every radio in the group.
  final ValueChanged<T>? onChanged;

  /// The group content, usually [PalmUIRadio] widgets.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _PalmUIRadioScope<T>(
      value: value,
      onChanged: onChanged,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _PalmUIRadioScope<T> extends InheritedWidget {
  const _PalmUIRadioScope({
    required this.value,
    required this.onChanged,
    required super.child,
  });

  final T? value;
  final ValueChanged<T>? onChanged;

  static _PalmUIRadioScope<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PalmUIRadioScope<T>>();
  }

  @override
  bool updateShouldNotify(_PalmUIRadioScope<T> oldWidget) =>
      oldWidget.value != value;
}

/// A radio button with a text label, used inside a [PalmUIRadioGroup].
///
/// It is announced as a radio button with its checked state and [label].
class PalmUIRadio<T> extends StatelessWidget {
  /// Creates a radio button for [value].
  const PalmUIRadio({super.key, required this.value, required this.label});

  /// The value this radio represents. It is checked when it equals the
  /// group's value.
  final T value;

  /// Text shown next to the radio and used as its accessibility label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final scope = _PalmUIRadioScope.maybeOf<T>(context);
    final selected = scope?.value == value;
    final theme = PalmUITheme.of(context);
    final onChanged = scope?.onChanged;
    return PalmUITapTarget(
      onTap: onChanged == null ? null : () => onChanged(value),
      checked: selected,
      inMutuallyExclusiveGroup: true,
      semanticLabel: label,
      excludeChildSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: kPalmUIMinTouchTarget,
          minHeight: kPalmUIMinTouchTarget,
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? theme.primary : theme.border,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: theme.foreground, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A themed on/off switch.
///
/// It is announced as a switch with its on/off state and can be toggled with the
/// keyboard. It is disabled when [onChanged] is null. Give it a
/// [semanticLabel], or put it next to a text label, so screen reader users know
/// what it controls.
class PalmUISwitch extends StatelessWidget {
  /// Creates a switch.
  const PalmUISwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value when the user toggles the switch. A null value
  /// disables it.
  final ValueChanged<bool>? onChanged;

  /// The label announced by screen readers, for example `Notifications`.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final onChanged = this.onChanged;
    return PalmUITapTarget(
      onTap: onChanged == null ? null : () => onChanged(!value),
      toggled: value,
      semanticLabel: semanticLabel,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 52,
        height: kPalmUIMinTouchTarget,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44,
            height: 24,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value ? theme.primary : theme.muted,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: value ? theme.primary : theme.border),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: value ? theme.primaryForeground : theme.background,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A themed slider for choosing a value between [min] and [max].
class PalmUISlider extends StatelessWidget {
  /// Creates a slider.
  const PalmUISlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
  });

  /// The current value. It is clamped to the [min] to [max] range.
  final double value;

  /// Called while the user drags. A null value disables the slider.
  final ValueChanged<double>? onChanged;

  /// The smallest value. Defaults to 0.
  final double min;

  /// The largest value. Defaults to 1.
  final double max;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return SizedBox(
      height: 48,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: theme.primary,
          inactiveTrackColor: theme.muted,
          thumbColor: theme.background,
          overlayColor: theme.ring.withValues(alpha: 0.2),
          trackHeight: 6,
        ),
        child: Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// A two-state button that stays highlighted while [pressed].
class PalmUIToggle extends StatelessWidget {
  /// Creates a toggle button.
  const PalmUIToggle({
    super.key,
    required this.pressed,
    required this.onPressed,
    required this.child,
  });

  /// Whether the toggle is currently on.
  final bool pressed;

  /// Called when the toggle is tapped. A null value disables it.
  final VoidCallback? onPressed;

  /// The toggle content, usually an icon or short text.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: pressed ? theme.accent : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
        side: BorderSide(color: pressed ? theme.border : Colors.transparent),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(theme.radius),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: kPalmUIMinTouchTarget,
            minHeight: kPalmUIMinTouchTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconTheme(
              data: IconThemeData(color: theme.foreground, size: 18),
              child: DefaultTextStyle(
                style: TextStyle(color: theme.foreground, fontSize: 14),
                child: Center(widthFactor: 1, heightFactor: 1, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A row of [PalmUIToggle] buttons where one item is selected.
class PalmUIToggleGroup extends StatelessWidget {
  /// Creates a toggle group from [items].
  const PalmUIToggleGroup({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  /// The item labels.
  final List<String> items;

  /// The selected item, or null when none is selected.
  final String? selected;

  /// Called with the item the user taps.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            PalmUIToggle(
              pressed: selected == items[i],
              onPressed: () => onChanged?.call(items[i]),
              child: Text(items[i]),
            ),
          ],
        ],
      ),
    );
  }
}

/// An option in a [PalmUISelect].
class PalmUISelectItem<T> {
  /// Creates an option with a [value] and display [label].
  const PalmUISelectItem({required this.value, required this.label});

  /// The value passed to [PalmUISelect.onChanged] when picked.
  final T value;

  /// The text shown for the option.
  final String label;
}

/// A dropdown that lets the user choose one of [items] from a menu.
class PalmUISelect<T> extends StatelessWidget {
  /// Creates a select.
  const PalmUISelect({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = 'Select',
  });

  /// The options shown in the menu.
  final List<PalmUISelectItem<T>> items;

  /// The selected value, or null to show [hint].
  final T? value;

  /// Called with the value of the option the user picks.
  final ValueChanged<T>? onChanged;

  /// Text shown when no value is selected. Defaults to `Select`.
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    String label = hint;
    for (final item in items) {
      if (item.value == value) {
        label = item.label;
        break;
      }
    }
    return _SelectTrigger(
      label: label,
      showHint: value == null,
      onTap: (rect) {
        showPalmUIMenu(
          context: context,
          anchor: rect,
          items: [
            for (final item in items)
              PalmUIMenuItem(
                label: item.label,
                onSelected: () => onChanged?.call(item.value),
              ),
          ],
        );
      },
      border: theme.input,
      radius: theme.radius,
      foreground: theme.foreground,
      muted: theme.mutedForeground,
    );
  }
}

class _SelectTrigger extends StatelessWidget {
  const _SelectTrigger({
    required this.label,
    required this.showHint,
    required this.onTap,
    required this.border,
    required this.radius,
    required this.foreground,
    required this.muted,
  });

  final String label;
  final bool showHint;
  final void Function(Rect anchor) onTap;
  final Color border;
  final double radius;
  final Color foreground;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(palmUIAnchorRect(context)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(color: showHint ? muted : foreground),
                  ),
                ),
                Icon(Icons.expand_more, color: muted, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A text input that filters [options] as the user types.
class PalmUICombobox extends StatefulWidget {
  /// Creates a combobox.
  const PalmUICombobox({
    super.key,
    required this.options,
    this.onSelected,
    this.hint = 'Search',
    this.value,
  });

  /// All options to search.
  final List<String> options;

  /// Called with the option the user picks.
  final ValueChanged<String>? onSelected;

  /// Placeholder text for the search input. Defaults to `Search`.
  final String hint;

  /// The initial text of the search input.
  final String? value;

  @override
  State<PalmUICombobox> createState() => _PalmUIComboboxState();
}

class _PalmUIComboboxState extends State<PalmUICombobox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final matches = widget.options
        .where((option) => option.toLowerCase().contains(query))
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PalmUIInput(
          controller: _controller,
          hint: widget.hint,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        for (final option in matches)
          _OptionTile(
            label: option,
            onTap: () {
              _controller.text = option;
              widget.onSelected?.call(option);
              setState(() {});
            },
          ),
        if (matches.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No results'),
          ),
      ],
    );
  }
}

/// An entry in a [PalmUICommand] palette.
class PalmUICommandItem {
  /// Creates a command item.
  const PalmUICommandItem({required this.label, this.group});

  /// The command text, also used for searching.
  final String label;

  /// An optional group name for the command.
  final String? group;
}

/// A searchable command palette.
class PalmUICommand extends StatefulWidget {
  /// Creates a command palette with [items].
  const PalmUICommand({super.key, required this.items, this.onSelected});

  /// The commands to search.
  final List<PalmUICommandItem> items;

  /// Called with the command the user picks.
  final ValueChanged<PalmUICommandItem>? onSelected;

  @override
  State<PalmUICommand> createState() => _PalmUICommandState();
}

class _PalmUICommandState extends State<PalmUICommand> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final query = _controller.text.trim().toLowerCase();
    final matches = widget.items
        .where((item) => item.label.toLowerCase().contains(query))
        .toList();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.popover,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PalmUIInput(
            controller: _controller,
            hint: 'Type a command',
            onChanged: (_) => setState(() {}),
          ),
          for (final item in matches)
            _OptionTile(
              label: item.label,
              onTap: () => widget.onSelected?.call(item),
            ),
          if (matches.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'No results',
                style: TextStyle(color: theme.mutedForeground),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(label, style: TextStyle(color: theme.foreground)),
          ),
        ),
      ),
    );
  }
}
