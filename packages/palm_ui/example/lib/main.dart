import 'package:flutter/material.dart';
import 'package:palm_ui/palm_ui.dart';

import 'catalog.dart';

void main() {
  runApp(const PalmUIExampleApp());
}

enum PalmUIThemeChoice { light, dark, dynamic }

/// Complete interactive example and component gallery for `palm_ui`.
///
/// Demonstrates:
/// - Semantic Light and Dark theme switching
/// - Material You dynamic color extraction on supported Android devices
/// - All 50+ Palm UI components categorized with explanations
class PalmUIExampleApp extends StatefulWidget {
  const PalmUIExampleApp({super.key});

  @override
  State<PalmUIExampleApp> createState() => _PalmUIExampleAppState();
}

class _PalmUIExampleAppState extends State<PalmUIExampleApp>
    with WidgetsBindingObserver {
  PalmUIThemeChoice _choice = PalmUIThemeChoice.light;
  PalmUIDynamicThemes _dynamic = const PalmUIDynamicThemes();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDynamicColors();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadDynamicColors() async {
    final themes = await PalmUIDynamicThemes.load();
    if (!mounted) return;
    setState(() => _dynamic = themes);
  }

  @override
  void didChangePlatformBrightness() {
    if (_choice == PalmUIThemeChoice.dynamic) {
      setState(() {});
    }
  }

  PalmUIThemeData _themeData() {
    switch (_choice) {
      case PalmUIThemeChoice.light:
        return PalmUIThemeData.light();
      case PalmUIThemeChoice.dark:
        return PalmUIThemeData.dark();
      case PalmUIThemeChoice.dynamic:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return _dynamic.resolve(brightness);
    }
  }

  void _toggleDark(bool dark) {
    setState(() {
      _choice = dark ? PalmUIThemeChoice.dark : PalmUIThemeChoice.light;
    });
  }

  void _toggleDynamic() {
    setState(() {
      _choice = _choice == PalmUIThemeChoice.dynamic
          ? PalmUIThemeChoice.light
          : PalmUIThemeChoice.dynamic;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _themeData();
    return PalmUITheme(
      data: data,
      child: MaterialApp(
        title: 'Palm UI Example',
        debugShowCheckedModeBanner: false,
        theme: data.toThemeData(),
        builder: (context, child) {
          return PalmUIToaster(child: child ?? const SizedBox.shrink());
        },
        home: CatalogPage(
          dark: _choice == PalmUIThemeChoice.dark,
          dynamicTheme: _choice == PalmUIThemeChoice.dynamic,
          dynamicAvailable: _dynamic.isAvailable,
          onToggleTheme: _toggleDark,
          onToggleDynamic: _toggleDynamic,
        ),
      ),
    );
  }
}
