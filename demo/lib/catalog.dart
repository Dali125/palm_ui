import 'package:flutter/material.dart';
import 'package:palm_ui/palm_ui.dart';

class ShowcaseEntry {
  const ShowcaseEntry(this.name, this.builder);

  final String name;
  final WidgetBuilder builder;
}

final List<ShowcaseEntry> kShowcases = [
  ShowcaseEntry('Accordion', (_) => const _AccordionDemo()),
  ShowcaseEntry('Alert', (_) => const _AlertDemo()),
  ShowcaseEntry('Alert Dialog', (_) => const _AlertDialogDemo()),
  ShowcaseEntry('Aspect Ratio', (_) => const _AspectRatioDemo()),
  ShowcaseEntry('Avatar', (_) => const _AvatarDemo()),
  ShowcaseEntry('Badge', (_) => const _BadgeDemo()),
  ShowcaseEntry('Breadcrumb', (_) => const _BreadcrumbDemo()),
  ShowcaseEntry('Button', (_) => const _ButtonDemo()),
  ShowcaseEntry('Button Group', (_) => const _ButtonGroupDemo()),
  ShowcaseEntry('Calendar', (_) => const _CalendarDemo()),
  ShowcaseEntry('Card', (_) => const _CardDemo()),
  ShowcaseEntry('Carousel', (_) => const _CarouselDemo()),
  ShowcaseEntry('Checkbox', (_) => const _CheckboxDemo()),
  ShowcaseEntry('Collapsible', (_) => const _CollapsibleDemo()),
  ShowcaseEntry('Combobox', (_) => const _ComboboxDemo()),
  ShowcaseEntry('Command', (_) => const _CommandDemo()),
  ShowcaseEntry('Context Menu', (_) => const _ContextMenuDemo()),
  ShowcaseEntry('Data Table', (_) => const _DataTableDemo()),
  ShowcaseEntry('Date Picker', (_) => const _DatePickerDemo()),
  ShowcaseEntry('Dialog', (_) => const _DialogDemo()),
  ShowcaseEntry('Drawer', (_) => const _DrawerDemo()),
  ShowcaseEntry('Dropdown Menu', (_) => const _DropdownDemo()),
  ShowcaseEntry('Empty', (_) => const _EmptyDemo()),
  ShowcaseEntry('Field', (_) => const _FieldDemo()),
  ShowcaseEntry('Hover Card', (_) => const _HoverCardDemo()),
  ShowcaseEntry('Input', (_) => const _InputDemo()),
  ShowcaseEntry('Input Group', (_) => const _InputGroupDemo()),
  ShowcaseEntry('Input OTP', (_) => const _OtpDemo()),
  ShowcaseEntry('Item', (_) => const _ItemDemo()),
  ShowcaseEntry('Kbd', (_) => const _KbdDemo()),
  ShowcaseEntry('Label', (_) => const _LabelDemo()),
  ShowcaseEntry('Menubar', (_) => const _MenubarDemo()),
  ShowcaseEntry('Navigation Menu', (_) => const _NavigationMenuDemo()),
  ShowcaseEntry('Pagination', (_) => const _PaginationDemo()),
  ShowcaseEntry('Popover', (_) => const _PopoverDemo()),
  ShowcaseEntry('Progress', (_) => const _ProgressDemo()),
  ShowcaseEntry('Radio Group', (_) => const _RadioDemo()),
  ShowcaseEntry('Scroll Area', (_) => const _ScrollAreaDemo()),
  ShowcaseEntry('Select', (_) => const _SelectDemo()),
  ShowcaseEntry('Separator', (_) => const _SeparatorDemo()),
  ShowcaseEntry('Sheet', (_) => const _SheetDemo()),
  ShowcaseEntry('Sidebar', (_) => const _SidebarDemo()),
  ShowcaseEntry('Skeleton', (_) => const _SkeletonDemo()),
  ShowcaseEntry('Slider', (_) => const _SliderDemo()),
  ShowcaseEntry('Spinner', (_) => const _SpinnerDemo()),
  ShowcaseEntry('Switch', (_) => const _SwitchDemo()),
  ShowcaseEntry('Table', (_) => const _TableDemo()),
  ShowcaseEntry('Tabs', (_) => const _TabsDemo()),
  ShowcaseEntry('Textarea', (_) => const _TextareaDemo()),
  ShowcaseEntry('Toast', (_) => const _ToastDemo()),
  ShowcaseEntry('Toggle', (_) => const _ToggleDemo()),
  ShowcaseEntry('Toggle Group', (_) => const _ToggleGroupDemo()),
  ShowcaseEntry('Tooltip', (_) => const _TooltipDemo()),
  ShowcaseEntry('Typography', (_) => const _TypographyDemo()),
  ShowcaseEntry('Bottom Navigation Bar', (_) => const _BottomNavDemo()),
  ShowcaseEntry('App Bar', (_) => const _AppBarDemo()),
  ShowcaseEntry('Floating Action Button', (_) => const _FabDemo()),
  ShowcaseEntry('List/Settings Row', (_) => const _ListRowDemo()),
];

class CatalogPage extends StatelessWidget {
  const CatalogPage({
    super.key,
    required this.dark,
    required this.dynamicTheme,
    required this.dynamicAvailable,
    required this.onToggleTheme,
    required this.onToggleDynamic,
  });

  final bool dark;
  final bool dynamicTheme;
  final bool dynamicAvailable;
  final ValueChanged<bool> onToggleTheme;
  final VoidCallback onToggleDynamic;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final modeLabel = dynamicTheme ? 'Dynamic' : (dark ? 'Dark' : 'Light');
    return Scaffold(
      appBar: PalmUIAppBar(
        title: const Text('Palm UI'),
        actions: [
          IconButton(
            tooltip: dynamicAvailable
                ? 'Dynamic theme'
                : 'Dynamic theme unavailable',
            onPressed: onToggleDynamic,
            icon: Icon(
              dynamicTheme ? Icons.palette : Icons.palette_outlined,
              color: dynamicTheme ? theme.primary : theme.foreground,
            ),
          ),
          Text(modeLabel),
          const SizedBox(width: 4),
          PalmUISwitch(value: dark, onChanged: onToggleTheme),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          key: const Key('catalog-scroll'),
          child: Column(
            children: [
              for (final entry in kShowcases)
                PalmUIListTile(
                  title: Text(entry.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (routeContext) => ShowcasePage(
                          title: entry.name,
                          child: entry.builder(routeContext),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PalmUIAppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class ShowcaseBody extends StatelessWidget {
  const ShowcaseBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          children[i],
        ],
      ],
    );
  }
}

class _AccordionDemo extends StatelessWidget {
  const _AccordionDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIAccordion(
      entries: [
        PalmUIAccordionEntry(
          title: Text('Shipping'),
          content: Text('Orders ship in two business days.'),
        ),
        PalmUIAccordionEntry(
          title: Text('Returns'),
          content: Text('Returns are accepted for 30 days.'),
        ),
      ],
    );
  }
}

class _AlertDemo extends StatelessWidget {
  const _AlertDemo();

  @override
  Widget build(BuildContext context) {
    return const ShowcaseBody(
      children: [
        PalmUIAlert(
          title: Text('Heads up'),
          description: Text('You can change these settings later.'),
        ),
        PalmUIAlert(
          variant: PalmUIAlertVariant.destructive,
          icon: Icons.error_outline,
          title: Text('Something went wrong'),
          description: Text('The payment could not be completed.'),
        ),
      ],
    );
  }
}

class _AlertDialogDemo extends StatelessWidget {
  const _AlertDialogDemo();

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        const PalmUIAlertDialog(
          title: Text('Delete file?'),
          description: Text('This action cannot be undone.'),
          destructive: true,
        ),
        Builder(
          builder: (context) {
            return PalmUIButton(
              variant: PalmUIButtonVariant.destructive,
              onPressed: () => showPalmUIAlertDialog(
                context: context,
                title: const Text('Delete file?'),
                description: const Text('This action cannot be undone.'),
                confirmLabel: 'Delete',
                destructive: true,
              ),
              child: const Text('Open alert dialog'),
            );
          },
        ),
      ],
    );
  }
}

class _AspectRatioDemo extends StatelessWidget {
  const _AspectRatioDemo();

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return PalmUIAspectRatio(
      ratio: 16 / 9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: const Center(child: Text('16:9')),
      ),
    );
  }
}

class _AvatarDemo extends StatelessWidget {
  const _AvatarDemo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        PalmUIAvatar(fallback: Text('IN')),
        SizedBox(width: 12),
        PalmUIAvatar(fallback: Text('AL')),
      ],
    );
  }
}

class _BadgeDemo extends StatelessWidget {
  const _BadgeDemo();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        PalmUIBadge(child: Text('Default')),
        PalmUIBadge(
          variant: PalmUIBadgeVariant.secondary,
          child: Text('Secondary'),
        ),
        PalmUIBadge(
          variant: PalmUIBadgeVariant.destructive,
          child: Text('Destructive'),
        ),
        PalmUIBadge(
          variant: PalmUIBadgeVariant.outline,
          child: Text('Outline'),
        ),
      ],
    );
  }
}

class _BreadcrumbDemo extends StatelessWidget {
  const _BreadcrumbDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIBreadcrumb(
      items: [
        PalmUIBreadcrumbItem(label: 'Home'),
        PalmUIBreadcrumbItem(label: 'Components'),
        PalmUIBreadcrumbItem(label: 'Breadcrumb'),
      ],
    );
  }
}

class _ButtonDemo extends StatefulWidget {
  const _ButtonDemo();

  @override
  State<_ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<_ButtonDemo> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        Text('Pressed $_presses'),
        PalmUIButton(
          onPressed: () => setState(() => _presses++),
          child: const Text('Tap me'),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final variant in PalmUIButtonVariant.values)
              PalmUIButton(
                variant: variant,
                onPressed: () {},
                child: Text(_variantLabel(variant)),
              ),
          ],
        ),
        const PalmUIButton(
          onPressed: _noop,
          enabled: false,
          child: Text('Disabled'),
        ),
      ],
    );
  }
}

String _variantLabel(PalmUIButtonVariant variant) {
  return switch (variant) {
    PalmUIButtonVariant.primary => 'default',
    PalmUIButtonVariant.outline => 'outline',
    PalmUIButtonVariant.ghost => 'ghost',
    PalmUIButtonVariant.destructive => 'destructive',
    PalmUIButtonVariant.secondary => 'secondary',
    PalmUIButtonVariant.link => 'link',
  };
}

void _noop() {}

class _ButtonGroupDemo extends StatelessWidget {
  const _ButtonGroupDemo();

  @override
  Widget build(BuildContext context) {
    return PalmUIButtonGroup(
      children: [
        PalmUIButton(
          variant: PalmUIButtonVariant.ghost,
          onPressed: _noop,
          child: const Text('Day'),
        ),
        PalmUIButton(
          variant: PalmUIButtonVariant.ghost,
          onPressed: _noop,
          child: const Text('Week'),
        ),
        PalmUIButton(
          variant: PalmUIButtonVariant.ghost,
          onPressed: _noop,
          child: const Text('Month'),
        ),
      ],
    );
  }
}

class _CalendarDemo extends StatefulWidget {
  const _CalendarDemo();

  @override
  State<_CalendarDemo> createState() => _CalendarDemoState();
}

class _CalendarDemoState extends State<_CalendarDemo> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        Text(
          _selected == null ? 'No date selected' : formatPalmUIDate(_selected!),
        ),
        PalmUICalendar(
          initialMonth: DateTime(2026, 1),
          selected: _selected,
          onSelected: (date) => setState(() => _selected = date),
        ),
      ],
    );
  }
}

class _CardDemo extends StatelessWidget {
  const _CardDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUICard(
      title: Text('Plan'),
      description: Text('A mobile-ready card surface.'),
      footer: PalmUIBadge(child: Text('Active')),
      child: Text('Unlimited projects on the free tier.'),
    );
  }
}

class _CarouselDemo extends StatelessWidget {
  const _CarouselDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUICarousel(
      items: [Text('Slide 1'), Text('Slide 2'), Text('Slide 3')],
    );
  }
}

class _CheckboxDemo extends StatefulWidget {
  const _CheckboxDemo();

  @override
  State<_CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return PalmUICheckbox(
      value: _checked,
      label: _checked ? 'Checked' : 'Unchecked',
      onChanged: (value) => setState(() => _checked = value),
    );
  }
}

class _CollapsibleDemo extends StatelessWidget {
  const _CollapsibleDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUICollapsible(
      title: Text('Show details'),
      child: Text('Extra details live here.'),
    );
  }
}

class _ComboboxDemo extends StatelessWidget {
  const _ComboboxDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUICombobox(
      hint: 'Search fruit',
      options: ['Apple', 'Apricot', 'Banana', 'Blueberry'],
    );
  }
}

class _CommandDemo extends StatelessWidget {
  const _CommandDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUICommand(
      items: [
        PalmUICommandItem(label: 'New file', group: 'File'),
        PalmUICommandItem(label: 'Open', group: 'File'),
        PalmUICommandItem(label: 'Toggle theme', group: 'View'),
      ],
    );
  }
}

class _ContextMenuDemo extends StatelessWidget {
  const _ContextMenuDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIContextMenu(
      items: [
        PalmUIMenuItem(label: 'Copy'),
        PalmUIMenuItem(label: 'Paste'),
      ],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Long-press this area'),
      ),
    );
  }
}

class _DataTableDemo extends StatelessWidget {
  const _DataTableDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIDataTable(
      pageSize: 2,
      columns: [
        PalmUIDataColumn(id: 'name', label: 'Name'),
        PalmUIDataColumn(id: 'role', label: 'Role'),
      ],
      rows: [
        PalmUIDataRow(cells: {'name': 'Bravo', 'role': 'Dev'}),
        PalmUIDataRow(cells: {'name': 'Alpha', 'role': 'QA'}),
        PalmUIDataRow(cells: {'name': 'Charlie', 'role': 'Design'}),
        PalmUIDataRow(cells: {'name': 'Delta', 'role': 'PM'}),
      ],
    );
  }
}

class _DatePickerDemo extends StatefulWidget {
  const _DatePickerDemo();

  @override
  State<_DatePickerDemo> createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<_DatePickerDemo> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) {
    return PalmUIDatePicker(
      value: _value,
      initialMonth: DateTime(2026, 3),
      onChanged: (value) => setState(() => _value = value),
    );
  }
}

class _DialogDemo extends StatelessWidget {
  const _DialogDemo();

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        const PalmUIDialog(
          title: Text('Edit profile'),
          content: Text('Update the name people see.'),
        ),
        Builder(
          builder: (context) {
            return PalmUIButton(
              onPressed: () => showPalmUIDialog<void>(
                context: context,
                builder: (dialogContext) => PalmUIDialog(
                  title: const Text('Edit profile'),
                  content: const Text('Update the name people see.'),
                  actions: [
                    PalmUIButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
              child: const Text('Open dialog'),
            );
          },
        ),
      ],
    );
  }
}

class _DrawerDemo extends StatelessWidget {
  const _DrawerDemo();

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return ShowcaseBody(
      children: [
        SizedBox(
          height: 160,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: const PalmUIDrawer(
              title: Text('Menu'),
              child: Text('Navigation lives here.'),
            ),
          ),
        ),
        Builder(
          builder: (context) {
            return PalmUIButton(
              variant: PalmUIButtonVariant.outline,
              onPressed: () => showPalmUIDrawer<void>(
                context: context,
                title: const Text('Menu'),
                builder: (context) => const Text('Navigation lives here.'),
              ),
              child: const Text('Open drawer'),
            );
          },
        ),
      ],
    );
  }
}

class _DropdownDemo extends StatelessWidget {
  const _DropdownDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIDropdownMenu(
      items: [
        PalmUIMenuItem(label: 'Edit'),
        PalmUIMenuItem(label: 'Duplicate'),
        PalmUIMenuItem(label: 'Delete', destructive: true),
      ],
      child: Text('Open menu'),
    );
  }
}

class _EmptyDemo extends StatelessWidget {
  const _EmptyDemo();

  @override
  Widget build(BuildContext context) {
    return PalmUIEmpty(
      title: const Text('No messages'),
      description: const Text('Start a conversation to see it here.'),
      action: PalmUIButton(onPressed: _noop, child: const Text('Compose')),
    );
  }
}

class _FieldDemo extends StatelessWidget {
  const _FieldDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIField(
      label: Text('Email'),
      hint: 'We will not share this.',
      error: 'Enter a valid email.',
      child: PalmUIInput(hint: 'you@example.com'),
    );
  }
}

class _HoverCardDemo extends StatelessWidget {
  const _HoverCardDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIHoverCard(
      trigger: Text('Ada Lovelace'),
      content: Text('Mathematician and writer.'),
    );
  }
}

class _InputDemo extends StatefulWidget {
  const _InputDemo();

  @override
  State<_InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<_InputDemo> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        PalmUIInput(
          hint: 'Your name',
          onChanged: (value) => setState(() => _value = value),
        ),
        Text(_value.isEmpty ? 'Value: empty' : 'Value: $_value'),
      ],
    );
  }
}

class _InputGroupDemo extends StatelessWidget {
  const _InputGroupDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIInputGroup(
      prefix: Text('https://'),
      suffix: Icon(Icons.search),
      child: PalmUIInput(hint: 'example.com', bordered: false),
    );
  }
}

class _OtpDemo extends StatelessWidget {
  const _OtpDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIInputOtp(length: 6);
  }
}

class _ItemDemo extends StatelessWidget {
  const _ItemDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIItem(
      leading: PalmUIAvatar(fallback: Text('SC')),
      title: Text('Palm'),
      description: Text('Beautifully designed components.'),
      trailing: Icon(Icons.chevron_right),
    );
  }
}

class _KbdDemo extends StatelessWidget {
  const _KbdDemo();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [Text('Press'), PalmUIKbd('⌘'), PalmUIKbd('K')],
    );
  }
}

class _LabelDemo extends StatelessWidget {
  const _LabelDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUILabel(child: Text('Display name'));
  }
}

class _MenubarDemo extends StatelessWidget {
  const _MenubarDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIMenubar(
      menus: [
        PalmUIMenuBarMenu(
          label: 'File',
          items: [
            PalmUIMenuItem(label: 'New'),
            PalmUIMenuItem(label: 'Open'),
          ],
        ),
        PalmUIMenuBarMenu(
          label: 'Edit',
          items: [
            PalmUIMenuItem(label: 'Undo'),
            PalmUIMenuItem(label: 'Redo'),
          ],
        ),
      ],
    );
  }
}

class _NavigationMenuDemo extends StatelessWidget {
  const _NavigationMenuDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUINavigationMenu(
      entries: [
        PalmUINavMenuEntry(
          label: 'Products',
          content: Text('Components, blocks, and themes.'),
        ),
        PalmUINavMenuEntry(
          label: 'Docs',
          content: Text('Guides for mobile layouts.'),
        ),
      ],
    );
  }
}

class _PaginationDemo extends StatefulWidget {
  const _PaginationDemo();

  @override
  State<_PaginationDemo> createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<_PaginationDemo> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        Text('Showing page $_page'),
        PalmUIPagination(
          page: _page,
          pageCount: 5,
          onPageChanged: (page) => setState(() => _page = page),
        ),
      ],
    );
  }
}

class _PopoverDemo extends StatelessWidget {
  const _PopoverDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIPopover(
      trigger: Text('Open popover'),
      content: Text('Place any content here.'),
    );
  }
}

class _ProgressDemo extends StatelessWidget {
  const _ProgressDemo();

  @override
  Widget build(BuildContext context) {
    return const ShowcaseBody(
      children: [PalmUIProgress(value: 0.66), Text('66%')],
    );
  }
}

class _RadioDemo extends StatefulWidget {
  const _RadioDemo();

  @override
  State<_RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  String _value = 'system';

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        Text('Selected: $_value'),
        PalmUIRadioGroup<String>(
          value: _value,
          onChanged: (value) => setState(() => _value = value),
          children: const [
            PalmUIRadio(value: 'light', label: 'Light'),
            PalmUIRadio(value: 'dark', label: 'Dark'),
            PalmUIRadio(value: 'system', label: 'System'),
          ],
        ),
      ],
    );
  }
}

class _ScrollAreaDemo extends StatelessWidget {
  const _ScrollAreaDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUIScrollArea(
      height: 120,
      child: Text(
        'Scrollable content.\nLine two keeps going.\nLine three.\nLine four.\n'
        'Line five.\nLine six.\nLine seven is still inside the area.',
      ),
    );
  }
}

class _SelectDemo extends StatefulWidget {
  const _SelectDemo();

  @override
  State<_SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<_SelectDemo> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return PalmUISelect<String>(
      value: _value,
      hint: 'Choose a fruit',
      onChanged: (value) => setState(() => _value = value),
      items: const [
        PalmUISelectItem(value: 'apple', label: 'Apple'),
        PalmUISelectItem(value: 'banana', label: 'Banana'),
      ],
    );
  }
}

class _SeparatorDemo extends StatelessWidget {
  const _SeparatorDemo();

  @override
  Widget build(BuildContext context) {
    return const ShowcaseBody(
      children: [Text('Above'), PalmUISeparator(), Text('Below')],
    );
  }
}

class _SheetDemo extends StatelessWidget {
  const _SheetDemo();

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        const PalmUISheet(child: Text('Sheet panel')),
        Builder(
          builder: (context) {
            return PalmUIButton(
              variant: PalmUIButtonVariant.outline,
              onPressed: () => showPalmUISheet<void>(
                context: context,
                builder: (context) => const PalmUISheet(
                  child: SizedBox(
                    height: 180,
                    child: Text('Slides up from the bottom edge.'),
                  ),
                ),
              ),
              child: const Text('Open sheet'),
            );
          },
        ),
      ],
    );
  }
}

class _SidebarDemo extends StatelessWidget {
  const _SidebarDemo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 280,
      child: PalmUISidebar(
        entries: [
          PalmUISidebarEntry(label: 'Inbox', icon: Icons.inbox),
          PalmUISidebarEntry(label: 'Sent', icon: Icons.send),
        ],
        body: Center(child: Text('Mailbox')),
      ),
    );
  }
}

class _SkeletonDemo extends StatelessWidget {
  const _SkeletonDemo();

  @override
  Widget build(BuildContext context) {
    return const ShowcaseBody(
      children: [
        PalmUISkeleton(height: 20),
        PalmUISkeleton(height: 14, width: 180),
        PalmUISkeleton(height: 80),
      ],
    );
  }
}

class _SliderDemo extends StatefulWidget {
  const _SliderDemo();

  @override
  State<_SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<_SliderDemo> {
  double _value = 40;

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        Text('Volume ${_value.round()}'),
        PalmUISlider(
          value: _value,
          min: 0,
          max: 100,
          onChanged: (value) => setState(() => _value = value),
        ),
      ],
    );
  }
}

class _SpinnerDemo extends StatelessWidget {
  const _SpinnerDemo();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: PalmUISpinner(size: 28),
    );
  }
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PalmUISwitch(
          value: _on,
          onChanged: (value) => setState(() => _on = value),
        ),
        const SizedBox(width: 8),
        Text(_on ? 'On' : 'Off'),
      ],
    );
  }
}

class _TableDemo extends StatelessWidget {
  const _TableDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUITable(
      headers: ['Fruit', 'Qty'],
      rows: [
        ['Apple', '12'],
        ['Banana', '4'],
      ],
    );
  }
}

class _TabsDemo extends StatelessWidget {
  const _TabsDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUITabs(
      tabs: ['Account', 'Password'],
      children: [Text('Account panel'), Text('Password panel')],
    );
  }
}

class _TextareaDemo extends StatelessWidget {
  const _TextareaDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUITextarea(hint: 'Write a note');
  }
}

class _ToastDemo extends StatelessWidget {
  const _ToastDemo();

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        const PalmUIToastCard(message: 'Changes stored on this device.'),
        PalmUIButton(
          onPressed: () => PalmUIToast.show(context, message: 'Saved'),
          child: const Text('Show toast'),
        ),
      ],
    );
  }
}

class _ToggleDemo extends StatefulWidget {
  const _ToggleDemo();

  @override
  State<_ToggleDemo> createState() => _ToggleDemoState();
}

class _ToggleDemoState extends State<_ToggleDemo> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return PalmUIToggle(
      pressed: _pressed,
      onPressed: () => setState(() => _pressed = !_pressed),
      child: const Text('Bold'),
    );
  }
}

class _ToggleGroupDemo extends StatefulWidget {
  const _ToggleGroupDemo();

  @override
  State<_ToggleGroupDemo> createState() => _ToggleGroupDemoState();
}

class _ToggleGroupDemoState extends State<_ToggleGroupDemo> {
  String _selected = 'Center';

  @override
  Widget build(BuildContext context) {
    return PalmUIToggleGroup(
      items: const ['Left', 'Center', 'Right'],
      selected: _selected,
      onChanged: (value) => setState(() => _selected = value),
    );
  }
}

class _TooltipDemo extends StatelessWidget {
  const _TooltipDemo();

  @override
  Widget build(BuildContext context) {
    return const PalmUITooltip(
      message: 'Add to library',
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('Tap for a tooltip'),
      ),
    );
  }
}

class _TypographyDemo extends StatelessWidget {
  const _TypographyDemo();

  @override
  Widget build(BuildContext context) {
    return const ShowcaseBody(
      children: [
        PalmUIText('Heading', variant: PalmUITextVariant.h1),
        PalmUIText('Section', variant: PalmUITextVariant.h2),
        PalmUIText(
          'Lead copy introduces the page.',
          variant: PalmUITextVariant.lead,
        ),
        PalmUIText('Body paragraph for reading.', variant: PalmUITextVariant.p),
        PalmUIText('Muted helper text.', variant: PalmUITextVariant.muted),
        PalmUIText('A quoted line.', variant: PalmUITextVariant.blockquote),
      ],
    );
  }
}

class _BottomNavDemo extends StatefulWidget {
  const _BottomNavDemo();

  @override
  State<_BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<_BottomNavDemo> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    const labels = ['Inbox', 'Search', 'Profile'];
    return ShowcaseBody(
      children: [
        Text('Section ${labels[_index]}'),
        PalmUIBottomNav(
          selectedIndex: _index,
          onSelected: (index) => setState(() => _index = index),
          destinations: const [
            PalmUINavDestination(icon: Icons.inbox, label: 'Inbox'),
            PalmUINavDestination(icon: Icons.search, label: 'Search'),
            PalmUINavDestination(icon: Icons.person, label: 'Profile'),
          ],
        ),
      ],
    );
  }
}

class _AppBarDemo extends StatelessWidget {
  const _AppBarDemo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      child: PalmUIAppBar(
        title: Text('Messages'),
        actions: [Icon(Icons.search)],
      ),
    );
  }
}

class _FabDemo extends StatefulWidget {
  const _FabDemo();

  @override
  State<_FabDemo> createState() => _FabDemoState();
}

class _FabDemoState extends State<_FabDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        Text('Created $_count'),
        Align(
          alignment: Alignment.centerLeft,
          child: PalmUIFab(
            onPressed: () => setState(() => _count++),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _ListRowDemo extends StatefulWidget {
  const _ListRowDemo();

  @override
  State<_ListRowDemo> createState() => _ListRowDemoState();
}

class _ListRowDemoState extends State<_ListRowDemo> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) {
    return ShowcaseBody(
      children: [
        Text('Opened $_taps'),
        PalmUIListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Notifications'),
          subtitle: const Text('Settings row'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => setState(() => _taps++),
        ),
      ],
    );
  }
}
