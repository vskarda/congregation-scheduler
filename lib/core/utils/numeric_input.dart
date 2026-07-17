import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Keyboard type for digit-only inputs.
///
/// On iPadOS 26/26.1 `TextInputType.number` presents a broken floating numeric
/// keyboard that is cropped, unresponsive, and often never appears at all
/// (flutter/flutter#178096, #183926). `numberWithOptions(signed: true)` maps to
/// iOS `UIKeyboardTypeNumbersAndPunctuation` — a normal keyboard that presents
/// reliably. Other platforms keep the compact number pad, which works there.
/// Always pair with [FilteringTextInputFormatter.digitsOnly] so only digits are
/// accepted regardless of which keyboard is shown.
TextInputType get numericKeyboardType =>
    defaultTargetPlatform == TargetPlatform.iOS
        ? const TextInputType.numberWithOptions(signed: true)
        : TextInputType.number;
