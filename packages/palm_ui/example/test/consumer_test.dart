import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palm_ui/palm_ui.dart';

void main() {
  test('light theme factory is light and distinct from the dark primary', () {
    final light = PalmUIThemeData.light();
    final dark = PalmUIThemeData.dark();
    expect(light.brightness, Brightness.light);
    expect(light.primary, isNot(dark.primary));
  });
}
