/// Material You dynamic color support for Palm UI.
///
/// Import this library alongside `package:palm_ui/palm_ui.dart` when you want
/// themes built from the Android 12+ system wallpaper palette:
///
/// ```dart
/// import 'package:palm_ui/palm_ui.dart';
/// import 'package:palm_ui/dynamic_color.dart';
/// ```
///
/// It is kept out of the main `palm_ui` library because it depends on the
/// `dynamic_color` plugin, so apps that only use the components and the
/// static light and dark presets do not pull in a platform plugin.
/// [PalmUIDynamicThemes.load] is safe to call on every platform: where no
/// palette is available it completes with [PalmUIDynamicThemes.isAvailable]
/// set to false.
library;

export 'src/theme/dynamic_theme.dart';
