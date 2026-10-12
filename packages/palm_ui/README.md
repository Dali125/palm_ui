# Palm UI

[![pub points](https://img.shields.io/pub/points/palm_ui.svg)](https://pub.dev/packages/palm_ui)
[![pub package](https://img.shields.io/pub/v/palm_ui.svg)](https://pub.dev/packages/palm_ui)

A mobile-first Flutter component system and design kit inspired by **shadcn/ui**. Designed from the ground up for phone ergonomics, semantic design tokens, light/dark themes, and Android 12+ Material You dynamic theming.

---

## Screenshots

| Buttons & badges | Form controls | Date picker | Dialog |
|---|---|---|---|
| <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/buttons.png" width="200" alt="Buttons, button groups, toggle groups and badges"> | <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/forms.png" width="200" alt="Form controls - input, field, select, checkbox, switch and slider"> | <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/datepicker.png" width="200" alt="Date picker dialog"> | <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/dialog.png" width="200" alt="Dialog with actions"> |

| Bottom sheet (dark) | Data table | Toasts & alerts | Dark theme |
|---|---|---|---|
| <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/sheet_dark.png" width="200" alt="Bottom sheet in the dark theme"> | <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/datatable.png" width="200" alt="Data table with pagination"> | <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/toast.png" width="200" alt="Toasts and alerts"> | <img src="https://raw.githubusercontent.com/Dali125/palm_ui/main/packages/palm_ui/doc/screenshots/dark.png" width="200" alt="Dark theme - cards, tabs, buttons, inputs and progress"> |

## Features

- 📱 **Mobile-First Touch Ergonomics**: Generous hit targets, smooth bottom sheets, drawer interactions, and responsive navigation.
- 🎨 **Semantic Color System**: Predictable design tokens (`background`, `foreground`, `primary`, `muted`, `accent`, `destructive`, etc.) matching shadcn/ui conventions.
- 🌓 **Light & Dark Presets**: Carefully tuned contrast ratios for both light and dark modes out of the box.
- 🤖 **Android Dynamic Theming**: Direct integration with system accent palettes on Android 12+ via `dynamic_color`.
- 🧩 **50+ Pre-built Components**: Complete UI building blocks including buttons, inputs, form fields, dialogs, drawers, date pickers, data tables, toasts, and menus.

---

## Installation

Add `palm_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  palm_ui: ^0.1.1
```

Then run:

```bash
flutter pub get
```

---

## Getting Started

Wrap your application in `PalmUITheme` and sync it with `MaterialApp`:

```dart
import 'package:flutter/material.dart';
import 'package:palm_ui/palm_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = PalmUIThemeData.light(); // Or PalmUIThemeData.dark()

    return PalmUITheme(
      data: theme,
      child: MaterialApp(
        title: 'My App',
        theme: theme.toThemeData(),
        builder: (context, child) {
          // Wrap in PalmUIToaster to enable toast notifications anywhere
          return PalmUIToaster(child: child ?? const SizedBox.shrink());
        },
        home: const HomePage(),
      ),
    );
  }
}
```

### Material You Dynamic Colors (Android 12+)

To adapt to your user's system wallpaper palette on Android devices:

```dart
class _AppState extends State<App> {
  PalmUIDynamicThemes _dynamic = const PalmUIDynamicThemes();

  @override
  void initState() {
    super.initState();
    _initDynamicColors();
  }

  Future<void> _initDynamicColors() async {
    final dynamicThemes = await PalmUIDynamicThemes.load();
    if (mounted) setState(() => _dynamic = dynamicThemes);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final theme = _dynamic.isAvailable
        ? _dynamic.resolve(brightness)
        : (brightness == Brightness.dark ? PalmUIThemeData.dark() : PalmUIThemeData.light());

    return PalmUITheme(
      data: theme,
      child: MaterialApp(
        theme: theme.toThemeData(),
        home: const HomePage(),
      ),
    );
  }
}
```

---

## Component Guide & Examples

### 1. Buttons & Action Triggers

#### `PalmUIButton`
Supports variants (`primary`, `secondary`, `outline`, `ghost`, `destructive`, `link`) and sizes (`sm`, `md`, `lg`, `icon`).

```dart
PalmUIButton(
  variant: PalmUIButtonVariant.primary,
  size: PalmUIButtonSize.md,
  onPressed: () => print('Submitted'),
  child: const Text('Submit'),
)

PalmUIButton(
  variant: PalmUIButtonVariant.destructive,
  onPressed: () => print('Deleted'),
  child: const Text('Delete Account'),
)
```

#### `PalmUIButtonGroup`
Visually connects adjacent buttons into an integrated segment.

```dart
PalmUIButtonGroup(
  children: [
    PalmUIButton(
      variant: PalmUIButtonVariant.outline,
      child: const Text('Day'),
    ),
    PalmUIButton(
      variant: PalmUIButtonVariant.outline,
      child: const Text('Week'),
    ),
    PalmUIButton(
      variant: PalmUIButtonVariant.outline,
      child: const Text('Month'),
    ),
  ],
)
```

#### `PalmUIFab`
Floating action button with rounded geometry for top-level screen actions:

```dart
PalmUIFab(
  onPressed: () => print('Create new item'),
  child: const Icon(Icons.add),
)
```

---

### 2. Form Controls & Inputs

#### `PalmUIField` & `PalmUIInput`
`PalmUIField` binds labels, inputs, hints, and error validation states together cleanly:

```dart
PalmUIField(
  label: const Text('Email address'),
  hint: 'We will never share your email.',
  error: _emailError, // Shows error styling when non-null
  child: PalmUIInput(
    controller: _emailController,
    hint: 'you@domain.com',
    keyboardType: TextInputType.emailAddress,
    onChanged: (value) => _validateEmail(value),
  ),
)
```

#### `PalmUIInputOtp`
Digit boxes for OTP / SMS verification codes with auto-advance:

```dart
PalmUIInputOtp(
  length: 6,
  onCompleted: (pin) => verifyCode(pin),
)
```

#### `PalmUISwitch`, `PalmUICheckbox`, & `PalmUISlider`

```dart
// Switch
PalmUISwitch(
  value: _isEnabled,
  onChanged: (val) => setState(() => _isEnabled = val),
)

// Checkbox
PalmUICheckbox(
  checked: _agreeToTerms,
  onChanged: (val) => setState(() => _agreeToTerms = val),
)

// Slider
PalmUISlider(
  value: _volume,
  min: 0,
  max: 100,
  onChanged: (val) => setState(() => _volume = val),
)
```

#### `PalmUISelect` & `PalmUICombobox`
Searchable and dropdown selection:

```dart
PalmUISelect<String>(
  value: _selectedCountry,
  placeholder: 'Select a country',
  items: const [
    PalmUISelectItem(value: 'us', label: 'United States'),
    PalmUISelectItem(value: 'ca', label: 'Canada'),
    PalmUISelectItem(value: 'uk', label: 'United Kingdom'),
  ],
  onChanged: (val) => setState(() => _selectedCountry = val),
)
```

---

### 3. Overlays, Dialogs & Sheets

#### `showPalmUIDialog` / `PalmUIDialog`
Custom modal alert or form dialogs:

```dart
showPalmUIDialog<void>(
  context: context,
  builder: (context) => PalmUIDialog(
    title: const Text('Edit Profile'),
    description: const Text('Make changes to your profile details here.'),
    content: PalmUIInput(hint: 'Display name'),
    actions: [
      PalmUIButton(
        variant: PalmUIButtonVariant.outline,
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      PalmUIButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Save'),
      ),
    ],
  ),
);
```

#### `showPalmUIAlertDialog`
Fast confirmation alerts returning a boolean result:

```dart
final confirmed = await showPalmUIAlertDialog(
  context: context,
  title: const Text('Delete project?'),
  description: const Text('This will permanently delete this project and all assets.'),
  destructive: true,
  actionText: 'Delete',
);
```

#### `showPalmUISheet` & `showPalmUIDrawer`
Slide-out drawer and bottom sheet surfaces:

```dart
showPalmUISheet<void>(
  context: context,
  side: PalmUISheetSide.bottom,
  builder: (context) => PalmUISheet(
    title: const Text('Actions'),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PalmUIListTile(title: const Text('Share link'), leading: const Icon(Icons.share)),
        PalmUIListTile(title: const Text('Download PDF'), leading: const Icon(Icons.download)),
      ],
    ),
  ),
);
```

---

### 4. Feedback & Notifications

#### `PalmUIToaster`
Show animated toast notifications from any context (requires `PalmUIToaster` in your root widget tree):

```dart
PalmUIToaster.of(context).show(
  title: const Text('File uploaded'),
  description: const Text('Your invoice was processed successfully.'),
);
```

#### `PalmUIAlert`
Inline alert message boxes:

```dart
PalmUIAlert(
  title: const Text('Maintenance Window'),
  description: const Text('The system will be offline tonight from 2AM to 3AM UTC.'),
)

PalmUIAlert(
  variant: PalmUIAlertVariant.destructive,
  icon: Icons.error_outline,
  title: const Text('Payment Failed'),
  description: const Text('Please check your card details and try again.'),
)
```

#### `PalmUISkeleton` & `PalmUIProgress`

```dart
// Loading skeleton
PalmUISkeleton(width: double.infinity, height: 20)

// Progress bar (0.0 to 1.0)
PalmUIProgress(value: 0.65)
```

---

### 5. Data Display

#### `PalmUICard`
Structured card container supporting titles, subtext, body, and footers:

```dart
PalmUICard(
  title: const Text('Subscription Plan'),
  description: const Text('Manage your billing and tier options.'),
  child: const Text('You are currently on the Pro plan.'),
  footer: PalmUIButton(
    variant: PalmUIButtonVariant.outline,
    child: const Text('Upgrade'),
  ),
)
```

#### `PalmUIDataTable`
Interactive paginated data table with search and clean cell layout:

```dart
PalmUIDataTable(
  columns: const [
    PalmUIDataColumn(id: 'id', label: 'Order ID'),
    PalmUIDataColumn(id: 'customer', label: 'Customer'),
    PalmUIDataColumn(id: 'amount', label: 'Amount'),
  ],
  rows: const [
    PalmUIDataRow(cells: {'id': '#1001', 'customer': 'Alice Smith', 'amount': '\$42.00'}),
    PalmUIDataRow(cells: {'id': '#1002', 'customer': 'Bob Jones', 'amount': '\$19.50'}),
  ],
  pageSize: 5,
)
```

#### `PalmUIBadge` & `PalmUIAvatar`

```dart
PalmUIBadge(
  variant: PalmUIBadgeVariant.secondary,
  child: const Text('Beta'),
)

PalmUIAvatar(
  initials: 'JD',
  url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
)
```

---

### 6. Menus & Popovers

#### `PalmUIDropdownMenu` & `PalmUIContextMenu`

```dart
PalmUIDropdownMenu(
  items: [
    PalmUIMenuItem(label: 'Edit', onSelected: () {}),
    PalmUIMenuItem(label: 'Duplicate', onSelected: () {}),
    PalmUIMenuItem(label: 'Delete', destructive: true, onSelected: () {}),
  ],
  child: PalmUIButton(
    variant: PalmUIButtonVariant.outline,
    child: const Text('Options ▾'),
  ),
)
```

---

### 7. Navigation

#### `PalmUIAppBar` & `PalmUIBottomNav`

```dart
// App Bar
PalmUIAppBar(
  title: const Text('Dashboard'),
  actions: [
    IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
  ],
)

// Bottom Navigation Bar
PalmUIBottomNav(
  selectedIndex: _navIndex,
  onSelected: (index) => setState(() => _navIndex = index),
  destinations: const [
    PalmUINavDestination(icon: Icons.home, label: 'Home'),
    PalmUINavDestination(icon: Icons.search, label: 'Search'),
    PalmUINavDestination(icon: Icons.settings, label: 'Settings'),
  ],
)
```

#### `PalmUITabs` & `PalmUIAccordion`

```dart
// Tabs
PalmUITabs(
  tabs: const [
    PalmUITab(label: 'Account', content: AccountSettingsView()),
    PalmUITab(label: 'Security', content: SecuritySettingsView()),
  ],
)

// Accordion
PalmUIAccordion(
  entries: const [
    PalmUIAccordionEntry(
      title: Text('Is there a free trial?'),
      content: Text('Yes, all plans include a 14-day free trial.'),
    ),
    PalmUIAccordionEntry(
      title: Text('Can I cancel anytime?'),
      content: Text('You can cancel your subscription at any time from your account settings.'),
    ),
  ],
)
```

---

## Exploring the Interactive Catalog

Check out the bundled `example` app to interactively explore all components:

```bash
cd packages/palm_ui/example
flutter run
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.
