import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class BubblegumTheme extends Theme {
  @override
  bool get isDark => false;

  @override
  IconData get icon => LucideIcons.candy;

  @override
  Color get foreground => Color(int.parse('#6b1a4a'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#ffe4f1'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(int.parse('#f5b5d1'.replaceAll('#', '0xFF')));

  @override
  Color get dimmed => Color(int.parse('#b86b93'.replaceAll('#', '0xFF')));

  @override
  TextStyle get font =>
      GoogleFonts.sniglet(fontSize: 16, fontWeight: FontWeight.w400);
}

/*

[data-theme=bubblegum] {
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: .875rem;
    --font-size-h-mobile: 1rem;
    --font-size-p: .875rem;
    --font-size-p-mobile: 1rem;
    --line-height-base: 1.4;
    --color-bg: #ffe4f1;
    --color-fg: #6b1a4a;
    --color-fg-dim: #b86b93;
    --color-border: #f5b5d1;
    --color-quote: #b86b93;
    --color-blockquote-bg: rgba(107,26,74,.06);
    --color-code-bg: #ffd0e5;
    --radius-lg: 7px;
    --radius-md: 5px;
    --radius-sm: 3px;
    --color-code: #c71585;
    --theme-font-mono: Sniglet,sans-serif;
    --code-font: JetBrains Mono,Courier New,monospace
}

*/