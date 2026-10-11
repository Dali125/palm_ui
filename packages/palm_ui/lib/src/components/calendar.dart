import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';
import 'button.dart';
import 'overlays.dart';

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String formatPalmUIDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

bool palmUISameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class PalmUICalendar extends StatefulWidget {
  const PalmUICalendar({
    super.key,
    this.selected,
    this.onSelected,
    this.initialMonth,
  });

  final DateTime? selected;
  final ValueChanged<DateTime>? onSelected;
  final DateTime? initialMonth;

  @override
  State<PalmUICalendar> createState() => _PalmUICalendarState();
}

class _PalmUICalendarState extends State<PalmUICalendar> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialMonth ?? widget.selected ?? DateTime.now();
    _month = DateTime(initial.year, initial.month);
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final first = DateTime(_month.year, _month.month, 1);
    final leading = first.weekday % 7;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final cells = <Widget>[];
    for (var i = 0; i < leading; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_month.year, _month.month, day);
      final selected =
          widget.selected != null && palmUISameDay(widget.selected!, date);
      cells.add(
        _DayCell(
          day: day,
          selected: selected,
          onTap: () => widget.onSelected?.call(date),
        ),
      );
    }
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Previous month',
              onPressed: () => setState(() {
                _month = DateTime(_month.year, _month.month - 1);
              }),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                '${_months[_month.month - 1]} ${_month.year}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Next month',
              onPressed: () => setState(() {
                _month = DateTime(_month.year, _month.month + 1);
              }),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        Row(
          children: [
            for (final label in const [
              'Su',
              'Mo',
              'Tu',
              'We',
              'Th',
              'Fr',
              'Sa',
            ])
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (var row = 0; row < cells.length ~/ 7; row++)
          Row(
            children: [
              for (var column = 0; column < 7; column++)
                Expanded(child: cells[row * 7 + column]),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: kPalmUIMinTouchTarget,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? theme.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: selected
                        ? theme.primaryForeground
                        : theme.foreground,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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

class PalmUIDatePicker extends StatefulWidget {
  const PalmUIDatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.placeholder = 'Pick a date',
    this.initialMonth,
  });

  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final String placeholder;
  final DateTime? initialMonth;

  @override
  State<PalmUIDatePicker> createState() => _PalmUIDatePickerState();
}

class _PalmUIDatePickerState extends State<PalmUIDatePicker> {
  Future<void> _open() async {
    final picked = await showPalmUIDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return PalmUIDialog(
          title: const Text('Pick a date'),
          content: PalmUICalendar(
            selected: widget.value,
            initialMonth: widget.initialMonth ?? widget.value,
            onSelected: (date) => Navigator.of(dialogContext).pop(date),
          ),
        );
      },
    );
    if (!mounted || picked == null) return;
    widget.onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.value == null
        ? widget.placeholder
        : formatPalmUIDate(widget.value!);
    return PalmUIButton(
      variant: PalmUIButtonVariant.outline,
      onPressed: _open,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
