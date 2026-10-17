## 0.2.0

**Breaking:** dynamic color moved to its own library.

* `PalmUIDynamicThemes` is no longer exported from
  `package:palm_ui/palm_ui.dart`. Import `package:palm_ui/dynamic_color.dart`
  to use it. The main library no longer pulls in the `dynamic_color` plugin,
  so it can be detected as supporting iOS and web.
* `PalmUIDynamicThemes.load()` no longer throws on platforms without the
  plugin (iOS, web) or when the plugin fails. It catches
  `MissingPluginException` and `PlatformException` and completes with
  `isAvailable == false`, so apps fall back to the light and dark presets.
* Accessibility: `PalmUICheckbox`, `PalmUIRadio`, `PalmUISwitch`, `PalmUITab`,
  `PalmUIBottomNavItem` and `PalmUIButton` now expose screen reader semantics
  (role, checked/toggled/selected state, enabled state and label), can be
  focused and activated with Enter or Space, and show a focus ring.
* New optional `semanticLabel` on `PalmUIButton`, `PalmUICheckbox` and
  `PalmUISwitch`, for icon-only buttons and controls without visible text.
* A disabled `PalmUIButton` (`enabled: false` or `onPressed: null`) no longer
  shows an ink ripple and is reported as disabled.
* `PalmUICheckbox` now has a minimum tap width of 44 logical pixels.
* Documented the public API and enabled the `public_member_api_docs` lint.
* `mathMin` and `palmUISameDay` were internal helpers and are now private.
  `formatPalmUIDate` stays public and is documented.
* Added widget tests for semantics, keyboard activation, the disabled button,
  tap target size and the dynamic color fallbacks.

### Migrating from 0.1.x

If you use Material You dynamic colors, add the new import:

```dart
import 'package:palm_ui/palm_ui.dart';
import 'package:palm_ui/dynamic_color.dart'; // new in 0.2.0

final themes = await PalmUIDynamicThemes.load();
```

If you called `mathMin` or `palmUISameDay`, replace them with `math.min` from
`dart:math` and a direct comparison of year, month and day. Nothing else
changes.

## 0.1.2

* Added component screenshots to the README and pub.dev listing.

## 0.1.1

* Enhanced documentation with detailed component usage guide.
* Added interactive 50+ component showcase example app with live search and category breakdown.
* Configured repository and issue tracker links.

## 0.1.0

* Initial release of Palm UI with semantic light and dark themes, Android dynamic color, and mobile components.

