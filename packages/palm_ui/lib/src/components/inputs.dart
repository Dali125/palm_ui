import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';
import 'menu.dart';

class PalmUILabel extends StatelessWidget {
  const PalmUILabel({super.key, required this.child});

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

class PalmUIField extends StatelessWidget {
  const PalmUIField({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.error,
  });

  final Widget child;
  final Widget? label;
  final String? hint;
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

class PalmUIInput extends StatelessWidget {
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

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;
  final bool bordered;
  final EdgeInsetsGeometry contentPadding;
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

class PalmUITextarea extends StatelessWidget {
  const PalmUITextarea({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.minLines = 4,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final int minLines;
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

class PalmUIInputGroup extends StatelessWidget {
  const PalmUIInputGroup({
    super.key,
    required this.child,
    this.prefix,
    this.suffix,
  });

  final Widget child;
  final Widget? prefix;
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

class PalmUIInputOtp extends StatefulWidget {
  const PalmUIInputOtp({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
  });

  final int length;
  final ValueChanged<String>? onChanged;
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
      final next = mathMin(index + chars.length, widget.length - 1);
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

int mathMin(int a, int b) => a < b ? a : b;

class PalmUICheckbox extends StatelessWidget {
  const PalmUICheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged?.call(!value),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
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

class PalmUIRadioGroup<T> extends StatelessWidget {
  const PalmUIRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.children,
  });

  final T? value;
  final ValueChanged<T>? onChanged;
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

class PalmUIRadio<T> extends StatelessWidget {
  const PalmUIRadio({super.key, required this.value, required this.label});

  final T value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scope = _PalmUIRadioScope.maybeOf<T>(context);
    final selected = scope?.value == value;
    final theme = PalmUITheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => scope?.onChanged?.call(value),
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

class PalmUISwitch extends StatelessWidget {
  const PalmUISwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged?.call(!value),
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

class PalmUISlider extends StatelessWidget {
  const PalmUISlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
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

class PalmUIToggle extends StatelessWidget {
  const PalmUIToggle({
    super.key,
    required this.pressed,
    required this.onPressed,
    required this.child,
  });

  final bool pressed;
  final VoidCallback? onPressed;
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

class PalmUIToggleGroup extends StatelessWidget {
  const PalmUIToggleGroup({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final List<String> items;
  final String? selected;
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

class PalmUISelectItem<T> {
  const PalmUISelectItem({required this.value, required this.label});

  final T value;
  final String label;
}

class PalmUISelect<T> extends StatelessWidget {
  const PalmUISelect({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = 'Select',
  });

  final List<PalmUISelectItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
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

class PalmUICombobox extends StatefulWidget {
  const PalmUICombobox({
    super.key,
    required this.options,
    this.onSelected,
    this.hint = 'Search',
    this.value,
  });

  final List<String> options;
  final ValueChanged<String>? onSelected;
  final String hint;
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

class PalmUICommandItem {
  const PalmUICommandItem({required this.label, this.group});

  final String label;
  final String? group;
}

class PalmUICommand extends StatefulWidget {
  const PalmUICommand({super.key, required this.items, this.onSelected});

  final List<PalmUICommandItem> items;
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
