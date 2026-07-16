import 'package:flutter/material.dart';

import '../../core/models/models.dart';

/// Avatar background/foreground for a publisher's gender. Male reads blue,
/// female rose; unknown returns null so the theme default is kept. Tuned for
/// legible contrast in both light and dark themes.
({Color background, Color foreground})? genderAvatarColors(
  BuildContext context,
  Gender gender,
) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  switch (gender) {
    case Gender.male:
      return dark
          ? (background: const Color(0xFF1565C0), foreground: Colors.white)
          : (background: const Color(0xFFBBDEFB), foreground: const Color(0xFF0D47A1));
    case Gender.female:
      return dark
          ? (background: const Color(0xFFAD1457), foreground: Colors.white)
          : (background: const Color(0xFFF8BBD0), foreground: const Color(0xFF880E4F));
    case Gender.unknown:
      return null;
  }
}
