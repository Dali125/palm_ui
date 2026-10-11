import 'package:flutter/material.dart';
import 'package:palm_ui/palm_ui.dart';

void main() {
  final theme = PalmUIThemeData.light();
  runApp(
    PalmUITheme(
      data: theme,
      child: MaterialApp(
        theme: theme.toThemeData(),
        home: const Scaffold(
          body: Center(
            child: PalmUIButton(onPressed: _noop, child: Text('Save')),
          ),
        ),
      ),
    ),
  );
}

void _noop() {}
