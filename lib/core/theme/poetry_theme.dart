import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class PoetryTheme extends Theme {
  @override
  bool get isDark => false;

  @override
  IconData get icon => LucideIcons.bookOpen;

  @override
  Color get foreground => Color(int.parse('#222222'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#fefaf8'.replaceAll('#', '0xFF')));

  @override
  Color get border => Colors.transparent;

  @override
  Color get dimmed => Color(int.parse('#666666'.replaceAll('#', '0xFF')));

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'EBGaramond',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

/*

[data-theme=poetry] {
    --font-size-base: 18px;
    --font-size-base-mobile: 16px;
    --font-size-h: 18px;
    --font-size-h-mobile: 16px;
    --font-size-p: 18px;
    --font-size-p-mobile: 18px;
    --line-height-base: 1.36;
    --color-bg: #fefaf8;
    --color-fg: #222;
    --color-fg-dim: #666;
    --color-border: transparent;
    --color-quote: #d4c5a9;
    --color-code: #2a2a2a;
    --color-code-bg: #f0e0dd;
    --color-accent: #f0e0dd;
    --color-hover: #faf8f5;
    --theme-font-mono: "EB Garamond","Garamond","Times New Roman",serif;
    --theme-font-code: "JetBrains Mono","Courier New",monospace;
    --code-font: var(--theme-font-code)
}

*/
