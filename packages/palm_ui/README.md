# palm_ui

Mobile-first Flutter components with a semantic theme. Light and dark presets ship with the package, and Android phones can follow the system dynamic palette.

This package is a port of [shadcn/ui](https://ui.shadcn.com).

## Install

```yaml
dependencies:
  palm_ui: ^0.1.0
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:palm_ui/palm_ui.dart';

void main() {
  final theme = PalmUIThemeData.light();
  runApp(
    PalmUITheme(
      data: theme,
      child: MaterialApp(
        theme: theme.toThemeData(),
        home: Scaffold(
          body: PalmUIButton(
            onPressed: () {},
            child: const Text('Save'),
          ),
        ),
      ),
    ),
  );
}
```
