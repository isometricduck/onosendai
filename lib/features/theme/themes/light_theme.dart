import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/features/theme/theme.dart';

class LightTheme extends Theme {
  @override
  bool get isDark => false;

  @override
  IconData get icon => LucideIcons.sun;

  @override
  Color get foreground => Colors.black;

  @override
  Color get background => Color(int.parse('#efe5c0'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(int.parse('#a89984'.replaceAll('#', '0xFF')));

  @override
  Color get dimmed => Color(int.parse('#3a3a3a'.replaceAll('#', '0xFF')));

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

/*

[data-theme=light] {
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: .875rem;
    --font-size-h-mobile: 1rem;
    --font-size-p: .875rem;
    --font-size-p-mobile: 1rem;
    --line-height-base: 1.4;
    --color-bg: #efe5c0;
    --color-fg: #000;
    --color-fg-dim: #3a3a3a;
    --color-border: #a89984;
    --color-quote: #a89984;
    --color-blockquote-bg: rgba(0,0,0,.08);
    --color-code-bg: rgba(0,0,0,.08);
    --radius-lg: 7px;
    --radius-md: 5px;
    --radius-sm: 3px;
    --color-code: #941;
    --theme-font-mono: JetBrains Mono,Courier New,monospace;
    --code-font: JetBrains Mono,Courier New,monospace
}

*/
