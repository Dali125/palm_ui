import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';

/// A column in a [PalmUIDataTable].
class PalmUIDataColumn {
  /// Creates a column. [id] is the key into [PalmUIDataRow.cells].
  const PalmUIDataColumn({required this.id, required this.label});

  /// Key used to look up this column's value in each [PalmUIDataRow.cells].
  final String id;

  /// Header text shown for the column. Tapping it sorts the table.
  final String label;
}

/// A row in a [PalmUIDataTable].
class PalmUIDataRow {
  /// Creates a row from a map of column id to cell text.
  const PalmUIDataRow({required this.cells});

  /// Cell text keyed by [PalmUIDataColumn.id]. Missing keys render empty.
  final Map<String, String> cells;
}

/// A sortable, paginated table of text cells.
///
/// Tap a column header to sort by it, and tap again to reverse the order.
/// Values are compared as text.
class PalmUIDataTable extends StatefulWidget {
  /// Creates a data table with [columns] and [rows], showing [pageSize] rows
  /// per page.
  const PalmUIDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.pageSize = 5,
  });

  /// The columns, in display order.
  final List<PalmUIDataColumn> columns;

  /// All rows. The table sorts and paginates them itself.
  final List<PalmUIDataRow> rows;

  /// How many rows are shown per page. Defaults to 5.
  final int pageSize;

  @override
  State<PalmUIDataTable> createState() => _PalmUIDataTableState();
}

class _PalmUIDataTableState extends State<PalmUIDataTable> {
  String? _sortId;
  bool _ascending = true;
  int _page = 0;

  List<PalmUIDataRow> get _sorted {
    final rows = [...widget.rows];
    final id = _sortId;
    if (id == null) return rows;
    rows.sort((a, b) {
      final compare = (a.cells[id] ?? '').compareTo(b.cells[id] ?? '');
      return _ascending ? compare : -compare;
    });
    return rows;
  }

  void _sort(String id) {
    setState(() {
      if (_sortId == id) {
        _ascending = !_ascending;
      } else {
        _sortId = id;
        _ascending = true;
      }
      _page = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final sorted = _sorted;
    final pageSize = math.max(1, widget.pageSize);
    final pageCount = math.max(1, (sorted.length / pageSize).ceil());
    final page = _page.clamp(0, pageCount - 1);
    final start = page * pageSize;
    final end = math.min(start + pageSize, sorted.length);
    final visible = sorted.sublist(start, end);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              border: TableBorder(
                horizontalInside: BorderSide(color: theme.border),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: theme.muted),
                  children: [
                    for (final column in widget.columns)
                      InkWell(
                        onTap: () => _sort(column.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                column.label,
                                style: TextStyle(
                                  color: theme.foreground,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_sortId == column.id) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  _ascending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 14,
                                  color: theme.mutedForeground,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                for (final row in visible)
                  TableRow(
                    children: [
                      for (final column in widget.columns)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Text(
                            row.cells[column.id] ?? '',
                            style: TextStyle(color: theme.foreground),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              'Page ${page + 1} of $pageCount',
              style: TextStyle(color: theme.mutedForeground, fontSize: 13),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(
                      kPalmUIMinTouchTarget,
                      kPalmUIMinTouchTarget,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onPressed: page > 0
                      ? () => setState(() => _page = page - 1)
                      : null,
                  child: const Text('Previous'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(
                      kPalmUIMinTouchTarget,
                      kPalmUIMinTouchTarget,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onPressed: page < pageCount - 1
                      ? () => setState(() => _page = page + 1)
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
