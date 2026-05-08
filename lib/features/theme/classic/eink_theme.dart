import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/classic_theme.dart';

class EinkTheme extends ClassicTheme {
  @override
  bool get isDark => false;

  @override
  IconData get icon => LucideIcons.sun;

  @override
  Color get foreground => Colors.black;

  @override
  Color get background => Colors.white;

  @override
  Color get border => Colors.black;

  @override
  Color get dimmed => Colors.black;

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}