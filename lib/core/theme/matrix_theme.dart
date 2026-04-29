import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class MatrixTheme extends Theme {
  @override
  bool get isDark => true;
  
  @override
  IconData get icon => LucideIcons.terminal;

  @override
  Color get foreground => Color(
      int.parse('#a0e044'.replaceAll('#', '0xFF')),
  ).withValues(alpha: 0.9);

  @override
  Color get background => Colors.transparent;

  @override
  Color get border => Color(
      int.parse('#a0e044'.replaceAll('#', '0xFF')),
  ).withValues(alpha: 0.4);

  @override
  Color get dimmed => Color(
      int.parse('#a0e044'.replaceAll('#', '0xFF')),
  ).withValues(alpha: 0.5);


  @override
  TextStyle get font =>
      GoogleFonts.vt323(fontSize: 16, fontWeight: FontWeight.w400);
}

/*

[data-theme=matrix] {
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: .875rem;
    --font-size-h-mobile: 1rem;
    --font-size-p: .875rem;
    --font-size-p-mobile: 1rem;
    --line-height-base: 1.4;
    --color-bg: transparent;
    --color-fg: rgba(160,224,68,.9);
    --color-fg-dim: rgba(160,224,68,.5);
    --color-border: rgba(160,224,68,.4);
    --color-quote: rgba(160,224,68,.6);
    --color-blockquote-bg: rgba(0,255,65,.08);
    --color-code-bg: rgba(0,255,65,.08);
    --radius-lg: 7px;
    --radius-md: 5px;
    --radius-sm: 3px;
    --color-code: #a0e044;
    --theme-font-mono: Small,monospace;
    --code-font: Small,monospace;
    background-color: #000
}

*/