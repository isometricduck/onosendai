import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class LcdTheme extends Theme {
  @override
  IconData get icon => LucideIcons.calculator;

  @override
  Color get foreground => Colors.black;

  @override
  Color get background => Color(int.parse('#eaeae4'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(int.parse('#9aa49d'.replaceAll('#', '0xFF')));

  @override
  Color get dimmed => Color(int.parse('#3a3a3a'.replaceAll('#', '0xFF')));

  @override
  TextStyle get mainFont =>
      GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w400);
}

/*

[data-theme=lcd] {
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: .875rem;
    --font-size-h-mobile: 1rem;
    --font-size-p: .875rem;
    --font-size-p-mobile: 1rem;
    --line-height-base: 1.4;
    --color-bg: #eaeae4;
    --color-fg: #000;
    --color-fg-dim: #3a3a3a;
    --color-border: #9aa49d;
    --color-quote: #9aa49d;
    --color-blockquote-bg: rgba(0,0,0,.08);
    --color-code-bg: #b4c2aa;
    --radius-lg: 7px;
    --radius-md: 5px;
    --radius-sm: 3px;
    --color-code: #58625e;
    --theme-font-mono: JetBrains Mono,Courier New,monospace;
    --code-font: JetBrains Mono,Courier New,monospace
}

*/