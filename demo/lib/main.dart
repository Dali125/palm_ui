import 'package:flutter/material.dart';
import 'package:palm_ui/dynamic_color.dart';
import 'package:palm_ui/palm_ui.dart';

import 'catalog.dart';

void main() {
  runApp(const PalmUIDemoApp());
}

enum PalmUIThemeChoice { light, dark, dynamic }

class PalmUIDemoApp extends StatefulWidget {
  const PalmUIDemoApp({super.key});

  @override
  State<PalmUIDemoApp> createState() => _PalmUIDemoAppState();
}

class _PalmUIDemoAppState extends State<PalmUIDemoApp>
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
        title: 'Palm UI',
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
