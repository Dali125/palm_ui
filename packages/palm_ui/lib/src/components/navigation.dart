import 'package:flutter/material.dart';

import '../foundation/tap_target.dart';
import '../theme/palm_ui_theme.dart';
import 'menu.dart';

/// A section in a [PalmUIAccordion].
class PalmUIAccordionEntry {
  /// Creates an accordion section.
  const PalmUIAccordionEntry({required this.title, required this.content});

  /// The header that toggles the section.
  final Widget title;

  /// The content shown while the section is open.
  final Widget content;
}

/// A vertical list of collapsible sections.
class PalmUIAccordion extends StatefulWidget {
  /// Creates an accordion from [entries].
  const PalmUIAccordion({
    super.key,
    required this.entries,
    this.allowMultiple = false,
  });

  /// The sections, in order.
  final List<PalmUIAccordionEntry> entries;

  /// Whether several sections can be open at once. Defaults to false.
  final bool allowMultiple;

  @override
  State<PalmUIAccordion> createState() => _PalmUIAccordionState();
}

class _PalmUIAccordionState extends State<PalmUIAccordion> {
  final Set<int> _open = {};

  void _toggle(int index) {
    setState(() {
      if (_open.contains(index)) {
        _open.remove(index);
      } else {
        if (!widget.allowMultiple) _open.clear();
        _open.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.entries.length; i++)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.border)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => _toggle(i),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: kPalmUIMinTouchTarget,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: theme.foreground,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              child: widget.entries[i].title,
                            ),
                          ),
                          Icon(
                            _open.contains(i)
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: theme.mutedForeground,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_open.contains(i))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: theme.mutedForeground,
                        fontSize: 14,
                      ),
                      child: widget.entries[i].content,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A header that shows or hides [child] when tapped.
class PalmUICollapsible extends StatefulWidget {
  /// Creates a collapsible section.
  const PalmUICollapsible({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
  });

  /// The header that toggles the content.
  final Widget title;

  /// The content shown while open.
  final Widget child;

  /// Whether the content starts open. Defaults to false.
  final bool initiallyOpen;

  @override
  State<PalmUICollapsible> createState() => _PalmUICollapsibleState();
}

class _PalmUICollapsibleState extends State<PalmUICollapsible> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
            child: Row(
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: theme.foreground,
                      fontWeight: FontWeight.w500,
                    ),
                    child: widget.title,
                  ),
                ),
                Icon(
                  _open ? Icons.expand_less : Icons.expand_more,
                  color: theme.mutedForeground,
                ),
              ],
            ),
          ),
        ),
        if (_open) widget.child,
      ],
    );
  }
}

/// A single tab button, as used by [PalmUITabs].
///
/// It is announced as a selected or unselected button with its [label] and can
/// be activated with the keyboard.
class PalmUITab extends StatelessWidget {
  /// Creates a tab.
  const PalmUITab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  /// The tab text, also used as its accessibility label.
  final String label;

  /// Whether this is the current tab.
  final bool selected;

  /// Called when the tab is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return PalmUITapTarget(
      onTap: onTap,
      button: true,
      selected: selected,
      semanticLabel: label,
      excludeChildSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 64,
          minHeight: kPalmUIMinTouchTarget,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? theme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: selected
                      ? theme.accentForeground
                      : theme.mutedForeground,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A row of tabs that switches between [children].
class PalmUITabs extends StatefulWidget {
  /// Creates tabs. [tabs] and [children] must have the same length.
  const PalmUITabs({super.key, required this.tabs, required this.children});

  /// The tab labels.
  final List<String> tabs;

  /// The content for each tab, in the same order as [tabs].
  final List<Widget> children;

  @override
  State<PalmUITabs> createState() => _PalmUITabsState();
}

class _PalmUITabsState extends State<PalmUITabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final index = _index.clamp(0, widget.children.length - 1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.muted.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < widget.tabs.length; i++)
                  PalmUITab(
                    label: widget.tabs[i],
                    selected: i == index,
                    onTap: () => setState(() => _index = i),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        widget.children[index],
      ],
    );
  }
}

/// A link in a [PalmUIBreadcrumb].
class PalmUIBreadcrumbItem {
  /// Creates a breadcrumb item.
  const PalmUIBreadcrumbItem({required this.label, this.onTap});

  /// The item text.
  final String label;

  /// Called when the item is tapped. Leave null for the current page.
  final VoidCallback? onTap;
}

/// A horizontal trail of links that shows where the user is.
class PalmUIBreadcrumb extends StatelessWidget {
  /// Creates a breadcrumb from [items].
  const PalmUIBreadcrumb({super.key, required this.items});

  /// The trail, from the root to the current page.
  final List<PalmUIBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: theme.mutedForeground,
              ),
            ),
          GestureDetector(
            onTap: items[i].onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: kPalmUIMinTouchTarget,
              ),
              child: Align(
                widthFactor: 1,
                alignment: Alignment.centerLeft,
                child: Text(
                  items[i].label,
                  style: TextStyle(
                    color: i == items.length - 1
                        ? theme.foreground
                        : theme.mutedForeground,
                    fontWeight: i == items.length - 1
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Previous, numbered and next page buttons.
class PalmUIPagination extends StatelessWidget {
  /// Creates pagination controls.
  const PalmUIPagination({
    super.key,
    required this.page,
    required this.pageCount,
    required this.onPageChanged,
  });

  /// The current page, starting at 1.
  final int page;

  /// The total number of pages.
  final int pageCount;

  /// Called with the page the user picks.
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _PageButton(
            label: 'Prev',
            selected: false,
            onTap: page > 1 ? () => onPageChanged?.call(page - 1) : null,
          ),
          for (var i = 1; i <= pageCount; i++) ...[
            const SizedBox(width: 4),
            _PageButton(
              label: '$i',
              selected: i == page,
              onTap: () => onPageChanged?.call(i),
            ),
          ],
          const SizedBox(width: 4),
          _PageButton(
            label: 'Next',
            selected: false,
            onTap: page < pageCount
                ? () => onPageChanged?.call(page + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: kPalmUIMinTouchTarget,
          minHeight: kPalmUIMinTouchTarget,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? theme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: selected ? theme.primary : theme.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? theme.primaryForeground : theme.foreground,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A top-level menu in a [PalmUIMenubar].
class PalmUIMenuBarMenu {
  /// Creates a menubar menu.
  const PalmUIMenuBarMenu({required this.label, required this.items});

  /// The text shown in the bar.
  final String label;

  /// The entries shown when the menu opens.
  final List<PalmUIMenuItem> items;
}

/// A horizontal bar of menus, each opening a popup menu.
class PalmUIMenubar extends StatelessWidget {
  /// Creates a menubar.
  const PalmUIMenubar({super.key, required this.menus});

  /// The menus, in order.
  final List<PalmUIMenuBarMenu> menus;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final menu in menus)
              Builder(
                builder: (itemContext) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => showPalmUIMenu(
                      context: itemContext,
                      anchor: palmUIAnchorRect(itemContext),
                      items: menu.items,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: kPalmUIMinTouchTarget,
                        minHeight: kPalmUIMinTouchTarget,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            menu.label,
                            style: TextStyle(color: theme.foreground),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// An entry in a [PalmUINavigationMenu].
class PalmUINavMenuEntry {
  /// Creates a navigation menu entry.
  const PalmUINavMenuEntry({required this.label, required this.content});

  /// The text shown in the menu row.
  final String label;

  /// The panel shown when the entry is open.
  final Widget content;
}

/// A row of entries that each reveal a content panel below.
class PalmUINavigationMenu extends StatefulWidget {
  /// Creates a navigation menu.
  const PalmUINavigationMenu({super.key, required this.entries});

  /// The entries, in order.
  final List<PalmUINavMenuEntry> entries;

  @override
  State<PalmUINavigationMenu> createState() => _PalmUINavigationMenuState();
}

class _PalmUINavigationMenuState extends State<PalmUINavigationMenu> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < widget.entries.length; i++)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _open = _open == i ? null : i),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: kPalmUIMinTouchTarget,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Text(
                          widget.entries[i].label,
                          style: TextStyle(
                            color: _open == i
                                ? theme.foreground
                                : theme.mutedForeground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_open != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.popover,
                borderRadius: BorderRadius.circular(theme.radius),
                border: Border.all(color: theme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: widget.entries[_open!].content,
              ),
            ),
          ),
      ],
    );
  }
}

/// A destination in a [PalmUISidebar].
class PalmUISidebarEntry {
  /// Creates a sidebar entry.
  const PalmUISidebarEntry({required this.label, required this.icon});

  /// The entry text.
  final String label;

  /// The entry icon.
  final IconData icon;
}

/// A side navigation panel.
///
/// On screens at least [breakpoint] wide the panel is always shown; on
/// narrower screens it slides over [body] and is opened with a menu button.
class PalmUISidebar extends StatefulWidget {
  /// Creates a sidebar.
  const PalmUISidebar({
    super.key,
    required this.entries,
    required this.body,
    this.selectedIndex = 0,
    this.onSelected,
    this.breakpoint = 768,
  });

  /// The navigation entries.
  final List<PalmUISidebarEntry> entries;

  /// The main content beside or under the panel.
  final Widget body;

  /// The index of the current entry. Defaults to 0.
  final int selectedIndex;

  /// Called with the index of the entry the user taps.
  final ValueChanged<int>? onSelected;

  /// The width at which the panel is shown permanently. Defaults to 768.
  final double breakpoint;

  @override
  State<PalmUISidebar> createState() => _PalmUISidebarState();
}

class _PalmUISidebarState extends State<PalmUISidebar> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= widget.breakpoint;
    final panel = KeyedSubtree(
      key: const Key('shad-sidebar-panel'),
      child: _SidebarPanel(
        entries: widget.entries,
        selectedIndex: widget.selectedIndex,
        onSelected: (index) {
          widget.onSelected?.call(index);
          if (!wide) setState(() => _open = false);
        },
      ),
    );
    final body = SizedBox.expand(
      key: const Key('shad-sidebar-body'),
      child: widget.body,
    );
    if (wide) {
      return Row(
        children: [
          SizedBox(width: 240, child: panel),
          Expanded(child: body),
        ],
      );
    }
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: kPalmUIMinTouchTarget,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  key: const Key('shad-sidebar-trigger'),
                  tooltip: 'Open sidebar',
                  onPressed: () => setState(() => _open = true),
                  icon: const Icon(Icons.menu),
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
        if (_open) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _open = false),
              child: const ColoredBox(color: Color(0x66000000)),
            ),
          ),
          Positioned(left: 0, top: 0, bottom: 0, width: 260, child: panel),
        ],
      ],
    );
  }
}

class _SidebarPanel extends StatelessWidget {
  const _SidebarPanel({
    required this.entries,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PalmUISidebarEntry> entries;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: theme.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: theme.border)),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (var i = 0; i < entries.length; i++)
              InkWell(
                onTap: () => onSelected(i),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: kPalmUIMinTouchTarget,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(
                          entries[i].icon,
                          size: 18,
                          color: i == selectedIndex
                              ? theme.foreground
                              : theme.mutedForeground,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entries[i].label,
                            style: TextStyle(
                              color: i == selectedIndex
                                  ? theme.foreground
                                  : theme.mutedForeground,
                              fontWeight: i == selectedIndex
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A destination in a [PalmUIBottomNav].
class PalmUINavDestination {
  /// Creates a bottom navigation destination.
  const PalmUINavDestination({required this.icon, required this.label});

  /// The destination icon.
  final IconData icon;

  /// The destination label.
  final String label;
}

/// A single destination button in a [PalmUIBottomNav].
///
/// It fills its share of the bar, is announced as a selected or unselected
/// button with its [label], and can be activated with the keyboard.
class PalmUIBottomNavItem extends StatelessWidget {
  /// Creates a bottom navigation item.
  const PalmUIBottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  /// The icon shown above the label.
  final IconData icon;

  /// The text under the icon, also used as the accessibility label.
  final String label;

  /// Whether this is the current destination.
  final bool selected;

  /// Called when the item is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final color = selected ? theme.foreground : theme.mutedForeground;
    return Expanded(
      child: PalmUITapTarget(
        onTap: onTap,
        button: true,
        selected: selected,
        semanticLabel: label,
        excludeChildSemantics: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// A bottom navigation bar for switching between top-level screens.
class PalmUIBottomNav extends StatelessWidget {
  /// Creates a bottom navigation bar.
  const PalmUIBottomNav({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  /// The destinations, in order.
  final List<PalmUINavDestination> destinations;

  /// The index of the current destination.
  final int selectedIndex;

  /// Called with the index of the destination the user taps.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: theme.background,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.border)),
        ),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                PalmUIBottomNavItem(
                  icon: destinations[i].icon,
                  label: destinations[i].label,
                  selected: i == selectedIndex,
                  onTap: () => onSelected(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
